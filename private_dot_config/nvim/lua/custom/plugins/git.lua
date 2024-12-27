return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
      'echasnovski/mini.pick', -- optional
    },
    config = true,
    opts = {
      telescope = true,
      diffview = true,
      fzf_lua = true,
    },
    keys = {
      { '<leader>gg', '<cmd>Neogit<CR>', desc = 'NeoTree' },
      -- { '<leader>gf', '<cmd>Neogit fetch<CR>', desc = 'NeoTree' },
      -- { '<leader>gb', '<cmd>Neogit branch<CR>', desc = 'NeoTree' },
      -- { '<leader>gc', '<cmd>Neogit commit<CR>', desc = 'NeoTree' },
    },
  },
}
