vim.api.nvim_create_augroup("daniel-rust", {
	clear = true,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = { "*.rs" },
	callback = function()
		local snacks = require("snacks")
		vim.keymap.set("n", "<leader>cc", function()
			local t = snacks.terminal.open("cargo check", {
				interactive = false,
			})
			vim.keymap.set("n", "<CR>", ":hide<CR>", { buffer = t.buf })
		end, { desc = "cargo check" })

		vim.keymap.set("n", "<leader>rr", function()
			local t = snacks.terminal.open("cargo run", {
				interactive = false,
			})
			vim.keymap.set("n", "<CR>", ":hide<CR>", { buffer = t.buf })
		end, { desc = "cargo run" })

		vim.keymap.set("n", "<leader>tt", function()
			local t = snacks.terminal.open("cargo test", {
				interactive = false,
			})
			vim.keymap.set("n", "<CR>", ":hide<CR>", { buffer = t.buf })
		end, { desc = "cargo test" })
	end,
})
