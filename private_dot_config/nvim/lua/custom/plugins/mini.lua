return {
  'echasnovski/mini.nvim',
  version = false,
  dependencies = { { 'rafamadriz/friendly-snippets' } },
  config = function()
    require('mini.snippets').setup {
      snippets = {},
    }
  end,
}
