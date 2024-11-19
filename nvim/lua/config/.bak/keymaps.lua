-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 禁用 enter 补全
-- vim.api.nvim_set_keymap("i", "<CR>", "<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("c", "<CR>", "<CR>", { noremap = true, silent = true })

-- FloatTerm
vim.api.nvim_set_keymap("n", "<Leader>t", ":FloatermToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<leader>t", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>k", ":FloatermKill<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<leader>k", "<C-\\><C-n>:FloatermKill<CR>", { noremap = true, silent = true })

-- FloatTerm 中运行代码
vim.api.nvim_set_keymap("n", "<F5>", ":lua RunFile()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":lua RunFile()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>d", ":lua DebugFile()<CR>", { noremap = true, silent = true })

-- commenting
vim.api.nvim_set_keymap("n", "<leader>c<space>", ":CommentToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>c<space>", ":CommentToggle<CR>", { noremap = true, silent = true })
