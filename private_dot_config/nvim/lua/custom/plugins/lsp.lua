local java_filetypes = { 'java' }
-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
  if type(custom) == 'function' then
    config = custom(config, ...) or config -- Utility function to extend or override a config table, similar to the way
    -- that Plugin.opts works.
    ---@param config table
    ---@param custom function | table | nil
    local function extend_or_override(config, custom, ...)
      if type(custom) == 'function' then
        config = custom(config, ...) or config
      elseif custom then
        config = vim.tbl_deep_extend('force', config, custom) --[[@as table]]
      end
      return config
    end
  elseif custom then
    config = vim.tbl_deep_extend('force', config, custom) --[[@as table]]
  end
  return config
end

local function get_raw_lsp_config(server)
  local ok, ret = pcall(require, 'lspconfig.configs.' .. server)
  if ok then
    return ret
  end
  return require('lspconfig.server_configurations.' .. server)
end

return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'saghen/blink.cmp',
        dependencies = {
          'rafamadriz/friendly-snippets',
          'onsails/lspkind.nvim',
          { 'echasnovski/mini.snippets' },
          {
            'saghen/blink.compat',
            -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
            version = '*',
            -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
            lazy = true,
            -- make sure to set opts so that lazy.nvim calls blink.compat's setup
            opts = {},
            dependencies = {
              -- 'supermaven-inc/supermaven-nvim',
              'supermaven-inc/supermaven-nvim',
            },
          },
        },
        version = '*',
        opts_extend = { 'sources.default' },
        opts = {
          appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono',
          },

          completion = {
            accept = { auto_brackets = { enabled = true, override_brackets_for_filetypes = { 'scala' } } },

            documentation = {
              auto_show = true,
              auto_show_delay_ms = 250,
              treesitter_highlighting = true,
              window = { border = 'rounded' },
            },

            list = {
              selection = { preselect = true, auto_insert = true },
            },

            ghost_text = {
              enabled = false,
            },

            menu = {
              border = 'rounded',

              cmdline_position = function()
                if vim.g.ui_cmdline_pos ~= nil then
                  local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                  return { pos[1] - 1, pos[2] }
                end
                local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                return { vim.o.lines - height, 0 }
              end,

              draw = {
                columns = {
                  { 'kind_icon', 'label', gap = 1 },
                  { 'kind' },
                },
                components = {
                  kind_icon = {
                    text = function(item)
                      local kind = require('lspkind').symbol_map[item.kind] or ''
                      return kind .. ' '
                    end,
                    highlight = 'CmpItemKind',
                  },
                  label = {
                    text = function(item)
                      return item.label
                    end,
                    highlight = 'CmpItemAbbr',
                  },
                  kind = {
                    text = function(item)
                      return item.kind
                    end,
                    highlight = 'CmpItemKind',
                  },
                },
              },
            },
          },

          -- My super-TAB configuration
          keymap = {
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<CR>'] = { 'accept', 'fallback' },

            ['<Tab>'] = {
              function(cmp)
                return cmp.select_next()
              end,
              'snippet_forward',
              'fallback',
            },
            ['<S-Tab>'] = {
              function(cmp)
                return cmp.select_prev()
              end,
              'snippet_backward',
              'fallback',
            },

            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },

            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          },

          -- Experimental signature help support
          signature = {
            enabled = true,
            window = { border = 'rounded' },
          },

          -- snippets = { preset = 'mini_snippets' },
          --
          cmdline = {
            sources = {},
            enabled = false,
          },

          sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
              supermaven = {
                name = 'supermaven', -- IMPORTANT: use the same name as you would for nvim-cmp
                module = 'blink.compat.source',

                -- all blink.cmp source config options work as normal:
                score_offset = -3,
              },
            },
          },
        },
      },

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
      -- Language specific plugins
      {
        'ray-x/go.nvim',
        lazy = false,
        dependencies = { 'ray-x/guihua.lua' },
        config = function() end,
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
      },
      {
        'scalameta/nvim-metals',
        requires = { 'nvim-lua/plenary.nvim' },
      },
      -- "github/copilot.vim",
      {
        'mfussenegger/nvim-jdtls',
        dependencies = { 'folke/which-key.nvim', 'saghen/blink.cmp' },
        ft = java_filetypes,
        opts = function()
          local mason_registry = require 'mason-registry'
          local lombok_jar = mason_registry.get_package('jdtls'):get_install_path() .. '/lombok.jar'
          return {
            -- How to find the root dir for a given filename. The default comes from
            -- lspconfig which provides a function specifically for java projects.
            root_dir = get_raw_lsp_config('jdtls').default_config.root_dir,
            -- root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew' },

            -- How to find the project name for a given root dir.
            project_name = function(root_dir)
              return root_dir and vim.fs.basename(root_dir)
            end,

            -- Where are the config and workspace dirs for a project?
            jdtls_config_dir = function(project_name)
              return vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/config'
            end,
            jdtls_workspace_dir = function(project_name)
              return vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/workspace'
            end,

            -- How to run jdtls. This can be overridden to a full java command-line
            -- if the Python wrapper script doesn't suffice.
            cmd = {
              vim.fn.exepath 'jdtls',
              string.format('--jvm-arg=-javaagent:%s', lombok_jar),
            },
            full_cmd = function(opts)
              local fname = vim.api.nvim_buf_get_name(0)
              local root_dir = opts.root_dir(fname)
              local project_name = opts.project_name(root_dir)
              local cmd = vim.deepcopy(opts.cmd)
              if project_name then
                vim.list_extend(cmd, {
                  '-configuration',
                  opts.jdtls_config_dir(project_name),
                  '-data',
                  opts.jdtls_workspace_dir(project_name),
                })
              end
              return cmd
            end,

            -- These depend on nvim-dap, but can additionally be disabled by setting false here.
            dap = { hotcodereplace = 'auto', config_overrides = {} },
            dap_main = {},
            test = true,
            settings = {
              java = {
                inlayHints = {
                  parameterNames = {
                    enabled = 'all',
                  },
                },
              },
            },
          }
        end,
        config = function(_, opts)
          -- Find the extra bundles that should be passed on the jdtls command-line
          -- if nvim-dap is enabled with java debug/test.
          local mason_registry = require 'mason-registry'
          local bundles = {} ---@type string[]
          if opts.dap and mason_registry.is_installed 'java-debug-adapter' then
            local java_dbg_pkg = mason_registry.get_package 'java-debug-adapter'
            local java_dbg_path = java_dbg_pkg:get_install_path()
            local jar_patterns = {
              java_dbg_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar',
            }
            -- java-test also depends on java-debug-adapter.
            if opts.test and mason_registry.is_installed 'java-test' then
              local java_test_pkg = mason_registry.get_package 'java-test'
              local java_test_path = java_test_pkg:get_install_path()
              vim.list_extend(jar_patterns, {
                java_test_path .. '/extension/server/*.jar',
              })
            end
            for _, jar_pattern in ipairs(jar_patterns) do
              for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), '\n')) do
                table.insert(bundles, bundle)
              end
            end
          end

          local function attach_jdtls()
            local fname = vim.api.nvim_buf_get_name(0)

            -- Configuration can be augmented and overridden by opts.jdtls
            local config = extend_or_override({
              cmd = opts.full_cmd(opts),
              root_dir = opts.root_dir(fname),
              init_options = {
                bundles = bundles,
              },
              settings = opts.settings,
              -- enable CMP capabilities
              capabilities = require('blink.cmp').get_lsp_capabilities() or nil,
            }, opts.jdtls)

            -- Existing server will be reused if the root_dir matches.
            require('jdtls').start_or_attach(config)
            -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
          end

          -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
          -- depending on filetype, so this autocmd doesn't run for the first file.
          -- For that, we call directly below.
          vim.api.nvim_create_autocmd('FileType', {
            pattern = java_filetypes,
            callback = attach_jdtls,
          })

          -- Setup keymap and dap after the lsp is fully attached.
          -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
          -- https://neovim.io/doc/user/lsp.html#LspAttach
          vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == 'jdtls' then
                local wk = require 'which-key'
                wk.add {
                  {
                    mode = 'n',
                    buffer = args.buf,
                    { '<leader>cx', group = 'extract' },
                    { '<leader>cxv', require('jdtls').extract_variable_all, desc = 'Extract Variable' },
                    { '<leader>cxc', require('jdtls').extract_constant, desc = 'Extract Constant' },
                    { 'gs', require('jdtls').super_implementation, desc = 'Goto Super' },
                    { 'gS', require('jdtls.tests').goto_subjects, desc = 'Goto Subjects' },
                    { '<leader>co', require('jdtls').organize_imports, desc = 'Organize Imports' },
                  },
                }
                wk.add {
                  {
                    mode = 'v',
                    buffer = args.buf,
                    { '<leader>cx', group = 'extract' },
                    {
                      '<leader>cxm',
                      [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                      desc = 'Extract Method',
                    },
                    {
                      '<leader>cxv',
                      [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                      desc = 'Extract Variable',
                    },
                    {
                      '<leader>cxc',
                      [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                      desc = 'Extract Constant',
                    },
                  },
                }

                if opts.dap and mason_registry.is_installed 'java-debug-adapter' then
                  -- custom init for Java debugger
                  require('jdtls').setup_dap(opts.dap)
                  require('jdtls.dap').setup_dap_main_class_configs(opts.dap_main)

                  -- Java Test require Java debugger to work
                  if opts.test and mason_registry.is_installed 'java-test' then
                    -- custom keymaps for Java test runner (not yet compatible with neotest)
                    wk.add {
                      {
                        mode = 'n',
                        buffer = args.buf,
                        { '<leader>t', group = 'test' },
                        {
                          '<leader>tt',
                          function()
                            require('jdtls.dap').test_class {
                              config_overrides = type(opts.test) ~= 'boolean' and opts.test.config_overrides or nil,
                            }
                          end,
                          desc = 'Run All Test',
                        },
                        {
                          '<leader>tr',
                          function()
                            require('jdtls.dap').test_nearest_method {
                              config_overrides = type(opts.test) ~= 'boolean' and opts.test.config_overrides or nil,
                            }
                          end,
                          desc = 'Run Nearest Test',
                        },
                        { '<leader>tT', require('jdtls.dap').pick_test, desc = 'Run Test' },
                      },
                    }
                  end
                end

                -- User can set additional keymaps in opts.on_attach
                if opts.on_attach then
                  opts.on_attach(args)
                end
              end
            end,
          })

          -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
          -- attach_jdtls()
        end,
      },
      {
        'mrcjkb/haskell-tools.nvim',
        version = '^3', -- Recommended
        ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
      },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        ocamllsp = {},
      }

      -- Extra LSP plugin setup

      -- SCALA
      local metals_config = require('metals').bare_config()
      metals_config.capabilities = capabilities

      metals_config.setting = {
        useGlobalExecutable = true,
      }

      local metals_augroup = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = metals_augroup,
        pattern = { 'scala', 'sbt' },
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
      })

      -- HASKELL

      vim.g.haskell_tools = {
        hls = {
          capabilities = capabilities,
        },
      }

      -- GO
      require('go').setup {
        lsp_cfg = true,
        -- lsp_on_attach = on_attach,
      }

      -- Autocmd that will actually be in charging of starting hls
      local hls_augroup = vim.api.nvim_create_augroup('haskell-lsp', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = hls_augroup,
        pattern = { 'haskell' },
        callback = function()
          ---
          -- Suggested keymaps from the quick setup section:
          -- https://github.com/mrcjkb/haskell-tools.nvim#quick-setup
          ---

          local ht = require 'haskell-tools'
          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { noremap = true, silent = true, buffer = bufnr }
          -- haskell-language-server relies heavily on codeLenses,
          -- so auto-refresh (see advanced configuration) is enabled by default
          vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
          -- Hoogle search for the type signature of the definition under the cursor
          vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
          -- Evaluate all code snippets
          vim.keymap.set('n', '<leader>ea', ht.lsp.buf_eval_all, opts)
          -- Toggle a GHCi repl for the current package
          vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
          -- Toggle a GHCi repl for the current buffer
          vim.keymap.set('n', '<leader>rf', function()
            ht.repl.toggle(vim.api.nvim_buf_get_name(0))
          end, opts)
          vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
        end,
      })
      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'jdtls',
        'templ',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      local dump = require('custom.util').dump
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            if server_name == 'jdtls' then
              return
            end

            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            -- server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            server.capabilities = require('blink.cmp').get_lsp_capabilities(server.capabilities)
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {},

  -- { -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     {
  --       'L3MON4D3/LuaSnip',
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return
  --         end
  --         return 'make install_jsregexp'
  --       end)(),
  --       dependencies = {
  --         -- `friendly-snippets` contains a variety of premade snippets.
  --         --    See the README about individual language/framework/plugin snippets:
  --         --    https://github.com/rafamadriz/friendly-snippets
  --         {
  --           'rafamadriz/friendly-snippets',
  --           config = function()
  --             -- require('luasnip.loaders.from_vscode').lazy_load()
  --           end,
  --         },
  --       },
  --     },
  --     'saadparwaiz1/cmp_luasnip',
  --
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-path',
  --   },
  --   config = function()
  --     -- See `:help cmp`
  --     local cmp = require 'cmp'
  --     local luasnip = require 'luasnip'
  --     luasnip.config.setup {}
  --
  --     cmp.setup {
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --       -- For an understanding of why these mappings were
  --       -- chosen, you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       mapping = cmp.mapping.preset.insert {
  --         -- Select the [n]ext item
  --         ['<C-n>'] = cmp.mapping.select_next_item(),
  --         -- Select the [p]revious item
  --         ['<C-p>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Scroll the documentation window [b]ack / [f]orward
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --
  --         -- Accept ([y]es) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ['<C-y>'] = cmp.mapping.confirm { select = true },
  --
  --         -- If you prefer more traditional completion keymaps,
  --         -- you can uncomment the following lines
  --         ['<CR>'] = cmp.mapping.confirm { select = true },
  --         ['<Tab>'] = cmp.mapping.select_next_item(),
  --         ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ['<C-Space>'] = cmp.mapping.complete {},
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         ['<C-l>'] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { 'i', 's' }),
  --         ['<C-h>'] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { 'i', 's' }),
  --
  --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --       },
  --       sources = {
  --         {
  --           name = 'lazydev',
  --           -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
  --           group_index = 0,
  --         },
  --         { name = 'nvim_lsp' },
  --         { name = 'luasnip' },
  --         { name = 'path' },
  --       },
  --     }
  --     cmp.setup.filetype({ 'sql' }, {
  --       sources = {
  --         { name = 'vim-dadbod-completion' },
  --         { name = 'buffer' },
  --       },
  --     })
  --   end,
  -- },
}
