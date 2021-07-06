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
let s:plus_split = "\n-------------------------------------------------------\n"
let s:error_split = "\n--------------------- Shell Error ---------------------\n"
let b:cmd = ''
let b:cmd_plus = ''
let s:tmpfile = tempname()
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
  if v:shell_error == 0 && exists("b:cmd_plus") && b:cmd_plus != ''
    let output_plus = s:RunCmd(b:cmd_plus)
    if output_plus != ''
      if output != ''
        let output = output
              \.s:plus_split
              \.output_plus
      else
        let output = output_plus
      endif
    endif
  endif

  let filetype = &filetype

  if output != '' || bufwinnr(s:output_win) != -1
    call run#Log('output: '.output)
    call s:ShowOutput(output, filetype)
  else
    call run#Log('Skip empty output')
  endif
endfunction

" Replace/Add arguments to cmd
function! s:PrepareCmd(cmd)
  let cmd = a:cmd
  if cmd =~ '%'
    if cmd =~ '%:r'
      let cmd = substitute(cmd, "%:r", expand("%:r"), 'g')
    endif
    if cmd =~ '%t'
      let cmd = substitute(cmd, '%temp', s:tmpfile, 'g')
    endif
    if cmd =~ '%' 
      let cmd = substitute(cmd, '%', bufname('%'), 'g')
    endif
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
  if &filetype == 'vim' && a:cmd == 'source'
    let output = s:SourceVimscript()
  else
    let cmd = s:PrepareCmd(a:cmd)
    call run#Log('cmd: '.cmd)

    silent let output = system(cmd)
    if v:shell_error && output == ''
      let output = output
            \.s:error_split
            \.v:shell_error
    endif
  endif
  return output
endfunction

function! s:SourceVimscript()
  let vimscript_output = ''
  redir => vimscript_output
  silent! source %
  redir END
  return vimscript_output
endfunction

function! s:SetOutputBuffer(filetype)
  normal! ggdG
  setlocal buftype=nofile foldmethod=indent filetype=run nobuflisted
  nnoremap <buffer> q :quit<cr>
  execute 'runtime syntax/run-'.a:filetype.'.vim'
endfunction

function! run#Update()
  let filetype = &filetype

  if has_key(g:run_cmd, filetype)
    let b:cmd = g:run_cmd[filetype]
  else
    let b:cmd = ''
  endif
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
