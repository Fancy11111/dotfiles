local Remap = require("daniel.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

local code_actions_keymap = require("daniel.lsp-keymaps").code_actions_keymap
local lspconfig = require("lspconfig")
local lspconfig_configs = require('lspconfig.configs')
local lspconfig_util = require('lspconfig.util')

local sumneko_root_path = "/home/daniel/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"

local function config(_config)
	return vim.tbl_deep_extend("force", {
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function()
            code_actions_keymap()
			-- nnoremap("<leader>cgd", function() vim.lsp.buf.definition() end, {desc = "Goto definition"})
			-- nnoremap("<leader>ch", function() vim.lsp.buf.hover() end, {desc = "Hover symbol"})
			-- nnoremap("<leader>cws", function() vim.lsp.buf.workspace_symbol() end, {desc = "Display workspace symbol"})
			-- nnoremap("<leader>cd", function() vim.diagnostic.open_float() end, {desc = "Toggle error/warning display"})
			-- nnoremap("<leader>cn", function() vim.diagnostic.goto_next() end, {desc = "Display next warning/error"})
			-- nnoremap("<leader>cb", function() vim.diagnostic.goto_prev() end, {desc = "Display previous warning/error"})
			-- nnoremap("<leader>ca", function() vim.lsp.buf.code_action() end, {desc = "List code actions"})
			-- nnoremap("<leader>crf", function() vim.lsp.buf.references() end, {desc = "Find references"})
			-- nnoremap("<leader>crn", function() vim.lsp.buf.rename() end, {desc = "Rename symbol"})
			-- inoremap("<C-h>", function() vim.lsp.buf.signature_help() end, {desc = "Get signature help"})
		end,
	}, _config or {})
end

require("lspconfig").zls.setup(config())

require("lspconfig").tsserver.setup(config())

require("lspconfig").ccls.setup(config())

require("lspconfig").jedi_language_server.setup(config())

require("lspconfig").svelte.setup(config())

require("lspconfig").solang.setup(config())

require("lspconfig").cssls.setup(config())

require("lspconfig").gopls.setup(config({
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
    on_attach = function ()
        code_actions_keymap()
        vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
    end,
}))

-- who even uses this?
require("lspconfig").rust_analyzer.setup(config({
	cmd = { "rustup", "run", "nightly", "rust-analyzer" },
	--[[
    settings = {
        rust = {
            unstable_features = true,
            build_on_save = false,
            all_features = true,
        },
    }
    --]]
}))

require("lspconfig").sumneko_lua.setup(config({
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	},
}))

require("lspconfig").vuels.setup(config())

require("lspconfig").texlab.setup(config())

-- lspconfig.jdtls.setup(config({}))
-- require("lspconfig").vuels.setup(config({
--     on_attach = function(client)
            --[[
                Internal Vetur formatting is not supported out of the box

                This line below is required if you:
                    - want to format using Nvim's native `vim.lsp.buf.formatting**()`
                    - want to use Vetur's formatting config instead, e.g, settings.vetur.format {...}
            --]]
    --     client.resolved_capabilities.document_formatting = true
    -- end,
    -- capabilities = capabilities,
    -- settings = {
    --     vetur = {
    --         completion = {
    --     on_attach(client)
    --             autoImport = true,
    --             useScaffoldSnippets = true
    --         },
    --         format = {
    --             defaultFormatter = {
    --                 html = "none",
    --                 js = "prettier",
    --                 ts = "prettier",
    --             }
    --         },
    --         validation = {
    --             template = true,
    --             script = true,
    --             style = true,
    --             templateProps = true,
    --             interpolation = true
    --         },
    --         experimental = {
    --             templateInterpolationService = true
    --         }
    --     }
    -- },
    -- root_dir = util.root_pattern("header.php", "package.json", "style.css", 'webpack.config.js')
-- }))

local opts = {
	-- whether to highlight the currently hovered symbol
	-- disable if your cpu usage is higher than you want it
	-- or you just hate the highlight
	-- default: true
	highlight_hovered_item = true,

	-- whether to show outline guides
	-- default: true
	show_guides = true,
}

require("symbols-outline").setup(opts)

local snippets_paths = function()
	local plugins = { "friendly-snippets" }
	local paths = {}
	local path
	local root_path = vim.env.HOME .. "/.vim/plugged/"
	for _, plug in ipairs(plugins) do
		path = root_path .. plug
		if vim.fn.isdirectory(path) ~= 0 then
			table.insert(paths, path)
		end
	end
	return paths
end

local function on_new_config(new_config, new_root_dir)
  local function get_typescript_server_path(root_dir)
    local project_root = lspconfig_util.find_node_modules_ancestor(root_dir)
    return project_root and (lspconfig_util.path.join(project_root, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js'))
      or ''
  end

  if
    new_config.init_options
    and new_config.init_options.typescript
    and new_config.init_options.typescript.serverPath == ''
  then
    new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
  end
end

local volar_cmd = {'vue-language-server', '--stdio'}
local volar_root_dir = lspconfig_util.root_pattern 'package.json'

lspconfig_configs.volar_api = config({
  default_config = {
    cmd = volar_cmd,
    root_dir = volar_root_dir,
    on_new_config = on_new_config,
    filetypes = { 'vue'},
    -- If you want to use Volar's Take Over Mode (if you know, you know)
    --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
    init_options = {
      typescript = {
        serverPath = ''
      },
      languageFeatures = {
        implementation = true, -- new in @volar/vue-language-server v0.33
        references = true,
        definition = true,
        typeDefinition = true,
        callHierarchy = true,
        hover = true,
        rename = true,
        renameFileRefactoring = true,
        signatureHelp = true,
        codeAction = true,
        workspaceSymbol = true,
        completion = {
          defaultTagNameCase = 'both',
          defaultAttrNameCase = 'kebabCase',
          getDocumentNameCasesRequest = false,
          getDocumentSelectionRequest = false,
        },
      }
    },
  }
})

lspconfig.volar_api.setup{}

lspconfig_configs.volar_doc = config({
  default_config = {
    cmd = volar_cmd,
    root_dir = volar_root_dir,
    on_new_config = on_new_config,

    filetypes = { 'vue'},
    -- If you want to use Volar's Take Over Mode (if you know, you know):
    --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
    init_options = {
      typescript = {
        serverPath = ''
      },
      languageFeatures = {
        implementation = true, -- new in @volar/vue-language-server v0.33
        documentHighlight = true,
        documentLink = true,
        codeLens = { showReferencesNotification = true},
        -- not supported - https://github.com/neovim/neovim/pull/15723
        semanticTokens = false,
        diagnostics = true,
        schemaRequestService = true,
      }
    },
  }
})

lspconfig.volar_doc.setup{}

lspconfig_configs.volar_html = config({
  default_config = {
    cmd = volar_cmd,
    root_dir = volar_root_dir,
    on_new_config = on_new_config,

    filetypes = { 'vue'},
    -- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
    --filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    init_options = {
      typescript = {
        serverPath = ''
      },
      documentFeatures = {
        selectionRange = true,
        foldingRange = true,
        linkedEditingRange = true,
        documentSymbol = true,
        -- not supported - https://github.com/neovim/neovim/pull/13654
        documentColor = false,
        documentFormatting = {
          defaultPrintWidth = 100,
        },
      }
    },
  }
})

lspconfig.volar_html.setup{}