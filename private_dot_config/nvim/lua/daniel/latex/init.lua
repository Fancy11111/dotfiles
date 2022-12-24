local id = vim.api.nvim_create_augroup("Latex", {})

vim.api.nvim_exec([[autocmd Filetype tex setl updatetime=500]], false)

Preview = {}

local function compileLatexFile()
    local buffername = vim.api.nvim_buf_get_name(0)
    local data = Preview[buffername]

    local name = data["name"]
    local pdfName = data["pdfName"]
    local tempFile = data["tempName"]
    local tempFilePdf = tempFile:gsub(".tex", ".pdf")
    vim.api.nvim_exec("silent :w! " .. tempFile, false)
    -- vim.api.nvim_exec("!pdflatex " .. tempFile, false)
    vim.api.nvim_exec("call jobstart('pdflatex " .. tempFile .. " && mv " .. tempFilePdf .. " " .. pdfName ..  "')", false)
end

local function startLatexPreview()
    local buffername = vim.api.nvim_buf_get_name(0)
    local data = Preview[buffername]
    if (data == nil)
    then
        data = {}
        data["name"] = buffername:gsub(".tex", "")
        data["pdfName"] = buffername:gsub(".tex", ".pdf")
        data["tempName"] = buffername:gsub(".tex", ".temp.tex")
        Preview[buffername] = data
        local pdfName = data["pdfName"]
        vim.api.nvim_exec("call jobstart(['pdflatex','" .. buffername .. "'])", false)
        vim.api.nvim_exec("call jobstart(['zathura','" .. pdfName .. "'])", false)
        -- vim.api.nvim_exec("call jobstart(['zathura','" .. pdfName .. "'])", false)
        vim.api.nvim_create_autocmd({ "BufWrite", "CursorHoldI" }, {
            group = id,
            pattern = { "*.tex" },
            callback = compileLatexFile
        })

        vim.api.nvim_create_autocmd({ "ExitPre" }, {
            group = id,
            pattern = { "*.tex" },
            callback = function()
                vim.api.nvim_exec("silent !rm " .. Preview[buffername]["tempName"], false)
                Preview[buffername] = nil
            end
        })
    end
end

vim.api.nvim_create_user_command("LatexPreview", startLatexPreview, {})
