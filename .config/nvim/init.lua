if vim.g.vscode then
require("config.lazy")
require("mini.surround").setup()
require("vscode")
else

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- config about mini.surround referred to plugins/minisurround.lua
require("mini.surround").setup()

-- vim.cmd([[colorscheme catppuccin-mocha]])
vim.cmd([[colorscheme dracula]])
-- vim.cmd.colorscheme = "embark"

-- 启用 true-color 支持
vim.opt.termguicolors = true

end