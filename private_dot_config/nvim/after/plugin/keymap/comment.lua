local vnoremap = require('daniel.keymap').vnoremap
local nnoremap = require('daniel.keymap').nnoremap

nnoremap("<C-k><C-c>", "gcc")
vnoremap("<C-k><C-c>", "gcc")
