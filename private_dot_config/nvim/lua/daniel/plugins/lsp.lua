return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
			build = function()
				pcall(vim.cmd, "MasonUpdate")
			end,
		},
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ "WhoIsSethDaniel/mason-lspconfig.nvim" },
		{
			"nvimdev/lspsaga.nvim",
			event = "BufRead",
			config = function() end,
			dependencies = { { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" } },
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"roobert/tailwindcss-colorizer-cmp.nvim",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"micangl/cmp-vimtex",
				"onsails/lspkind-nvim",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"kristijanhusak/vim-dadbod-completion",
			},
		},

		{
			"VonHeikemen/lsp-zero.nvim",
			branch = "v3.x",
		},
		{ "j-hui/fidget.nvim" },

		-- DAP
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				{
					"theHamsta/nvim-dap-virtual-text",
				},
				"rcarriga/nvim-dap-ui",
				{
					"leoluz/nvim-dap-go",
				},
			},
		},

		-- Language specific plugins
		{ "folke/neodev.nvim", lazy = false },
		{ "jose-elias-alvarez/typescript.nvim", lazy = false },

		{ "jose-elias-alvarez/null-ls.nvim" },
		{
			"ray-x/go.nvim",
			lazy = false,
			dependencies = { "ray-x/guihua.lua" },
			config = function() end,
			build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
		},
		{
			"scalameta/nvim-metals",
			requires = { "nvim-lua/plenary.nvim" },
		},
		-- "github/copilot.vim",
		"mfussenegger/nvim-jdtls",
		{
			"mrcjkb/haskell-tools.nvim",
			version = "^3", -- Recommended
			ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
		},
	},
	config = function()
		local keymap = vim.keymap.set
		local format_group = vim.api.nvim_create_augroup("LspFormatGroup", {})
		local format_opts = { async = false, timeout_ms = 2500 }

		local function register_fmt_keymap(name, bufnr)
			local fmt_keymap = "<leader>f"
			vim.keymap.set("n", fmt_keymap, function()
				vim.lsp.buf.format(vim.tbl_extend("force", format_opts, { name = name, bufnr = bufnr }))
			end, { desc = "Format current buffer [LSP]", buffer = bufnr })
		end

		local function register_fmt_autosave(name, bufnr)
			vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_group,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format(vim.tbl_extend("force", format_opts, { name = name, bufnr = bufnr }))
				end,
				desc = "Format on save [LSP]",
			})
		end

		require("fidget").setup({})

		require("lspsaga").setup({
			lightbulb = {
				debounce = 500,
				virtual_text = false,
				sign = true,
			},
			ui = {
				border = "rounded",
			},
			symbol_in_winbar = { enable = false },
		})

		local function on_attach(client, bufnr)
			require("daniel.lsp.keymap").setup_keymap(bufnr)
			-- Register formatting and autoformatting
			-- based on lsp server
			if client.name == "gopls" then
				register_fmt_keymap(client.name, bufnr)
				register_fmt_autosave(client.name, bufnr)
				keymap("n", "<leader>dgt", function()
					require("dap-go").debug_test()
				end, {
					buffer = bufnr,
					desc = "Debug go test",
				})
				keymap("n", "<leader>dgl", function()
					require("dap-go").debug_last()
				end, {
					buffer = bufnr,
					desc = "Debug last go test",
				})

				keymap("n", "<leader>gsj", "<cmd>GoTagAdd json<CR>", { buffer = bufnr, desc = "Add json struct tags" })
				keymap("n", "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", { buffer = bufnr, desc = "Add yaml struct tags" })
			end

			if client.name == "null-ls" then
				register_fmt_keymap(client.name, bufnr)
				register_fmt_autosave(client.name, bufnr)
			end
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.preselectSupport = true
		capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		}

		vim.diagnostic.config({
			virtual_text = {
				severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
			},
		})

		-- List out the lsp servers, linters, formatters
		-- for mason

		local tools = {
			"black",
			"eslint_d",
			"stylua",
			"prettier",
		}

		require("mason-tool-installer").setup({ ensure_installed = tools })

		-- Register your lsp servers
		-- if they depend on an extra plugin (eg go.nvim)
		-- then call those in this section
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

		-- metals_config.settings = {
		-- showImplicitArguments = true,
		-- excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
		-- }

		-- metals_config.init_options.statusBarProvider = "on"

		local lsp_zero = require("lsp-zero")
		lsp_zero.on_attach(on_attach)
		lsp_zero.set_server_config({
			on_init = function(client)
				client.server_capabilities.semanticTokensProvider = nil
			end,
		})

		local lsp = require("lspconfig")
		require("mason").setup({})

		local servers = {
			"bufls",
			"cssls",
			"gopls",
			"html",
			"jsonls",
			"jdtls",
			"lua_ls",
			"ocamllsp",
			"templ",
			-- "pylsp",
			"tsserver",
			"tailwindcss",
		}

		local augroup_codelens = vim.api.nvim_create_augroup("custom-lsp-codelens", { clear = true })
		local codelens_helpers = require("daniel.lsp.codelens")

		local metals_config = require("metals").bare_config()
		metals_config.capabilities = lsp_zero.get_capabilities()

		metals_config.setting = {
			useGlobalExecutable = true,
		}

		local metals_augroup = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = metals_augroup,
			pattern = { "scala", "sbt" },
			callback = function()
				require("metals").initialize_or_attach(metals_config)
			end,
		})

		vim.g.haskell_tools = {
			hls = {
				capabilities = lsp_zero.get_capabilities(),
			},
		}

		-- Autocmd that will actually be in charging of starting hls
		local hls_augroup = vim.api.nvim_create_augroup("haskell-lsp", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = hls_augroup,
			pattern = { "haskell" },
			callback = function()
				---
				-- Suggested keymaps from the quick setup section:
				-- https://github.com/mrcjkb/haskell-tools.nvim#quick-setup
				---

				local ht = require("haskell-tools")
				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { noremap = true, silent = true, buffer = bufnr }
				-- haskell-language-server relies heavily on codeLenses,
				-- so auto-refresh (see advanced configuration) is enabled by default
				vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts)
				-- Hoogle search for the type signature of the definition under the cursor
				vim.keymap.set("n", "<leader>hs", ht.hoogle.hoogle_signature, opts)
				-- Evaluate all code snippets
				vim.keymap.set("n", "<leader>ea", ht.lsp.buf_eval_all, opts)
				-- Toggle a GHCi repl for the current package
				vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)
				-- Toggle a GHCi repl for the current buffer
				vim.keymap.set("n", "<leader>rf", function()
					ht.repl.toggle(vim.api.nvim_buf_get_name(0))
				end, opts)
				vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)
			end,
		})

		require("go").setup({
			lsp_cfg = true,
			-- lsp_on_attach = on_attach,
		})

		require("mason-lspconfig").setup({
			ensure_installed = servers,
			handlers = {
				lsp_zero.default_setup,
				ocamllsp = function()
					lsp.ocamllsp.setup({
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
				end,
				-- metals = lsp_zero.noop,
				jdtls = lsp_zero.noop,
			},
		})

		-- Linter/Formatter registeration via null-ls
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.diagnostics.eslint_d,
			},
		})

		-- Override autocompletion in this section
		-- for nvim-cmp
		local has_words_before = function()
			if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
				return false
			end
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
		end

		local cmp = require("cmp")
		local cmp_format = require("lsp-zero").cmp_format({ details = true })
		local select_ops = {
			behavior = cmp.SelectBehavior.Select,
		}
		cmp.setup({
			sources = {
				{ name = "nvim_lsp", keyword_length = 1 },
				{ name = "luasnip", keyword_length = 2 },
				{ name = "path", keyword_length = 2 },
				{ name = "nvim_lua", keyword_length = 1 },
				{ name = "jdtls", keyword_length = 2 },
				{ name = "buffer", keyword_length = 3 },
				{ name = "vimtex", keyword_length = 2 },
			},
			performance = { debounce = 500 },
			mapping = {
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
				["<C-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<Tab>"] = vim.schedule_wrap(function(fallback)
					if cmp.visible() and has_words_before() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end),
				["<S-Tab>"] = vim.schedule_wrap(function(fallback)
					if cmp.visible() and has_words_before() then
						cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end),
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = cmp_format,
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			view = {
				entries = {
					follow_cursor = true,
				},
			},
		})

		cmp.setup.filetype({ "sql" }, {
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			},
		})

		-- For copilot
		cmp.event:on("menu_opened", function()
			vim.b.copilot_suggestion_hidden = true
		end)

		cmp.event:on("menu_closed", function()
			vim.b.copilot_suggestion_hidden = false
		end)

		local dap = require("dap")

		dap.configurations.scala = {
			{
				type = "scala",
				request = "launch",
				name = "RunOrTest",
				metals = {
					runType = "runOrTestFile",
					--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
				},
			},
			{
				type = "scala",
				request = "launch",
				name = "Test Target",
				metals = {
					runType = "testTarget",
				},
			},
		}

		vim.keymap.del("n", "<leader>d")

		local widgets = require("dap.ui.widgets")
		local sidebar = widgets.sidebar(widgets.scopes)

		keymap("n", "<leader>dut", function()
			sidebar.toggle()
		end)

		keymap("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
		keymap("n", "<leader>dus", function()
			sidebar.open()
		end)
	end,
}
