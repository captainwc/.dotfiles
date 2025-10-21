require("config.lazy")

if vim.g.vscode then
    require("vscode")
else
    vim.cmd([[colorscheme dracula]])

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.bash*",
        command = "set filetype=sh",
    })
end
