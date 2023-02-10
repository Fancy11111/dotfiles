vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pf", ":Telescope file_browser", { desc = "Open Telescope File Browser", noremap = true })
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

vim.keymap.set("n", "ss", ":split<Return><C-w>w")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")

vim.keymap.set("n", "sh", "<C-w>h", {noremap = true})
vim.keymap.set("n", "sj", "<C-w>j", {noremap = true})
vim.keymap.set("n", "sl", "<C-w>l", {noremap = true})
vim.keymap.set("n", "sk", "<C-w>k", {noremap = true})
vim.keymap.set("n", "s<up>", "<C-w>k", {noremap = true})
vim.keymap.set("n", "s<left>", "<C-w>h", {noremap = true})
vim.keymap.set("n", "s<down>", "<C-w>j", {noremap = true})
vim.keymap.set("n", "s<right>", "<C-w>l", {noremap = true})

-- move line
vim.keymap.set("n", "<C-Down>", ":m .+1<Return>")
vim.keymap.set("n", "<C-Up>", ":m .-2<Return>")

vim.keymap.set("t", "<esc>", "<C-\\><C-n>")

vim.keymap.set("n", "Q", "<nop>", { desc = "", noremap = true })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "" })
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end, { desc = "Format buffer" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump 20 lines down", noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump 20 lines up", noremap = true })

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "" })

vim.keymap.set("n", "tc", ":tab split<CR>", {desc = "open current file in new buffer", noremap = true })
vim.keymap.set("n", "tn", ":tabn<CR>", {desc = "goto next buffer", noremap = true })
vim.keymap.set("n", "tb", ":tabp<CR>", {desc = "goto prev buffer", noremap = true })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "", noremap = true })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "", noremap = true })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "" })

vim.keymap.set("n", "<leader>d", "\"_d", { desc = "", noremap = true })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "", noremap = true })
