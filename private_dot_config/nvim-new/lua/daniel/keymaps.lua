-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "ss", "<C-w><C-s>", { desc = "Split horizontal" })
vim.keymap.set("n", "sv", "<C-w><C-v>", { desc = "Split vertical" })
vim.keymap.set("n", "sh", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "sl", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "sj", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "sk", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-D>", "<C-D>zz", { desc = "Page Down" })
vim.keymap.set("n", "<C-U>", "<C-U>zz", { desc = "Page Down" })

vim.keymap.set("n", "<leader>lo", ":so %<CR>", { desc = "Reload current file" })

vim.keymap.set("n", "<leader>xf", "<cmd>!chmod +x %<CR>", { desc = "make current file executable" })
