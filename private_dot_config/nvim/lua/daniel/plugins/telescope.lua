return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"BurntSushi/ripgrep",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"ThePrimeagen/git-worktree.nvim",
		},
		-- keys = {
		-- 	{ "<Leader>p", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
		-- 	{ "<Leader>fs", "<Cmd>Telescope live_grep<CR>", desc = "Grep inside files" },
		-- 	{ "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Search in vim :help" },
		-- 	{ "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "List and search buffers" },
		-- 	{ "<Leader>fq", "<Cmd>Telescope quickfix<CR>", desc = "List and search quickfix" },
		-- 	{
		-- 		"<Leader>fd",
		-- 		'<Cmd>lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })<CR>',
		-- 		desc = "Find files in config path",
		-- 	},
		-- 	{
		-- 		"<Leader>fw",
		-- 		'<Cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>',
		-- 		desc = "Grep word under cursor",
		-- 	},
		-- },
		config = function()
			local telescope = require("telescope")
			local themes = require("telescope.themes")
			local previewers = require("telescope.previewers")

			local keymap = vim.keymap.set

			telescope.load_extension("harpoon")

			keymap(
				"n",
				"<leader>pf",
				":Telescope file_browser<CR>",
				{ desc = "Open Telescope File Browser", noremap = true }
			)

			keymap("n", "<C-p>", ":Telescope", { noremap = true })
			keymap("n", "<leader>ps", function()
				require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ") })
			end, { desc = "Telescope search in file", noremap = true })
			keymap("n", "<C-p>", function()
				require("telescope.builtin").git_files()
			end, { desc = "Telescope search in git", noremap = true })
			keymap("n", "<Leader>pf", function()
				require("telescope.builtin").find_files()
			end, { desc = "Telescope search for files", noremap = true })

			keymap("n", "<Leader>pp", function()
				require("telescope.builtin").live_grep()
			end, { desc = "Telescope live search for string", noremap = true })

			keymap(
				"n",
				"<Leader>ph",
				":Telescope harpoon marks<CR>",
				{ noremap = true, desc = "Search in Harpoon marks" }
			)

			keymap("n", "<leader>pw", function()
				require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
			end, { desc = "Search for string", noremap = true })
			keymap("n", "<leader>pb", function()
				require("telescope.builtin").buffers()
			end, { desc = "Search in buffers", noremap = true })
			keymap("n", "<leader>vh", function()
				require("telescope.builtin").help_tags()
			end, { desc = "Search in NVIM doc", noremap = true })

			-- TODO: Fix this immediately
			keymap("n", "<leader>vwh", function()
				require("telescope.builtin").help_tags()
			end, { desc = "Search builtin functions", noremap = true })

			keymap("n", "<leader>vrc", function()
				require("daniel.telescope").search_dotfiles()
			end, { desc = "Telescope search dot files", noremap = true })

			keymap("n", "<leader>gc", function()
				require("daniel.telescope").git_branches()
			end, { desc = "View git branches", noremap = true })
			keymap("n", "<leader>gw", function()
				require("telescope").extensions.git_worktree.git_worktrees()
			end, { desc = "View git worktrees", noremap = true })
			keymap("n", "<leader>gm", function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end, { desc = "Git checkout remote branch", noremap = true })

			keymap("n", "<leader>pm", ":Telescope harpoon marks<CR>", { desc = "Telescope: Harpoon marks" })

			local theme_defaults = themes.get_dropdown({
				win_blend = 10,
				results_height = 0.25,
				width = 0.65,
				shorten_path = true,
			})

			telescope.setup({
				defaults = vim.tbl_extend("error", theme_defaults, {
					file_previewer = previewers.vim_buffer_cat.new,
					grep_previewer = previewers.vim_buffer_vimgrep.new,
					qflist_previewer = previewers.vim_buffer_qflist.new,
					color_devicons = true,
					prompt_prefix = " >",

					file_sorter = require("telescope.sorters").get_fzy_sorter,
				}),
			})

			telescope.load_extension("git_worktree")
			telescope.load_extension("harpoon")
		end,
	},
}
