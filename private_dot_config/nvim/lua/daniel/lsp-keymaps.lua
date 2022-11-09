local Remap = require("daniel.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local M = {}

local function code_actions_keymap()
    nnoremap("<leader>cgd", function() vim.lsp.buf.definition() end, { desc = "Goto definition" })
    nnoremap("<leader>ch", function() vim.lsp.buf.hover() end, { desc = "Hover symbol" })
    nnoremap("<leader>cws", function() vim.lsp.buf.workspace_symbol() end, { desc = "Display workspace symbol" })
    nnoremap("<leader>cd", function() vim.diagnostic.open_float() end, { desc = "Toggle error/warning display" })
    nnoremap("<leader>cn", function() vim.diagnostic.goto_next() end, { desc = "Display next warning/error" })
    nnoremap("<leader>cb", function() vim.diagnostic.goto_prev() end, { desc = "Display previous warning/error" })
    nnoremap("<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "List code actions" })
    nnoremap("<leader>crf", function() vim.lsp.buf.references() end, { desc = "Find references" })
    nnoremap("<leader>crn", function() vim.lsp.buf.rename() end, { desc = "Rename symbol" })
    inoremap("<C-h>", function() vim.lsp.buf.signature_help() end, { desc = "Get signature help" })
end

M.code_actions_keymap = code_actions_keymap
return M
