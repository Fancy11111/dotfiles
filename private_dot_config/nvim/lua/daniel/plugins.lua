local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.isdirectory(install_path) == 0 then
    print 'downloading packer.nvim'
    packer_bootstrap = vim.fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end


return require('packer').startup(function(use)
  -- Packer can manage itself
    use("wbthomason/packer.nvim")
    use("sbdchd/neoformat")

    -- Simple plugins can be specified as strings
    use("TimUntersberger/neogit")

    -- TJ created lodash of neovim
    use("BurntSushi/ripgrep")
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim", {tags = "0.1.0"})
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-file-browser.nvim")

    -- All the things
    use("neovim/nvim-lspconfig")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/nvim-cmp")
    use("tzachar/cmp-tabnine", { run = "./install.sh", requires = "hrsh7th/nvim-cmp" })
    use("onsails/lspkind-nvim")
    use("nvim-lua/lsp_extensions.nvim")
    use("glepnir/lspsaga.nvim")
    use("simrat39/symbols-outline.nvim")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")

    -- Primeagen doesn"t create lodash
    use("ThePrimeagen/git-worktree.nvim")
    use("ThePrimeagen/harpoon")

    use("mbbill/undotree")

    -- Colorscheme section
    use("gruvbox-community/gruvbox")
    use("folke/tokyonight.nvim")

    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

    use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")


    use("theHamsta/nvim-dap-virtual-text")

    use("numToStr/Comment.nvim", {
        config = function()
            require('Comment').setup()
        end
    })

    use('ray-x/go.nvim')
    use('ray-x/guihua.lua')

    use("linty-org/key-menu.nvim")
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
end)
