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
  if !exists("b:cmd") || b:cmd == ''
    call run#Log('No cmd supplied', 'warning')
    return
  endif

  update

  let output = s:RunCmd(b:cmd)
  if v:shell_error == 0 && b:cmd_plus != ''
    let output_plus = s:RunCmd(b:cmd_plus)
    if output_plus != ''
      let output = output
            \."\n-------------------------------------------------------\n"
            \.output_plus
    endif
  endif

  let filetype = &filetype
  if output != ''
    call run#Log('output: '.output)
    call s:ShowOutput(output, filetype)
  else
    call run#Log('Empty output')
  endif
endfunction

function! s:PrepareCmd(cmd)
  let cmd = a:cmd
  if cmd =~ '%:r' || cmd =~ '%'
    let cmd = substitute(cmd, "%:r", expand("%:r"), 'g')
    let cmd = substitute(cmd, '%', bufname('%'), 'g')
  else
    let cmd = cmd.' '.bufname('%')
  endif
  return cmd
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
  let cmd = s:PrepareCmd(a:cmd)
  call run#Log('cmd: '.cmd)

  let tmpfile = tempname()
  let output = system(cmd.' 2>'.tmpfile)
  let stderr = join(readfile(tmpfile), "\n")
  if stderr != ''
    let output = output
          \."\n--------------------- Exception ---------------------\n"
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

function! run#Log(msg, ...)
  if s:debug
    if a:0 == 1 && a:1 == 'warning'
      echohl WarningMsg
      echom '['.s:name.'] '. a:msg
      echohl None
    else
      echom '['.s:name.'] '.a:msg
    endif
  endif
endfunction
"""}}}

" vim: fdm=marker
