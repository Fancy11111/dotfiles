local utils = require("daniel.utils")
local capabilities = utils.lsp_capabilities()

local servers = {
	"lua_ls",
	"ts_ls",
	"vue_ls",
	"jdtls",
	"typst",
	"bashls",
	"html",
	"cssls",
	"pyright",
}

vim.lsp.config("*", {
	capabilities = capabilities,
})

-- vim.lsp.config("ts_ls", {
-- 	init_options = {
-- 		plugins = {
-- 			{
-- 				name = "@vue/typescript-plugin",
-- 				location = "/home/daniel/.nvm/versions/node/v22.15.0/lib/node_modules/@vue/typescript-plugin",
-- 				languages = { "javascript", "typescript", "vue" },
-- 			},
-- 		},
-- 	},
-- 	filetypes = {
-- 		"javascript",
-- 		"typescript",
-- 		"vue",
-- 	},
-- })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		utils.lsp_on_attach(event.data.client, event.buf)
	end,
})

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
