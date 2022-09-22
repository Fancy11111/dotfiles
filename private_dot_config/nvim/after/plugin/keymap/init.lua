local Remap = require("daniel.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

-- nnoremap("<leader>pv", ":NvimTreeOpen<CR>")
-- nnoremap("<leader>u", ":UndotreeShow<CR>")
nnoremap("<leader>pv", ":Ex<CR>", {desc = "Open File browser"})
nnoremap("<leader>pf", ":Telescope file_browser", {desc = "Open Telescope File Browser"})

vnoremap("J", ":m '>+1<CR>gv=gv", {desc = ""})
vnoremap("K", ":m '<-2<CR>gv=gv", {desc = ""})

nnoremap("Y", "yg$", {desc = ""})
nnoremap("n", "nzzzv", {desc = ""})
nnoremap("N", "Nzzzv", {desc = ""})
nnoremap("J", "mzJ`z", {desc = ""})
nnoremap("<C-d>", "<C-d>zz", {desc = "Jump 20 lines down"})
nnoremap("<C-u>", "<C-u>zz", {desc = "Jump 20 lines up"})

-- greatest remap ever
xnoremap("<leader>p", "\"_dP", {desc = ""})

-- next greatest remap ever : asbjornHaland
nnoremap("<leader>y", "\"+y", {desc = ""})
vnoremap("<leader>y", "\"+y", {desc = ""})
nmap("<leader>Y", "\"+Y", {desc = ""})

nnoremap("<leader>d", "\"_d", {desc = ""})
vnoremap("<leader>d", "\"_d", {desc = ""})

vnoremap("<leader>d", "\"_d", {desc = ""})

-- This is going to get me cancelled
--inoremap("<C-c>", "<Esc>")

nnoremap("Q", "<nop>", {desc = ""})
nnoremap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", {desc = ""})
nnoremap("<leader>f", function()
    vim.lsp.buf.format()
end, {desc = ""})

nnoremap("<C-k>", "<cmd>cnext<CR>zz", {desc = ""})
nnoremap("<C-j>", "<cmd>cprev<CR>zz", {desc = ""})
nnoremap("<leader>k", "<cmd>lnext<CR>zz", {desc = ""})
nnoremap("<leader>j", "<cmd>lprev<CR>zz", {desc = ""})

nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", {desc = ""})
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, {desc = ""})

nnoremap("<leader>tc", function()
    tail.reset()
    tmux.reset()
end, {desc = ""});

nnoremap("<leader>ta", function()
    tail.reset()
    tmux.reset()
end, {desc = ""});
