local nnoremap = require("daniel.keymap").nnoremap
local tnoremap = require("daniel.keymap").tnoremap
nnoremap("<leader>pv", "<cmd>Ex<CR>")

nnoremap("<C-a>", "gg<S-v>G")



-- window

nnoremap("ss", ":split<Return><C-w>w")
nnoremap("sv", ":vsplit<Return><C-w>w")

nnoremap("sh", "<C-w>h")
nnoremap("sk", "<C-w>k")
nnoremap("sj", "<C-w>j")
nnoremap("sl", "<C-w>l")
nnoremap("s<left>", "<C-w>h")
nnoremap("s<up>", "<C-w>k")
nnoremap("s<down>", "<C-w>j")
nnoremap("s<right>", "<C-w>l")

-- move line
nnoremap("<C-Down>", ":m .+1<Return>")
nnoremap("<C-Up>", ":m .-2<Return>")


tnoremap("<esc>", "<C-\\><C-n>")
