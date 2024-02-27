-- setup
require("daniel.set")
require("daniel.remap")
require("daniel.autocommands")

-- require("daniel.lazy")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.opt.runtimepath:append("$HOME/.local/share/lazy/nvim-treesitter/parser")
vim.opt.rtp:append("$HOME/.local/share/lazy/nvim-treesitter/parser")
function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

require("lazy").setup("daniel.plugins")

-- config
require("daniel.color")
-- require("daniel.telescope")
-- require("daniel.alpha")
-- require("daniel.bufferline")
-- require("daniel.lualine")
-- require("daniel.indentline")
