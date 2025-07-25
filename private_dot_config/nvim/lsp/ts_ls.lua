return {
	init_options = {
		plugins = { -- I think this was my breakthrough that made it work
			{
				name = "@vue/typescript-plugin",
				location = "/home/daniel/.local/share/pnpm/global/5/node_modules/@vue/typescript-plugin",
				languages = { "vue", "typescript", "javascript" },
			},
		},
	},
	-- this gets overriden if done here :( --> /lua/daniel/lsp.lua
	-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}
