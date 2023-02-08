-- vim.g.colorscheme = "tokyonight"
vim.g.colorscheme = "nordic"

local colorschemes = { "nordic", "nord", "tokyonight", "nightfox", "duskfox", "nordfox", "terafox", "carbonfox" }

local numColorschemes = 0

for _ in pairs(colorschemes) do
    numColorschemes = numColorschemes + 1
end

local function setColor(color)
    vim.g.colorscheme = color
    vim.api.nvim_exec([[ colorscheme ]] .. color, false)
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
        border = "rounded"
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, colorschemes)
    -- vim.api.nvim_create_autocmd({"BufEnter"}, {
    --     buffer = buf,
    --     callback = function()
    --         vim.api.
    --     end
    -- })
    -- vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', setColor, {noremap = true})
    local window = vim.api.nvim_open_win(buf, 0, window_opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', "", { noremap = true, callback = function()
        local color = vim.api.nvim_get_current_line()
        vim.api.nvim_win_close(window, true)
        setColor(color)
    end })
    --     let buf = nvim_create_buf(v:false, v:true)
    --     call nvim_buf_set_lines(buf, 0, -1, v:true, [ "text"])
    -- let opts = {'relative': 'cursor', 'width': 10, 'height': 2, 'col': 0,
    --     \ 'row': 1, 'anchor': 'NW', 'style': 'minimal'}
    -- let win = nvim_open_win(buf, 0, opts)
    -- " optional: change highlight, otherwise Pmenu is used
    -- call nvim_win_set_option(win, 'winhl', 'Normal:MyHighlight')
end

function ColorMyPencils()
    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.tokyonight_transparent_sidebar = true
    vim.g.tokyonight_transparent = true
    vim.g.gruvbox_invert_selection = '0'
    vim.opt.background = "dark"

    vim.cmd("colorscheme " .. vim.g.colorscheme)

    local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
    end

    hl("SignColumn", {
        bg = "none",
    })

    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#555555",
    })

    hl("CursorLineNR", {
        bg = "None"
    })

    hl("Normal", {
        bg = "none"
    })

    hl("LineNr", {
        fg = "#5eacd3"
    })

    hl("netrwDir", {
        fg = "#5eacd3"
    })

end

ColorMyPencils()

vim.api.nvim_create_user_command("ChooseColor", ChooseColor, {})

setColor(vim.g.colorscheme)
