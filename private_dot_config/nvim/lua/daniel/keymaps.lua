-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "ss", "<C-w><C-s>", { desc = "Split horizontal" })
vim.keymap.set("n", "sv", "<C-w><C-v>", { desc = "Split vertical" })
vim.keymap.set("n", "sh", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "sl", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "sj", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "sk", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-D>", "<C-D>zz", { desc = "Page Down" })
vim.keymap.set("n", "<C-U>", "<C-U>zz", { desc = "Page Down" })

vim.keymap.set("n", "<leader>lo", ":so %<CR>", { desc = "Reload current file" })

vim.keymap.set("n", "<leader>xf", "<cmd>!chmod +x %<CR>", { desc = "make current file executable" })

vim.keymap.set("n", "<leader>pn", function()
	Snacks.notifier.show_history()
end, { desc = "Show snacks notifications" })

local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

vim.keymap.set("n", "<leader>pm", function()
	local output = vim.api.nvim_exec2("messages", { output = true }).output
	local output_lines = split(output, "\n")

	local w = Snacks.win.new({ fixbuf = true, enter = true, text = output_lines })
end, { desc = "Show :messages in buffer" })

vim.keymap.set("n", "-", function()
	local oil = require("oil.actions")
	oil.parent.callback()
end, { desc = "Open parent dir" })

vim.keymap.set("n", "<C-l>", function()
	require("oil.actions").refresh().callback()
end, { desc = "Refresh directory info" })
