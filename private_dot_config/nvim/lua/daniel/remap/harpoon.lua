local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local keymap = vim.keymap.set

keymap("n", "<Leader>a", function() mark.toggle_file() end, {noremap = true, desc = "Toggle harpoon mark"})
keymap("n", "<Leader>mn", function() ui.nav_next() end, {noremap = true, desc = "Toggle harpoon mark"})
keymap("n", "<Leader>ml", function() ui.nav_prev() end, {noremap = true, desc = "Toggle harpoon mark"})

for i=1,9 do
  keymap("n", "<Leader>m" .. i, function() ui.nav_file(i) end, {noremap = true, desc = "Navigate to harpoon file nr " .. i})
end
