return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        -- default_file_explorer = false,
        columns = { 'icon' },
        skip_confirm_for_simple_edits = false,
        keymaps = {},
        view_options = {
          show_hidden = true,
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

      -- vim.keymap.set("n", "<leader>", function()
      -- 	local path = vim.b.netrw_curdir
      -- 	require("oil").open(path)
      -- end, { desc = "Open directory currently opened in netrw" })

      vim.keymap.set('n', '<leader>-', require('oil').toggle_float, { desc = 'Open parent directory in float' })
      vim.keymap.set('n', '<C-l>', '<C-L>', { desc = 'Reload directory info' })
    end,
  },
}
