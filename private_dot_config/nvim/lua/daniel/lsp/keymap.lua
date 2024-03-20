local M = {}

local keymap = vim.keymap.set

M.setup_keymap = function(bufnr)
	vim.keymap.set("n", "gd", "<Cmd>Lspsaga goto_definition<CR>", { buffer = bufnr, desc = "LSP go to definition" })

	vim.keymap.set(
		"n",
		"gt",
		"<Cmd>Lspsaga peek_type_definition<CR>",
		{ buffer = bufnr, desc = "LSP go to type definition" }
	)
	vim.keymap.set(
		"n",
		"gD",
		"<Cmd>lua vim.lsp.buf.declaration()<CR>",
		{ buffer = bufnr, desc = "LSP go to declaration" }
	)
	vim.keymap.set(
		"n",
		"gi",
		"<Cmd>lua vim.lsp.buf.implementation()<CR>",
		{ buffer = bufnr, desc = "LSP go to implementation" }
	)

	vim.keymap.set("n", "gw", "<Cmd>Lspsaga lsp_finder<CR>", { buffer = bufnr, desc = "LSP document symbols" })
	vim.keymap.set(
		"n",
		"gW",
		"<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
		{ buffer = bufnr, desc = "LSP Workspace symbols" }
	)
	vim.keymap.set("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { buffer = bufnr, desc = "LSP show references" })

	vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", { buffer = bufnr, desc = "LSP hover documentation" })
	vim.keymap.set(
		"n",
		"<leader>K",
		"<Cmd>lua vim.lsp.buf.signature_help()<CR>",
		{ buffer = bufnr, desc = "LSP signature help" }
	)

	vim.keymap.set(
		"n",
		"<leader>ca",
		"<Cmd>Lspsaga code_action<CR>",
		{ buffer = bufnr, desc = "LSP show code actions" }
	)

	vim.keymap.set("n", "<leader>rn", "<Cmd>Lspsaga rename<CR>", { buffer = bufnr, desc = "LSP rename word" })

	vim.keymap.set(
		"n",
		"<leader>dn",
		"<Cmd>Lspsaga diagnostic_jump_next<CR>",
		{ buffer = bufnr, desc = "LSP go to next diagnostic" }
	)

	vim.keymap.set(
		"n",
		"<leader>dp",
		"<Cmd>Lspsaga diagnostic_jump_prev<CR>",
		{ buffer = bufnr, desc = "LSP go to previous diagnostic" }
	)
	-- Diagnostic jump with filters such as only jumping to an error
	keymap("n", "[E", function()
		require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, { buffer = bufnr, desc = "LSP go to previous error diagnostic" })
	keymap("n", "]E", function()
		require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, { buffer = bufnr, desc = "LSP go to next error diagnostic" })

	-- Diagnostic jump
	-- You can use <C-o> to jump back to your previous location
	keymap(
		"n",
		"[e",
		"<cmd>Lspsaga diagnostic_jump_prev<CR>",
		{ buffer = bufnr, desc = "LSP go to previous diagnostic" }
	)
	keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { buffer = bufnr, desc = "LSP go to next diagnostic" })

	vim.keymap.set(
		"n",
		"<leader>sc",
		"<Cmd>Lspsaga show_cursor_diagnostics<CR>",
		{ buffer = bufnr, desc = "LSP show diagnostic under cursor" }
	)

	vim.keymap.set(
		"n",
		"<leader>sl",
		"<Cmd>Lspsaga show_line_diagnostics<CR>",
		{ buffer = bufnr, desc = "LSP show line diagnostic" }
	)

	vim.keymap.set(
		"n",
		"<leader>sb",
		"<Cmd>Lspsaga show_buffer_diagnostics<CR>",
		{ buffer = bufnr, desc = "LSP show buffer diagnostic" }
	)

	-- Call hierarchy
	keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", {
		desc = "LSP Show incoming calls",
		buffer = bufnr,
	})
	keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", {
		desc = "LSP Show outgoing calls",
		buffer = bufnr,
	})

	-- Floating terminal
	keymap({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>", {
		desc = "Toggle floating terminal",
		buffer = bufnr,
	})
end

return M
