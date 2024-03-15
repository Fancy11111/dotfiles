-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
	library = {
		enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
		-- these settings will be used for your Neovim config directory
		runtime = true, -- runtime path
		types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
		plugins = true, -- installed opt or start plugins in packpath
		-- you can also specify the list of plugins to make available as a workspace library
		-- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
	},
	setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
	-- for your Neovim config directory, the config.library settings will be used as is
	-- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
	-- for any other directory, config.library.enabled will be set to false
	override = function(root_dir, options) end,
	-- With lspconfig, Neodev will automatically setup your lua-language-server
	-- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
	-- in your lsp start options
	lspconfig = true,
	-- much faster, but needs a recent built of lua-language-server
	-- needs lua-language-server >= 3.6.0
	pathStrict = true,
})

-- SCALA

local metals_config = require("metals").bare_config()
-- metals_config.settings = {
-- showImplicitArguments = true,
-- excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
-- }

-- metals_config.init_options.statusBarProvider = "on"

metals_config.setting = {
	useGlobalExecutable = true,
}
--
-- local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
-- 	-- NOTE: You may or may not want java included here. You will need it if you
-- 	-- want basic Java support but it may also conflict if you are using
-- 	-- something like nvim-jdtls which also works on a java filetype autocmd.
-- 	pattern = { "scala", "sbt" },
-- 	callback = function()
-- 		require("metals").initialize_or_attach(metals_config)
-- 	end,
-- 	group = nvim_metals_group,
-- })

local lsp = require("lsp-zero").preset({
	name = "minimal",
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = true,
})

lsp.configure("lua_lsp", {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})

local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
local codelens_helpers = require("daniel.lsp.codelens")

lsp.configure("ocamllsp", {
	on_init = function(client, bufnr)
		vim.api.nvim_clear_autocmds({ group = augroup_codelens, buffer = 0 })
		vim.keymap.set(
			"n",
			"<space>tt",
			require("daniel.lsp.codelens").toggle_virtlines,
			{ silent = true, desc = "Toggle Codelens" }
		)
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePos", "CursorHold" }, {
			group = augroup_codelens,
			callback = function()
				print("callback")
				-- codelens_helpers.refresh_virtlines()
			end,
			buffer = 0,
		})
	end,
	settings = {
		codelens = { enable = true },
	},
	get_language_id = function(_, ftype)
		return ftype
	end,
})

lsp.configure("metals", { force_setup = true })

lsp.configure("gopls", {
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
	cmd = { "gopls" },
	settings = {
		completeUnimported = true,
		usePlaceholders = true,
		analyses = {
			unusedparams = true,
		},
	},
})

lsp.configure("volar", {
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

lsp.configure("templ", {
	filetypes = { "templ" },
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

local cmp = require("cmp")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local select_opts = { behavior = cmp.SelectBehavior.Select }

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done({
		map_char = {
			tex = "",
		},
	})
)

local luasnip = require("luasnip")

luasnip.config.set_config({
	region_check_events = "InsertEnter",
	delete_check_events = "InsertLeave",
})

-- require("luasnip.loaders.from_vscode").lazy_load()

lsp.setup_nvim_cmp({
	sources = {
		{ name = "nvim_lsp", keyword_length = 1 },
		{ name = "luasnip", keyword_length = 2 },
		{ name = "path" },
		{ name = "nvim_lua", keyword_length = 1 },
		{ name = "jdtls" },
		{ name = "buffer", keyword_length = 3 },
		-- { name = 'cmdline',  keyword_length = 2 }
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = require("lspkind").cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		}),
	},
	mapping = {
		-- confirm selection
		-- ["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),

		-- navigate items on the list
		["<Up>"] = cmp.mapping.select_prev_item(select_opts),
		["<Down>"] = cmp.mapping.select_next_item(select_opts),
		["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
		["<C-n>"] = cmp.mapping.select_next_item(select_opts),

		-- scroll up and down in the completion documentation
		["<C-d>"] = cmp.mapping.scroll_docs(5),
		["<C-u>"] = cmp.mapping.scroll_docs(-5),

		-- toggle completion
		["<C-e>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort()
				fallback()
			else
				cmp.complete()
			end
		end),

		-- go to next placeholder in the snippet
		["<C-l>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		-- go to previous placeholder in the snippet
		["<C-b>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		-- when menu is visible, navigate to next item
		-- when line is empty, insert a tab character
		-- else, activate completion
		["<Tab>"] = cmp.mapping(function(fallback)
			local col = vim.fn.col(".") - 1
			if cmp.visible() then
				cmp.select_next_item(select_opts)
			-- elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
			else
				fallback()
				-- cmp.complete()
			end
		end, { "i", "s" }),

		-- when menu is visible, navigate to previous item on list
		-- else, revert to default behavior
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
})

lsp.setup()

local null_ls = require("null-ls")
local gofmt_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- null_ls.builtins.formatting.prettier,
		-- null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.goimports,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = gofmt_augroup,
				buffer = bufnr,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = gofmt_augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})

-- metals_config.on_attach = function(client, bufnr)
-- 	require("metals").setup_dap()
-- end
--
-- local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
-- 	-- NOTE: You may or may not want java included here. You will need it if you
-- 	-- want basic Java support but it may also conflict if you are using
-- 	-- something like nvim-jdtls which also works on a java filetype autocmd.
-- 	pattern = { "scala", "sbt", "java" },
-- 	callback = function()
-- 		require("metals").initialize_or_attach(metals_config)
-- 	end,
-- 	group = nvim_metals_group,
-- })
