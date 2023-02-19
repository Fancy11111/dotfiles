local alpha = require("alpha")
math.randomseed(os.clock() ^ 5)

local programs_path = "cat | ~/.config/nvim/programs/"

local header_color = "AlphaCol" .. math.random(11)

---@param name string
---@return boolean
local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

---@param tbl table
---@return string
local function aggregate_string_table(tbl)
    local s = ""
    for i, value in pairs(tbl) do
        if i == 1 then
            s = value
        else
            s = s .. "\n" .. value
        end
    end
    return s
end

---@param tbl table
---@return table
local function extend_string_table(tbl)
    local extended = {}
    for i, value in pairs(tbl) do
        extended[i] = {
            type = "text",
            val = value,
            opts = {
                hl = header_color, position = "center"
            }
        }
    end
    return extended
end

---@param sc string
---@param txt string
---@param keybind string?
---@param keybind_opts table?
---@param opts table?
---@return table
local function button(sc, txt, keybind, keybind_opts, opts)
    local def_opts = {
        cursor = 5,
        align_shortcut = "right",
        hl_shortcut = "AlphaButtonShortcut",
        hl = "AlphaButton",
        width = 35,
        position = "center",
    }
    opts = opts and vim.tbl_extend("force", def_opts, opts) or def_opts
    opts.shortcut = sc
    local sc_ = sc:gsub("%s", ""):gsub("SPC", "<Leader>")
    local on_press = function()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end
    if keybind then
        keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end
    return { type = "button", val = txt, on_press = on_press, opts = opts }
end

local ascii_art = {
    {
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠋⠉⣉⣉⠙⠿⠋⣠⢴⣊⣙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⢀⠔⡩⠔⠒⠛⠧⣾⠊⢁⣀⣀⣀⡙⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⠁⠀⠀⠀⠀⠀⡡⠊⠀⠀⣀⣠⣤⣌⣾⣿⠏⠀⡈⢿⡜⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠡⣤⣶⠏⢁⠈⢻⡏⠙⠛⠀⣀⣁⣤⢢⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣄⡀⠣⣌⡙⠀⣘⡁⠜⠈⠑⢮⡭⠴⠚⠉⠀⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⠁⠀⢀⠔⠁⣀⣤⣤⣤⣤⣤⣄⣀⠀⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠁⠀⢀⣠⢠⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⡀⠀⢸⠀⢼⣿⣿⣶⣭⣭⣭⣟⣛⣛⡿⠷⠶⠶⢶⣶⣤⣤⣤⣶⣶⣾⡿⠿⣫⣾⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠈⠉⠉⠉⠉⠉⠙⠛⠛⠻⠿⠿⠿⠷⣶⣶⣶⣶⣶⣶⣶⣶⡾⢗⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣄⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣝⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
        [[ ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]],
    },
    {
        [[⣤⣤⣤⣤⣀⠀⠀⣤⣤⣤⣤⡄⠀⣤⣤⣤⣤⠀⣤⣤⣤⣤⣤]],
        [[⣿⡇⠀⠈⢻⣧⠀⣿⡇⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⢠⡾⠃]],
        [[⣿⡇⠀⠀⢸⣿⠀⣿⡟⠛⠛⠀⠀⣿⠛⠛⠓⠀⠀⣠⡿⠁ ]],
        [[⣿⡇⢀⣀⣾⠏⠀⣿⡇⠀⠀⠀⠀⣿⠀⠀⠀⠀⣴⡟⠁⠀⠀]],
        [[⠛⠛⠛⠋⠁⠀⠀⠛⠛⠛⠛⠃⠀⠛⠛⠛⠛⠁⠛⠛⠛⠛⠛]],
        [[⣿⣿⡄⠀⢸⣿⠀⢸⡇⠀⠀⠀⣿⠀⠛⠛⢻⡟⠛⠋⣴⡟⠋⠛⠃]],
        [[⣿⠘⣿⡄⢸⣿⠀⢸⡇⠀⠀⠀⣿⠀⠀⠀⢸⡇⠀⠀⠙⢿⣦⣄⠀]],
        [[⣿⠀⠈⢿⣾⣿⠀⢸⣇⠀⠀⠀⣿⠀⠀⠀⢸⡇⠀⠀⠀⠀⠈⢻⣷]],
        [[⠿⠀⠀⠈⠿⠿⠀⠈⠻⠶⠶⠾⠋⠀⠀⠀⠸⠇⠀⠀⠻⠶⠶⠿⠃]]
    },
    {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    }
}

