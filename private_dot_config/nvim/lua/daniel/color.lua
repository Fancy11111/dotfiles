-- vim.g.colorscheme = "tokyonight"
local original_colorscheme = "bamboo"
vim.g.colorscheme = original_colorscheme

local colorschemes = {
	-- "nordic",
	"tokyonight",
	"tokyonight-night",
	"tokyonight-storm",
	"tokyonight-moon",
	"nightfox",
	"duskfox",
	"nordfox",
	"terafox",
	"carbonfox",
	"catppuccin-frappe",
	"catppuccin-macchiato",
	"catppuccin-mocha",
	"gruvbox",
	"synthwave84",
	"nord",
	"bamboo",
}

local numColorschemes = 0

for _ in pairs(colorschemes) do
	numColorschemes = numColorschemes + 1
end

local function setColor(color, temp)
	vim.g.colorscheme = color
	vim.api.nvim_exec2([[ colorscheme ]] .. color, {})
	if temp then
		original_colorscheme = color
	end
	-- vim.cmd.highlight("Normal guibg=none")
end

function ChooseColor()
	local buf = vim.api.nvim_create_buf(false, true)
	local window_opts = {
		relative = "cursor",
		width = 20,
		height = 20,
		col = 0,
		row = 1,
		noautocmd = true,
		style = "minimal",
		border = "rounded",
	}
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, colorschemes)
	-- vim.api.nvim_create_autocmd({"BufEnter"}, {
	--     buffer = buf,
	--     callback = function()
	--         vim.api.
	--     end
	-- })
	-- vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', setColor, {noremap = true})
	local window = vim.api.nvim_open_win(buf, true, window_opts)
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
		noremap = true,
		callback = function()
			local color = vim.api.nvim_get_current_line()
			vim.api.nvim_win_close(window, true)
			setColor(color, true)
		end,
	})
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
		noremap = true,
		callback = function()
			vim.api.nvim_win_close(window, true)
			setColor(original_colorscheme, true)
		end,
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = buf,
		callback = function()
			local color = vim.api.nvim_get_current_line()
			-- vim.api.nvim_win_close(window, true)
			setColor(color, false)
		end,
	})
	-- local color = vim.api.nvim_get_current_line()
	-- vim.api.nvim_win_close(window, true)
	-- setColor(color)
	--     let buf = nvim_create_buf(v:false, v:true)
	--     call nvim_buf_set_lines(buf, 0, -1, v:true, [ "text"])
	-- let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
	--     \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
	-- let win = nvim_open_win(buf, 0, opts)
	-- " optional: change highlight, otherwise Pmenu is used
	-- call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
end

function ColorMyPencils()
	-- vim.g.gruvbox_contrast_dark = 'hard'
	-- vim.g.tokyonight_transparent_sidebar = true
	-- vim.g.tokyonight_transparent = true
	-- vim.g.gruvbox_invert_selection = '0'
	-- vim.opt.background = "dark"
	-- print(vim.g.colorscheme)
	-- print(original_colorscheme)
	-- -- vim.cmd("colorscheme " .. vim.g.colorscheme)
	-- -- vim.cmd(c)
	-- local hl = function(thing, opts)
	--     vim.api.nvim_set_hl(0, thing, opts)
	-- end
	--
	-- hl("SignColumn", {
	--     bg = "none",
	-- })
	--
	-- hl("ColorColumn", {
	--     ctermbg = 0,
	--     bg = "#555555",
	-- })
	--
	-- hl("CursorLineNR", {
	--     bg = "None"
	-- })
	--
	-- hl("Normal", {
	--     bg = "none"
	-- })
	--
	-- hl("LineNr", {
	--     fg = "#5eacd3"
	-- })
	--
	-- hl("netrwDir", {
	--     fg = "#5eacd3"
	-- })
	vim.api.nvim_exec2([[ colorscheme ]] .. original_colorscheme, {})
	vim.cmd.highlight("Normal guibg=none")
end

-- vim.defer_fn(function() ColorMyPencils() end, 500)

-- ColorMyPencils()

vim.api.nvim_create_user_command("ChooseColor", ChooseColor, {})

setColor(vim.g.colorscheme)
