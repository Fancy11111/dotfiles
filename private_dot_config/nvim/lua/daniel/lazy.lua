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


local plugins = {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    { 'nvim-treesitter/nvim-treesitter',         build = ':TSUpdate' },
    { 'nvim-treesitter/nvim-treesitter-context', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep' } }
    },
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-media-files.nvim',
    'ThePrimeagen/git-worktree.nvim',
    'lewis6991/gitsigns.nvim',
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

    'nvim-tree/nvim-web-devicons',
    {
        "glepnir/lspsaga.nvim",
        event = "BufRead",
        config = function()
            require("lspsaga").setup({})
        end,
        dependencies = { { "nvim-tree/nvim-web-devicons" } }
    },
    -- Debugging
    "mfussenegger/nvim-dap",
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

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },

    {
        "ray-x/go.nvim",
        requires = { -- optional packages
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
                RRGGBBAA = true
            })
        end
    },

    -- Appearance
    'Yggdroot/indentLine',
    { 'nvim-lualine/lualine.nvim' },
    { 'akinsho/bufferline.nvim',  tag = "v3.2.0", dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'ThePrimeagen/harpoon' },

    -- Colorschemes
    "folke/tokyonight.nvim",
    'andersevenrud/nordic.nvim',
    'EdenEast/nightfox.nvim',
    'gruvbox-community/gruvbox',

    { "catppuccin/nvim", name = "catppuccin" },

    {
        'linty-org/key-menu.nvim',
        config = function()
            require 'key-menu'.set('n', '<Space>')
        end
    } }

require('lazy').setup(plugins)
