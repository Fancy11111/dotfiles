return {
	"scalameta/nvim-metals",
	ft = { "scala", "sbt", "java" },
	opts = function()
		local metals_config = require("metals").bare_config()
		metals_config.init_options.statusBarProvider = "off"
		metals_config.on_attach = function(client, bufnr)
			require("metals").setup_dap()
			require("daniel.utils").lsp_on_attach(client, bufnr)
			vim.lsp.codelens.enable(true)
		end
		metals_config.settings = {
			serverVersion = "2.0.0-M16",
			serverProperties = { "-Xmx4g" },
			testUserInterface = "Test Explorer",
		}
		return metals_config
	end,
	config = function(self, metals_config)
		local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = self.ft,
			callback = function()
				require("metals").initialize_or_attach(metals_config)
			end,
			group = nvim_metals_group,
		})
	end,
}
