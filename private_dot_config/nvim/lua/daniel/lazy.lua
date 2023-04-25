local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- vim.opt.runtimepath:append("$HOME/.local/share/treesitter")
vim.opt.runtimepath:append("$HOME/.local/share/lazy/nvim-treesitter/parser")
vim.opt.rtp:append("$HOME/.local/share/lazy/nvim-treesitter/parser")
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

local plugins = {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
        'nvim-treesitter/nvim-treesitter',
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            init = function()
              -- PERF: no need to load the plugin, if we only need its queries for mini.ai
              local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
              local opts = require("lazy.core.plugin").values(plugin, "opts", false)
              local enabled = false
              if opts.textobjects then
                for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
                  if opts.textobjects[mod] and opts.textobjects[mod].enable then
                    enabled = true
                    break
                  end
                end
              end
              if not enabled then
                require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
              end
            end
        },
        opts = {
            ensure_installed = {
                "bash",
                "help",
                "html",
                "go",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                }
            },
            parser_install_dir = "$HOME/.local/share/lazy/nvim-treesitter/parser"
        },
        -- ---@param opts TSConfig
        -- config = function(_, opts)
        --     require("nvim-treesitter.configs").setup(opts)
        -- end,
    },
    { 'nvim-treesitter/nvim-treesitter-context', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' } }
    },
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-media-files.nvim',
    'ThePrimeagen/git-worktree.nvim',
    {
        'lewis6991/gitsigns.nvim',
        config = function()
          require("gitsigns").setup()
        end
    },
    {
        'numToStr/Comment.nvim',
        config = function()
          require('Comment').setup()
        end
    },
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lua',
    {
        'windwp/nvim-autopairs',
        config = function()
          require('nvim-autopairs').setup({
              disable_filetype = { 'TelescopePrompt', 'vim' }
          })
        end
    },
    'mfussenegger/nvim-jdtls',
    { 'folke/neodev.nvim' },
    { 'mfussenegger/nvim-lint' },
    { 'mhartington/formatter.nvim' },

    'nvim-tree/nvim-web-devicons',
    {
        "glepnir/lspsaga.nvim",
        event = "BufRead",
        config = function()
          require("lspsaga").setup({})
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" } }
    },
    -- Debugging
    "mfussenegger/nvim-dap",
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" }
    },
    "rcarriga/nvim-dap-ui",
    {
        "leoluz/nvim-dap-go",
        dependencies = { { "nvim-dap" } }
    },
    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-cmdline' },
            { 'onsails/lspkind.nvim' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },

    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
          require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },

    { 'ahmedkhalf/project.nvim' },
    { 'goolord/alpha-nvim',     dependencies = { 'ahmedkhalf/project.nvim' } },
    {
        'NvChad/nvim-colorizer.lua',
        name = "colorizer",
        config = function()
          require("colorizer").setup({
              filetypes = { '*' },
              css = {
                  rgb_fn = true
              },
              -- RRGGBBAA = true
          })
        end
    },

    -- Appearance
    'Yggdroot/indentLine',
    { 'nvim-lualine/lualine.nvim' },
    {
        'akinsho/bufferline.nvim',
        tag = "v3.2.0",
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { 'ThePrimeagen/harpoon',     config = function() require("harpoon").setup() end },

    -- Colorschemes

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 500,
        config = function()
        end
    },
    -- {
    --     'andersevenrud/nordic.nvim',
    --     name = "nordic",
    --     lazy = false,
    --     priority = 1500,
    --     config = function()
    --         local nordic_module = require('nordic').load()
    --         -- nordic_module.setup()
    --         print(dump(nordic_module))
    --         -- print(nordic_module)
    --         -- require 'nordic'.colorscheme()
    --     end
    -- },
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 500,
        config = function()
        end
    },
    {
        'gruvbox-community/gruvbox',
        lazy = false,
        priority = 500,
        config = function()
          -- require('gruvbox').setup()
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 500,
        config = function()
        end
    },
    {
        "lunarvim/synthwave84.nvim",
        name = "synthwave84",
        lazy = false,
        priority = 500,
        config = function()
        end
    },
    {
        'linty-org/key-menu.nvim',
        config = function()
          require 'key-menu'.set('n', '<Space>')
        end
    } }

require('lazy').setup(plugins)
