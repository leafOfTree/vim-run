let s:run_mapping = exists('g:run_mapping') ? g:run_mapping : 'go'

execute 'nnoremap '.s:run_mapping.' :call run#Run()<cr>'

augroup run
  autocmd!
  autocmd FileType * :call run#Update()
augroup end
