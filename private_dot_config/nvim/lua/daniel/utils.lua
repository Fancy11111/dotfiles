local M = {}

M.lsp_capabilities = function()
	return require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
end

M.lsp_on_attach = function(client, bufnr)
	-- your on_attach function
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	map("gd", ":FzfLua lsp_definitions<CR>", "[G]oto [D]efinition")
	--
	-- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	map("gr", ":FzfLua lsp_references<CR>", "[G]oto [R]eferences")
	--
	-- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	map("gI", ":FzfLua lsp_implementations<CR>", "[G]oto [I]mplementation")
	--
	-- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
	map("<leader>D", ":FzfLua lsp_type_definitions<CR>", "Type [D]efinition")
	--
	-- map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	map("<leader>ds", ":FzfLua lsp_document_symbols<CR>", "[D]ocument [S]ymbols")
	--
	-- map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	map("<leader>ws", ":FzfLua lsp_live_workspace_symbols<CR>", "[W]orkspace [S]ymbols")
	--
	-- Rename the variable under your cursor.
	--  Most Language Servers support renaming across files, etc.
	map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	--  For example, in C this would take you to the header.
	map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	-- The following two autocommands are used to highlight references of the
	-- word under your cursor when your cursor rests there for a little while.
	--    See `:help CursorHold` for information about when this is executed
	--
	-- When you move your cursor, the highlights will be cleared (the second autocommand).
	-- local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
		local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
			end,
		})
	end

	-- The following code creates a keymap to toggle inlay hints in your
	-- code, if the language server you are using supports them
	--
	-- This may be unwanted, since they displace some of your code
	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
		end, "[T]oggle Inlay [H]ints")
	end
end

return M
