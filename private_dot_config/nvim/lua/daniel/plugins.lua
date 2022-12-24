local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.isdirectory(install_path) == 0 then
    print 'downloading packer.nvim'
    PACKER_BOOTSTRAP = vim.fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
    print 'installed packer, reopen neovim'
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return packer.startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")
    use("nvim-lua/popup.nvim", { tags = "0.1.0" })
    use("sbdchd/neoformat")

    -- Simple plugins can be specified as strings
    use("TimUntersberger/neogit")

    -- TJ created lodash of neovim
    use("BurntSushi/ripgrep")
    use("nvim-lua/plenary.nvim")
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-file-browser.nvim")
    use("nvim-telescope/telescope-media-files.nvim")

    use("L3MON4D3/LuaSnip")
    use("lambdalisue/suda.vim")

    use { "ahmedkhalf/project.nvim", commit = "541115e762764bc44d7d3bf501b6e367842d3d4f" }
    use { "goolord/alpha-nvim", commit = "ef27a59e5b4d7b1c2fe1950da3fe5b1c5f3b4c94" }

    -- All the things
    use("hrsh7th/nvim-cmp") -- completions
    use("hrsh7th/cmp-buffer") -- buffer source
    use("hrsh7th/cmp-nvim-lsp") -- lsp source
    use("hrsh7th/cmp-path") -- path source
    use("hrsh7th/cmp-nvim-lua") -- nvim lua source
    use("hrsh7th/cmp-cmdline") -- cmdline source
    use("tzachar/cmp-tabnine", { run = "./install.sh", requires = "hrsh7th/nvim-cmp" })
    use("saadparwaiz1/cmp_luasnip") -- snippet source

    use("neovim/nvim-lspconfig")
    use("glepnir/lspsaga.nvim")
    use("onsails/lspkind-nvim")
    use("nvim-lua/lsp_extensions.nvim")
    use("simrat39/symbols-outline.nvim")

    use("williamboman/mason.nvim")

    use('mfussenegger/nvim-dap')
    use("mfussenegger/nvim-jdtls")

    -- Primeagen doesn"t create lodash
    use("ThePrimeagen/git-worktree.nvim")
    use("ThePrimeagen/harpoon")

    use("mbbill/undotree")

    -- Colorscheme section
    use("gruvbox-community/gruvbox")
    use("folke/tokyonight.nvim")
    use("shaunsingh/nord.nvim")

    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

    use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")


    use("theHamsta/nvim-dap-virtual-text")

    use("akinsho/bufferline.nvim")

    use("numToStr/Comment.nvim", {
        config = function()
            require('Comment').setup()
        end
    })

    use('ray-x/go.nvim')
    use('ray-x/guihua.lua')

    -- Color highlighter
    use "norcalli/nvim-colorizer.lua"

    use 'lervag/vimtex'
    use 'mhinz/neovim-remote'

    use("RRethy/vim-illuminate")

    use("lukas-reineke/indent-blankline.nvim")

    use("linty-org/key-menu.nvim")
    use("windwp/nvim-autopairs", {
        config = function()
            require('nvim-autopairs').setup()
        end
    })

    use("xuhdev/vim-latex-live-preview", {
        config = function()
            vim.cmd([[
                let g:livepreview_previewer = 'zathura'
                " This is necessary for VimTeX to load properly. The "indent" is optional.
                " Note that most plugin managers will do this automatically.
                filetype plugin indent on

                " This enables Vim's and neovim's syntax-related features. Without this, some
                " VimTeX features will not work (see ":help vimtex-requirements" for more info).
                syntax enable

                " Viewer options: One may configure the viewer either by specifying a built-in
                " viewer method:
                let g:vimtex_view_method = 'zathura'

                " VimTeX uses latexmk as the default compiler backend. If you use it, which is
                " strongly recommended, you probably don't need to configure anything. If you
                " want another compiler backend, you can change it as follows. The list of
                " supported backends and further explanation is provided in the documentation,
                " see ":help vimtex-compiler".
                let g:vimtex_compiler_method = 'latexrun'

                " Most VimTeX mappings rely on localleader and this can be changed with the
                " following line. The default is usually fine and is the symbol "\".
                let maplocalleader = ","
            ]])
        end
    })

    -- use("lervag/vimtex", {
    --     config = function ()
    --         vim.cmd([[let g:livepreview_previewer = 'zathura']])
    --     end
    -- })

    use("iamcco/markdown-preview.nvim", {
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" }
    })

    use("kyazdani42/nvim-web-devicons")

    -- use("folke/which-key.nvim", {
    --     config = function()
    --         require("which-key").setup {}
    --     end
    -- })
    -- explorer
    -- use (
    --     'kyazdani42/nvim-tree.lua',
    --     {
    --         requires = 'kyazdani42/nvim-web-devicons', -- optional, for file icons
    --     }
    -- )

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
