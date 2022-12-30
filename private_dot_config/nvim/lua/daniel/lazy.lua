local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)
local opts = {
    defaults = { lazy = true },
    dev = { patterns = jit.os:find("Windows") and {} or { "folke" } },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true },
    diff = {
        cmd = "terminal_git",
    },
    performance = {
        cache = {
            enabled = true,
            -- disable_events = {},
        },
        rtp = {
            disabled_plugins = {
                -- "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                -- "tarPlugin",
                -- "tohtml",
                -- "tutor",
                -- "zipPlugin",
                -- "nvim-treesitter-textobjects",
            },
        },
    },
    ui = {
        custom_keys = {
            -- ["<localleader>d"] = function(plugin)
            --     dd(plugin)
            -- end,
        },
    },
}
require("lazy").setup("plugins", opts)
