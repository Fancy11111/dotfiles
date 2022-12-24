
local function add_snippet(opts)
    local bufnr = vim.api.nvim_create_buf(false, false)
    local window_opts = {
        relative = "cursor",
        width = 50, 
        height = 20, 
        col = 0, 
        row = 1, 
        anchor = "NW", 
        -- style = "minimal"
    }
    local window = vim.api.nvim_open_win(bufnr, 0, window_opts)
end

vim.api.nvim_create_user_command("AddSnippet", add_snippet, {})
