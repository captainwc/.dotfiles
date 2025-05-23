-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 通用配置
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.relativenumber = false

-- [插件]
-- -- FLoatTerm
vim.g.floaterm_width = 0.6
vim.g.floaterm_height = 0.6
vim.g.floaterm_autoclose = 0
-- vim.opt.shell = "D:/env/msys2/usr/bin/bash.exe"

-- osc52 - for paste/yank with system
local function copy(lines, _)
    require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

vim.g.clipboard = {
    name = "osc52",
    copy = { ["+"] = copy, ["*"] = copy },
    paste = { ["+"] = paste, ["*"] = paste },
}
