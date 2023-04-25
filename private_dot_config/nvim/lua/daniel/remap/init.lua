vim.g.mapleader = " "

local keymap = vim.keymap.set

keymap("n", "<Leader>pv", vim.cmd.Ex)
keymap("n", "<leader>pf", ":Telescope file_browser<CR>", { desc = "Open Telescope File Browser", noremap = true })
keymap("n", "<C-a>", "gg<S-v>G")

keymap("n", "ss", ":split<Return><C-w>w")
keymap("n", "sv", ":vsplit<Return><C-w>w")

keymap("n", "sh", "<C-w>h", {noremap = true})
keymap("n", "sj", "<C-w>j", {noremap = true})
keymap("n", "sl", "<C-w>l", {noremap = true})
keymap("n", "sk", "<C-w>k", {noremap = true})
keymap("n", "s<up>", "<C-w>k", {noremap = true})
keymap("n", "s<left>", "<C-w>h", {noremap = true})
keymap("n", "s<down>", "<C-w>j", {noremap = true})
keymap("n", "s<right>", "<C-w>l", {noremap = true})

-- move line
keymap("n", "<C-Down>", ":m .+1<Return>")
keymap("n", "<C-Up>", ":m .-2<Return>")

keymap("t", "<esc>", "<C-\\><C-n>")

keymap("n", "Q", "<nop>", { desc = "", noremap = true })
keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "" })
keymap("n", "<leader>f", function()
    vim.lsp.buf.format()
end, { desc = "Format buffer" })

keymap("n", "<C-d>", "<C-d>zz", { desc = "Jump 20 lines down", noremap = true })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Jump 20 lines up", noremap = true })

-- keymap("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "" })
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "" })

keymap("n", "tc", ":tab split<CR>", {desc = "open current file in new buffer", noremap = true })
keymap("n", "tn", ":tabn<CR>", {desc = "goto next buffer", noremap = true })
keymap("n", "tb", ":tabp<CR>", {desc = "goto prev buffer", noremap = true })

keymap("n", "<leader>y", "\"+y", { desc = "", noremap = true })
keymap("v", "<leader>y", "\"+y", { desc = "", noremap = true })
keymap("n", "<leader>Y", "\"+Y", { desc = "" })

keymap("n", "<leader>d", "\"_d", { desc = "", noremap = true })
keymap("v", "<leader>d", "\"_d", { desc = "", noremap = true })

keymap("n", "<leader>u", vim.cmd.UndotreeToggle, {desc = "Toggle Undotree", noremap = true})

require("daniel.remap.lspsaga")
require("daniel.remap.telescope")
require("daniel.remap.harpoon")
