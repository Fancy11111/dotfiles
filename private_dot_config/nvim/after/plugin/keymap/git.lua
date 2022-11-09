local Remap = require("daniel.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<leader>gs", "<Cmd>Git status<CR>", {desc = "Git status"})
nnoremap("<leader>gc", "<Cmd>Git commit<CR>", {desc = "Git commit"})


