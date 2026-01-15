require("daniel.opts")

require("daniel.lazy")

require("daniel.lsp")

require("daniel.autocmds")
require("daniel.keymaps")
require("daniel.wsl")

vim.cmd.colorscheme("teide-dimmed")

-- You can configure highlights by doing something like:
vim.cmd.hi("Comment gui=none")

require("daniel.rust")
