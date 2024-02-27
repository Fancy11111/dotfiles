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
				"onsails/lspkind-nvim",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
		},

		{
			"VonHeikemen/lsp-zero.nvim",
			branch = "v2.x",
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
			vim.keymap.set(
				"n",
				"gd",
				"<Cmd>Lspsaga goto_definition<CR>",
				{ buffer = bufnr, desc = "LSP go to definition" }
			)

			vim.keymap.set(
				"n",
				"gt",
				"<Cmd>Lspsaga peek_type_definition<CR>",
				{ buffer = bufnr, desc = "LSP go to type definition" }
			)
			vim.keymap.set(
				"n",
				"gD",
				"<Cmd>lua vim.lsp.buf.declaration()<CR>",
				{ buffer = bufnr, desc = "LSP go to declaration" }
			)
			vim.keymap.set(
				"n",
				"gi",
				"<Cmd>lua vim.lsp.buf.implementation()<CR>",
				{ buffer = bufnr, desc = "LSP go to implementation" }
			)

			vim.keymap.set("n", "gw", "<Cmd>Lspsaga lsp_finder<CR>", { buffer = bufnr, desc = "LSP document symbols" })
			vim.keymap.set(
				"n",
				"gW",
				"<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
				{ buffer = bufnr, desc = "LSP Workspace symbols" }
			)
			vim.keymap.set(
				"n",
				"gr",
				"<Cmd>lua vim.lsp.buf.references()<CR>",
				{ buffer = bufnr, desc = "LSP show references" }
			)

			vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", { buffer = bufnr, desc = "LSP hover documentation" })
			vim.keymap.set(
				"n",
				"<c-k>",
				"<Cmd>lua vim.lsp.buf.signature_help()<CR>",
				{ buffer = bufnr, desc = "LSP signature help" }
			)

			vim.keymap.set(
				"n",
				"<leader>ca",
				"<Cmd>Lspsaga code_action<CR>",
				{ buffer = bufnr, desc = "LSP show code actions" }
			)

			vim.keymap.set("n", "<leader>rn", "<Cmd>Lspsaga rename<CR>", { buffer = bufnr, desc = "LSP rename word" })

			vim.keymap.set(
				"n",
				"<leader>dn",
				"<Cmd>Lspsaga diagnostic_jump_next<CR>",
				{ buffer = bufnr, desc = "LSP go to next diagnostic" }
			)

			vim.keymap.set(
				"n",
				"<leader>dp",
				"<Cmd>Lspsaga diagnostic_jump_prev<CR>",
				{ buffer = bufnr, desc = "LSP go to previous diagnostic" }
			)
			-- Diagnostic jump with filters such as only jumping to an error
			keymap("n", "[E", function()
				require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end, { buffer = bufnr, desc = "LSP go to previous error diagnostic" })
			keymap("n", "]E", function()
				require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
			end, { buffer = bufnr, desc = "LSP go to next error diagnostic" })

			-- Diagnostic jump
			-- You can use <C-o> to jump back to your previous location
			keymap(
				"n",
				"[e",
				"<cmd>Lspsaga diagnostic_jump_prev<CR>",
				{ buffer = bufnr, desc = "LSP go to previous diagnostic" }
			)
			keymap(
				"n",
				"]e",
				"<cmd>Lspsaga diagnostic_jump_next<CR>",
				{ buffer = bufnr, desc = "LSP go to next diagnostic" }
			)

			vim.keymap.set(
				"n",
				"<leader>sc",
				"<Cmd>Lspsaga show_cursor_diagnostics<CR>",
				{ buffer = bufnr, desc = "LSP show diagnostic under cursor" }
			)

			vim.keymap.set(
				"n",
				"<leader>sl",
				"<Cmd>Lspsaga show_line_diagnostics<CR>",
				{ buffer = bufnr, desc = "LSP show line diagnostic" }
			)

			vim.keymap.set(
				"n",
				"<leader>sb",
				"<Cmd>Lspsaga show_buffer_diagnostics<CR>",
				{ buffer = bufnr, desc = "LSP show buffer diagnostic" }
			)

			-- Call hierarchy
			keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", {
				desc = "LSP Show incoming calls",
				buffer = bufnr,
			})
			keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", {
				desc = "LSP Show outgoing calls",
				buffer = bufnr,
			})

			-- Floating terminal
			keymap({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>", {
				desc = "Toggle floating terminal",
				buffer = bufnr,
			})

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
			"lua-language-server",
			"typescript-language-server",
			"tailwindcss-language-server",
			"html-lsp",
			"css-lsp",
			"json-lsp",
			"gopls",
			"python-lsp-server",
			"black",
			"stylua",
			"prettier",
			"eslint_d",
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

		local metals_config = require("metals").bare_config()
		-- metals_config.settings = {
		-- showImplicitArguments = true,
		-- excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
		-- }

		-- metals_config.init_options.statusBarProvider = "on"

		metals_config.setting = {
			useGlobalExecutable = true,
		}

		local lsp = require("lsp-zero").preset("recommended")
		lsp.on_attach(on_attach)
		lsp.set_server_config({
			on_init = function(client)
				client.server_capabilities.semanticTokensProvider = nil
			end,
		})

		local lspconfig = require("lspconfig")

		-- lsp.configure("lua_lsp", {
		-- 	settings = {
		-- 		Lua = {
		-- 			completion = {
		-- 				callSnippet = "Replace",
		-- 			},
		-- 		},
		-- 	},
		-- })

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

		lsp.configure("volar", {
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
		})

		require("go").setup({
			lsp_cfg = true,
			-- lsp_on_attach = on_attach,
		})

		lsp.setup()

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
		local select_ops = {
			behavior = cmp.SelectBehavior.Select,
		}
		lsp.setup_nvim_cmp({
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
			formatting = {
				format = function(entry, item)
					require("lspkind").cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[BUF]",
							nvim_lsp = "[LSP]",
							luasnip = "[SNIP]",
							path = "[PATH]",
						},
					})(entry, item)
					return require("tailwindcss-colorizer-cmp").formatter(entry, item)
				end,
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
