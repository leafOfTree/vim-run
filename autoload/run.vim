"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Settings {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:run_debug = exists('g:run_debug') ? g:run_debug : 0
let s:name = 'vim-run'
let s:output_win = '__output__'
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Variables {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let b:cmd = ''
let b:output_cmd = ''
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

  let output = system(b:cmd.' '.bufname('%'))
  if output == '' && b:output_cmd != ''
    let output = system(b:output_cmd)
  endif

  let filetype = &filetype

  let output_winnr = bufwinnr(s:output_win)
  if output_winnr == -1
    execute 'split '.s:output_win
  else
    execute output_winnr.'wincmd w'
  endif

  normal! ggdG

  setlocal buftype=nofile foldmethod=indent
  let &filetype = filetype
  nnoremap <buffer> q :quit<cr>

  " Insert the output
  call append(0, split(output, '\n'))
  normal! gg
  normal! zR
endfunction

function! run#Update()
  let filetype = &filetype

  let g_cmd = 'g:run_cmd_'.filetype
  let g_output_cmd = 'g:run_output_cmd_'.filetype
  if exists(g_cmd)
    let b:cmd = eval(g_cmd)
  else
    let b:cmd = ''
  endif
  if exists(g_output_cmd)
    let b:output_cmd = eval(g_output_cmd)
  else
    let b:output_cmd = ''
  endif
endfunction

function! run#Log(msg)
  if s:run_debug
    echom '['.s:name.'] '.a:msg
  endif
endfunction
"""}}}

" vim: fdm=marker
