-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- leader   由于leader要在加载lazy之前设置，但是放在init.lua最前面又不生效
-- vim.g.mapleader = ","

-- normal
-- Toggle Wrap: Use <leader>uw Instead
-- vim.api.nvim_set_keymap("n", "<leader>w", ":if &wrap | set nowrap | else | set wrap | endif<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<CR>", ":w<esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "U", "<C-r>", { noremap = true, silent = true })

-- FloatTerm
vim.api.nvim_set_keymap("n", "<Leader>t", ":FloatermToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<leader>t", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Leader>k", ":FloatermKill<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<leader>k", "<C-\\><C-n>:FloatermKill<CR>", { noremap = true, silent = true })

-- FloatTerm 中运行代码
vim.api.nvim_set_keymap("n", "<F5>", ":lua RunFile()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F6>", ":lua Hello()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":lua RunFile()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>d", ":lua DebugFile()<CR>", { noremap = true, silent = true })

-- Fittencode
vim.api.nvim_set_keymap("n", "<leader>as", ":Fitten start_chat<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>at", ":Fitten toggle_chat<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ag", ":Fitten generate_unit_test<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ai", ":Fitten implement_features<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>af", ":Fitten find_bug<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ao", ":Fitten optimize_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ar", ":Fitten refactor_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ac", ":Fitten translate_text_into_chinese<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ae", ":Fitten explain_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>am", ":Fitten edit_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>aa", ":Fitten enable_completions<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ad", ":Fitten disable_completions<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<leader>as", ":Fitten start_chat<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>at", ":Fitten toggle_chat<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ag", ":Fitten generate_unit_test<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ai", ":Fitten implement_features<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>af", ":Fitten find_bug<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ao", ":Fitten optimize_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ar", ":Fitten refactor_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ac", ":Fitten translate_text_into_chinese<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ae", ":Fitten explain_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>am", ":Fitten edit_code<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>aa", ":Fitten enable_completions<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ad", ":Fitten disable_completions<CR>", { noremap = true, silent = true })
