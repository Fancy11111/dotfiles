return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'BurntSushi/ripgrep',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-media-files.nvim',
      'ThePrimeagen/git-worktree.nvim',
    },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', 'ma', function()
        harpoon:list():select(1)
      end, { desc = 'Open harpoon 1' })
      vim.keymap.set('n', 'ms', function()
        harpoon:list():select(2)
      end, { desc = 'Open harpoon 2' })
      vim.keymap.set('n', 'md', function()
        harpoon:list():select(3)
      end, { desc = 'Open harpoon 3' })
      vim.keymap.set('n', 'mf', function()
        harpoon:list():select(4)
      end, { desc = 'Open harpoon 4' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', 'ml', function()
        harpoon:list():prev()
      end, { desc = 'Open prev harpoon mark' })
      vim.keymap.set('n', 'mn', function()
        harpoon:list():next()
      end, { desc = 'Open next harpoon mark' })

      vim.keymap.set('n', 'mm', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>pm', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },
}