local function getRandomElement(table)
    local randomIndex = math.random(1, #table) -- or short math.random(#array)
    local randomElement = table[randomIndex]

    return extend_string_table(randomElement)
end

-- dashboard.section.header.val = getRandomElement(ascii_art);
--
-- dashboard.section.buttons.val = {
--     --  dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
--     --  -- dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
--     --  dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
--     --  dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
--     -- -- dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
--     --  dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
--     --  dashboard.button("q", " " .. " Quit", ":qa<CR>"),
--
--     dashboard.button("f", ">find file", ":Telescope find_files <CR>"),
--     dashboard.button("p", ">find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
--     dashboard.button("r", ">recent files", ":Telescope oldfiles <CR>"),
--     dashboard.button("s", ">scratchpad", ":e ~/documents/scratchpad <CR>"),
--     dashboard.button("t", ">todolist", ":e ~/documents/todolist <CR>"),
--     dashboard.button("c", ">config", ":e ~/.config/nvim/init.lua <CR>"),
--     dashboard.button("q", ">quit", ":qa<CR>"),
-- }
--
-- dashboard.section.buttons.opts = {
--     spacing = 0,
--     position = "center"
-- }

local function info()
    local plugins = 0
    -- if plugins_ok then
    --     plugins = #vim.tbl_keys(packer_plugins)
    -- end
    local v = vim.version()
    local datetime = os.date " %d-%m-%Y   %H:%M:%S"
    local platform = vim.fn.has "win32" == 1 and "" or ""
    return string.format(" %d   v%d.%d.%d %s  %s", plugins, v.major, v.minor, v.patch, platform, datetime)
end

local function footer()
    local footers = {
        {
            "YESTERDAY YOU SAID TOMMOROW",
            "Don't let your dreams be memes,",
            "Don't meme your dreams be beams,",
            "Jet fuel won't melt tomorrow's memes,",
            "DON'T LET YOUR STEEL MEMES BE JET DREAMS"
        },
        {
            "Sodium, atomic number 11,",
            " was first isolated by Humphry Davy in 1807.",
            "A chemical component of salt,",
            "he named it Na in honor of the saltiest region on earth, North America."
        },
        {
            "I love my ibeeeb <3"
        }
    }
    return getRandomElement(footers)
end

local function mru()
    local result = {}
    for _, filename in ipairs(vim.v.oldfiles) do
        if file_exists(filename) then
            local icon, hl = require("nvim-web-devicons").get_icon(filename, vim.fn.fnamemodify(filename, ":e"))
            local filename_short = string.sub(vim.fn.fnamemodify(filename, ":t"), 1, 30)
            table.insert(
                result,
                button(
                    tostring(#result + 1),
                    string.format("%s  %s", icon, filename_short),
                    string.format("<Cmd>e %s<CR>", filename),
                    nil,
                    { hl = { { hl, 0, 3 }, { "Normal", 5, #filename_short + 5 } } }
                )
            )
            if #result == 9 then
                break
            end
        end
    end
    return result
end

-- dashboard.section.footer.val = footer()
--
-- dashboard.section.footer.opts.hl = "Type"
-- dashboard.section.header.opts.hl = "Include"
-- dashboard.section.buttons.opts.hl = "Keyword"
--
-- dashboard.opts.opts.noautocmd = true
-- alpha.setup(dashboard.opts)



alpha.setup {
    layout = {
        { type = "padding", val = 2 },
        {
            type = "group",
            val = getRandomElement(ascii_art),
            opts = { hl = header_color, position = "center" },
        },
        { type = "padding", val = 1 },
        {
            type = "text",
            val = info(),
            opts = { hl = header_color, position = "center" },
        },
        { type = "padding", val = 4 },
        {
            type = "group",
            val = {
                button("f", " find file", ":Telescope find_files <CR>"),
                button("p", " find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
                button("r", " recent files", ":Telescope oldfiles <CR>"),
                button("s", " scratchpad", ":e ~/documents/scratchpad <CR>"),
                button("t", " todolist", ":e ~/documents/todolist <CR>"),
                button("c", " config", ":e ~/.config/nvim <CR>"),
                button("q", " quit", ":qa<CR>"),

            },
            opts = { spacing = 0 },
        },
        -- { type = "padding", val = 3 },
        -- { type = "terminal", command = programs_path .. "clock", height = 30, width = 100 },
        -- {
        --     type = "terminal",
        --     command = programs_path .. "clock",
        --     height = 2,
        --     width = 40,
        --     opts = {
        --         redraw = true,
        --         window_config = {},
        --     },
        -- },
        { type = "padding", val = 3 },
        -- { type = "terminal", command = "pwd", height = 10, width = 100,
        --     opts = {
        --         redraw = true,
        --         window_config = {},
        --     },
        -- },
        -- { type = "padding", val = 3 },
        {
            type = "group",
            val = footer(),
            opts = { hl = "Footer", position = "center" },
        },
    },
    opts = {
        setup = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                desc = "Disable status and tabline for alpha",
                callback = function()
                    vim.go.laststatus = 0
                    vim.opt.showtabline = 0
                end,
            })
            vim.api.nvim_create_autocmd("BufUnload", {
                buffer = 0,
                desc = "Enable status and tabline after alpha",
                callback = function()
                    vim.go.laststatus = 3
                    vim.opt.showtabline = 2
                end,
            })
        end,
        margin = 5,
    },
}
