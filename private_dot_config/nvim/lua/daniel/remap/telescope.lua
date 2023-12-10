local keymap = vim.keymap.set

require("telescope").load_extension("harpoon")

keymap("n", "<C-p>", ":Telescope", { noremap = true })
keymap("n", "<leader>ps", function()
	require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ") })
end, { desc = "Telescope search in file", noremap = true })
keymap("n", "<C-p>", function()
	require("telescope.builtin").git_files()
end, { desc = "Telescope search in git", noremap = true })
keymap("n", "<Leader>pf", function()
	require("telescope.builtin").find_files()
end, { desc = "Telescope search for files", noremap = true })

keymap("n", "<Leader>pp", function()
	require("telescope.builtin").live_grep()
end, { desc = "Telescope live search for string", noremap = true })

keymap("n", "<Leader>ph", ":Telescope harpoon marks<CR>", { noremap = true, desc = "Search in Harpoon marks" })

keymap("n", "<leader>pw", function()
	require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Search for string", noremap = true })
keymap("n", "<leader>pb", function()
	require("telescope.builtin").buffers()
end, { desc = "Search in buffers", noremap = true })
keymap("n", "<leader>vh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Search in NVIM doc", noremap = true })

-- TODO: Fix this immediately
keymap("n", "<leader>vwh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Search builtin functions", noremap = true })

keymap("n", "<leader>vrc", function()
	require("daniel.telescope").search_dotfiles()
end, { desc = "Telescope search dot files", noremap = true })

keymap("n", "<leader>gc", function()
	require("daniel.telescope").git_branches()
end, { desc = "View git branches", noremap = true })
keymap("n", "<leader>gw", function()
	require("telescope").extensions.git_worktree.git_worktrees()
end, { desc = "View git worktrees", noremap = true })
keymap("n", "<leader>gm", function()
	require("telescope").extensions.git_worktree.create_git_worktree()
end, { desc = "Git checkout remote branch", noremap = true })

keymap("n", "<leader>pm", ":Telescope harpoon marks<CR>", { desc = "Telescope: Harpoon marks" })
