"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Config {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:debug = exists('g:run_debug') ? g:run_debug : 0
let s:output_focus = exists('g:run_output_focus') 
      \ ? g:run_output_focus : 0
let s:output_scroll_bottom = exists('g:run_output_scroll_bottom') 
      \ ? g:run_output_scroll_bottom : 0
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Variables {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:name = 'vim-run'
let s:output_win = '__output__'
let b:cmd = ''
let b:cmd_plus = ''
"""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! run#Run()
  if b:cmd == ''
    call run#Log('No cmd supplied')
    return
  else
    call run#Log('cmd: '.b:cmd)
  endif

  update
  let cmd = s:PrepareCmd(b:cmd)
  let output = s:RunCmd(cmd)
  let output = output
        \."\n----------------------------------------------------------\n"
  if v:shell_error == 0 && b:cmd_plus != ''
    let output = output.s:RunCmd(b:cmd_plus)
  endif

  let filetype = &filetype
  call s:ShowOutput(output, filetype)

endfunction

function! s:PrepareCmd(cmd)
  return a:cmd.' '.bufname('%')
endfunction

function! s:ShowOutput(output, filetype)
  let output_winnr = bufwinnr(s:output_win)
  if output_winnr == -1
    silent execute 'split '.s:output_win
  else
    execute output_winnr.'wincmd w'
  endif

  call s:SetOutputBuffer(a:filetype)

  " Insert the output
  call append(0, split(a:output, '\n'))
  normal! zR
  if s:output_scroll_bottom
    normal! G
  else
    normal! gg
  endif

  " Go to previous window
  if !s:output_focus
    wincmd p
  endif
endfunction

function! s:RunCmd(cmd)
  let tmpfile = tempname()
  let output = system(a:cmd.' 2>'.tmpfile)
  let stderr = join(readfile(tmpfile), "\n")
  if stderr != ''
    let output = output
          \."\n------------------- Exception -------------------\n"
          \.stderr
  endif
  return output
endfunction

function! s:SetOutputBuffer(filetype)
  normal! ggdG
  setlocal buftype=nofile foldmethod=indent
  let &filetype = a:filetype
  nnoremap <buffer> q :quit<cr>

  syntax match OutputMsg /\v\c^.*(errors?|warnings?|notes?).*/
        \ contains=Error,Warning,Note
  syntax match Error /\v\cerrors?/
  syntax match Warning /\v\cwarnings?/
  syntax match Note /\v\cnotes?/
  highlight default link Warning Type
  highlight default link Note Statement
endfunction

function! run#Update()
  let filetype = &filetype

  let b:cmd = g:run_cmd[filetype]
  if has_key(g:run_cmd, filetype.'_plus')
    let b:cmd_plus = g:run_cmd[filetype.'_plus']
  else
    let b:cmd_plus = ''
  endif
endfunction

function! run#Log(msg)
  if s:debug
    echom '['.s:name.'] '.a:msg
  endif
endfunction
"""}}}

" vim: fdm=marker
