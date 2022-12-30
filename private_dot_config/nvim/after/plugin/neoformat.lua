-- let g:neoformat_try_node_exe = 1
--vim.api.nvim_exec([[ let g:neoformat_try_node_exe = 1 ]])
vim.api.nvim_exec([[ autocmd BufWritePre,TextChanged,InsertLeave *.js Neoformat ]], false)
