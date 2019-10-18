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
let b:cmd_plus = ''
"""}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Functions {{{
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! run#Run()
  let save_showcmd = &showcmd
  let &showcmd = 0
  if b:cmd == ''
    call run#Log('No cmd supplied')
    return
  else
    call run#Log('cmd: '.b:cmd)
  endif

  update
  let output = system(b:cmd.' '.bufname('%'))
  if b:cmd_plus != ''
    let output = output
          \."\n----------------- Output -----------------\n"
          \.system(b:cmd_plus)
  endif

  let &showcmd = save_showcmd
  let output_winnr = bufwinnr(s:output_win)
  if output_winnr == -1
    silent execute 'split '.s:output_win
  else
    execute output_winnr.'wincmd w'
  endif

  call s:SetOutputBuffer(&filetype)

  " Insert the output
  call append(0, split(output, '\n'))
  normal! gg
  normal! zR
endfunction

function! s:SetOutputBuffer(filetype)
  normal! ggdG
  setlocal buftype=nofile foldmethod=indent
  let &filetype = a:filetype
  nnoremap <buffer> q :quit<cr>

  syntax match OutputMsg /\v^.*(errors?|warnings?|notes?).*/
        \ contains=Error,Warning,Note
  syntax match Error /\verrors?/
  syntax match Warning /\vwarnings?/
  syntax match Note /\vnotes?/
  highlight default link Warning Type
  highlight default link Note Statement
endfunction

function! run#Update()
  let filetype = &filetype

  let g_cmd = 'g:run_cmd_'.filetype
  let g_cmd_plus = 'g:run_cmd_plus_'.filetype
  if exists(g_cmd)
    let b:cmd = eval(g_cmd)
  else
    let b:cmd = ''
  endif
  if exists(g_cmd_plus)
    let b:cmd_plus = eval(g_cmd_plus)
  else
    let b:cmd_plus = ''
  endif
endfunction

function! run#Log(msg)
  if s:run_debug
    echom '['.s:name.'] '.a:msg
  endif
endfunction
"""}}}

" vim: fdm=marker
