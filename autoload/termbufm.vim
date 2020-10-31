if exists("g:termbufm_autoloaded") | finish | endif
let g:termbufm_autoloaded=1

function! termbufm#load_terminal_keymaps()
	tnoremap <Esc> <C-\><C-n>
endfunction

function! termbufm#load_keymaps()
	" load example keymaps
	nnoremap <silent> <leader>tb :TBuild<CR>
	nnoremap <silent> <leader>tr :TRun<CR>
	nnoremap <silent> <leader>tt :call TermBufMToggle()<CR>
	nnoremap <silent> <leader>tw :sb termbufm_b<CR>i<Up><CR><C-\><C-n><C-w><C-p>
endfunction
