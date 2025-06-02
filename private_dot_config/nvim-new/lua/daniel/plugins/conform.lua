return { -- Autoformat
	"stevearc/conform.nvim",
	-- event = { 'BufWritePre' },
	-- cmd = { 'ConformInfo' },
	lazy = false,
	init = function()
		vim.g.disable_filetypes = { c = true, cpp = true, java = true }
		vim.g.disable_autoformat = false

		vim.api.nvim_create_user_command("FormatToggleFT", function(opts)
			local ft
			local ftTable = vim.g.disable_filetypes

			if opts.nargs == 1 then
				ft = opts.args[1]
			else
				ft = vim.bo.filetype
			end
			if ftTable[ft] == true then
				ftTable[ft] = false
				print("enabling autoformat for ft: " .. ft)
			else
				ftTable[ft] = true
				print("disabling autoformat for ft: " .. ft)
			end
			vim.g.disable_filetypes = ftTable
		end, {
			desc = "Toggle filetype autoformat",
		})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		format_on_save = function(bufnr)
			local lsp_format_opt
			if vim.g.disable_filetypes[vim.bo[bufnr].filetype] then
				-- lsp_format_opt = 'never'
				return
			else
				lsp_format_opt = "fallback"
			end

			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return {
				timeout_ms = 500,

				lsp_format = lsp_format_opt,
			}
		end,
		notify_on_error = false,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	},
}
