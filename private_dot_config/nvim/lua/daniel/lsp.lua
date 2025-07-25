local utils = require("daniel.utils")
local capabilities = utils.lsp_capabilities()

local servers = {
	"lua_ls",
	"volar",
	"jdtls",
	"tinymist",
	"tailwindcss",
	"bashls",
	"html",
	"cssls",
	"ts_ls",
	"zls",
}

vim.lsp.config("*", {
	capabilities = capabilities,
})

-- vim.diagnostic.config({
-- 	virtual_lines = {
-- 		current_line = true,
-- 	},
-- })

vim.lsp.config("ts_ls", {
	-- init_options = {
	-- 	plugins = {
	-- 		{
	-- 			name = "@vue/typescript-plugin",
	-- 			location = "/home/daniel/.nvm/versions/node/v22.15.0/lib/node_modules/@vue/typescript-plugin",
	-- 			languages = { "javascript", "typescript", "vue" },
	-- 		},
	-- 	},
	-- },
	filetypes = {
		"javascript",
		"typescript",
		"vue",
	},
})

vim.lsp.config("tailwindcss", {
	filetypes = {
		"aspnetcorerazor",
		"astro",
		"astro-markdown",
		"blade",
		"clojure",
		"django-html",
		"htmldjango",
		"edge",
		"eelixir",
		"elixir",
		"ejs",
		"erb",
		"eruby",
		"gohtml",
		"gohtmltmpl",
		"haml",
		"handlebars",
		"hbs",
		"html",
		"htmlangular",
		"html-eex",
		"heex",
		"jade",
		"leaf",
		"liquid",
		"markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"razor",
		"slim",
		"twig",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"sugarss",
		"javascript",
		"javascriptreact",
		"reason",
		"rescript",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"templ",
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		utils.lsp_on_attach(event.data.client, event.buf)
	end,
})

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
