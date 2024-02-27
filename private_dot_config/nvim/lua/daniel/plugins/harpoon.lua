return {
	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")
			local keymap = vim.keymap.set

			keymap("n", "<Leader>a", function()
				mark.toggle_file()
			end, { noremap = true, desc = "Harpoon: Toggle mark" })
			keymap("n", "<Leader>mn", function()
				ui.nav_next()
			end, { noremap = true, desc = "Harpoon: Go to next mark mark" })
			keymap("n", "<Leader>ml", function()
				ui.nav_prev()
			end, { noremap = true, desc = "Harpoon: Go to next mark" })
			keymap("n", "<Leader>mm", function()
				ui.toggle_quick_menu()
			end, { noremap = true, desc = "Harpoon: Toggle menu" })

			for i = 1, 9 do
				keymap("n", "<Leader>m" .. i, function()
					ui.nav_file(i)
				end, { noremap = true, desc = "Harpoon: Navigate to mark nr " .. i })
			end
		end,
	},
}
