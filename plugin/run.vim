let s:run_mapping = exists('g:run_mapping') ? g:run_mapping : 'go'
let s:run_debug = exists('g:run_debug') ? g:run_debug : 0

if s:run_debug
  execute 'nnoremap '.s:run_mapping.' :call run#Run()<cr>'
else
  execute 'nnoremap '.s:run_mapping.' :silent call run#Run()<cr>'
endif

augroup run
  autocmd!
  autocmd FileType * :call run#Update()
augroup end
