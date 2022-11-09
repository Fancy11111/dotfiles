local Remap = require("daniel.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<C-p>", ":Telescope")
nnoremap("<leader>ps", function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})
end, {desc = "Telescope search in file"})
nnoremap("<C-p>", function()
    require('telescope.builtin').git_files()
end, {desc = "Telescope search in git"})
nnoremap("<Leader>pf", function()
    require('telescope.builtin').find_files()
end, {desc = "Telescope search for files"})

nnoremap("<Leader>pp", function()
    require('telescope.builtin').live_grep()
end, {desc = "Telescope live search for string"})

nnoremap("<leader>pw", function()
    require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
end, {desc = "Search for string"})
nnoremap("<leader>pb", function()
    require('telescope.builtin').buffers()
end, {desc = "Search in buffers"})
nnoremap("<leader>vh", function()
    require('telescope.builtin').help_tags()
end, {desc = "Search in NVIM doc"})

-- TODO: Fix this immediately
nnoremap("<leader>vwh", function()
    require('telescope.builtin').help_tags()
end, {desc = "Search builtin functions"})

nnoremap("<leader>vrc", function()
    require('daniel.telescope').search_dotfiles({ hidden = true })
end, { desc = "Telescope search dot files"})
--nnoremap("<leader>va", function()
--    require('daniel.telescope').anime_selector()
--end)
--nnoremap("<leader>vc", function()
--    require('daniel.telescope').chat_selector()
--end)
nnoremap("<leader>gc", function()
    require('daniel.telescope').git_branches()
end, {desc = "View git branches"})
nnoremap("<leader>gw", function()
    require('telescope').extensions.git_worktree.git_worktrees()
end, {desc = "View git worktrees"})
nnoremap("<leader>gm", function()
    require('telescope').extensions.git_worktree.create_git_worktree()
end, {desc = "Git checkout remote branch"})
nnoremap("<leader>pd", function()
    require('daniel.telescope').dev()
end)



