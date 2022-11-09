local vnoremap = require('daniel.keymap').vnoremap
local nnoremap = require('daniel.keymap').nnoremap

nnoremap("<C-k><C-c>", "gcc", {desc = "Comment with line comment"})
vnoremap("<C-k><C-c>", "gcc", {desc = "Comment with block comment"})
