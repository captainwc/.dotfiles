if vim.g.vscode then
    require("config.lazy")
    require("vscode")
else
    -- bootstrap lazy.nvim, LazyVim and your plugins
    require("config.lazy")

    -- It's NOUse now, remain here just as an example
    -- config about mini.surround referred to plugins/minisurround.lua
    -- require("mini.surround").setup()

    -- vim.cmd([[colorscheme catppuccin-mocha]])
    vim.cmd([[colorscheme dracula]])
    -- vim.cmd.colorscheme = "embark"

    -- 启用 true-color 支持
    vim.opt.termguicolors = true

    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.bash*",
        command = "set filetype=sh",
    })
end
