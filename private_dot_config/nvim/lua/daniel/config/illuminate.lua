local status_ok, illuminate = pcall(require, "illuminate")
if not status_ok then
  return
end

illuminate.configure({
    providers = {
        'lsp',
        'treesitter',
        'regex'
    },
    delay = 200,
    under_cursor = true,
    filetypes_denylist = {
        'dirvish',
        'fugitive',
        'alpha', 
        'NvimTree'
    },
})

vim.api.nvim_exec([[
    hi def IlluminateWordText gui=underline
]], false)
