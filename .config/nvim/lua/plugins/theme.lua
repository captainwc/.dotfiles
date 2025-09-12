return {
    -- Discover new theme in https://dotfyle.com/neovim/colorscheme/top
    {
        "catppuccin/nvim",
        as = "catppuccin",
    },
    {
        "embark-theme/vim",
        config = function()
            vim.cmd("colorscheme embark")
        end,
    },
    {
        "navarasu/onedark.nvim",
        -- opts = {
        --     transparent = true,
        --     styles = {
        --         sidebars = "transparent",
        --         floats = "transparent",
        --     },
        -- },
    },
    {
        "olimorris/onedarkpro.nvim",
    },
    {
        "marko-cerovac/material.nvim",
    },
    {
        "Mofiqul/dracula.nvim",
        config = function()
            local dracula = require("dracula")
            dracula.setup({
                transparent_bg = true,
                overrides = {
                    ["@function"] = { fg = "#3dc8f2" },
                    ["@function.call"] = { fg = "#3dc8f2" },
                    ["@function.macro"] = { fg = "#f9f274", italic = true, bold = true },
                    ["@function.method"] = { fg = "#3dc8f2", italic = true },
                    ["@lsp.mod.readonly"] = { fg = "#f5c812", bold = true },
                    ["@lsp.mod.static"] = { fg = "#955cfe", italic = true, bold = true },
                    ["@lsp.type.function"] = { fg = "#3dc8f2" },
                    ["@lsp.type.macro"] = { fg = "#f9f274", italic = true, bold = true },
                    ["@lsp.type.method"] = { fg = "#3dc8f2", italic = true },
                    ["@lsp.type.namespace"] = { fg = "#91ecb2" },
                    ["@lsp.type.parameter"] = { fg = "#C1AE75", underline = true },
                    ["@lsp.type.property"] = { fg = "#C7EDCC", italic = true },
                    ["@lsp.type.typeParameter"] = { fg = "#C1AE75", bold = true },
                    ["@macro"] = { fg = "#f9f274", italic = true, bold = true },
                    ["@method"] = { fg = "#3dc8f2", italic = true },
                    ["@module"] = { fg = "#91ecb2" },
                    ["@namespace"] = { fg = "#91ecb2" },
                    ["@property"] = { fg = "#C7EDCC", italic = true },
                    ["@variable.member"] = { fg = "#C7EDCC", italic = true },
                    ["@variable.parameter"] = { fg = "#54adc8", underline = true },
                    ["@variable.parameter.reference"] = { fg = "#54adc8", underline = true },
                    ["@class"] = { fg = "#9be8a5" },
                    ["@enum"] = { fg = "#9be8a5", bold = true },
                    ["@lsp.type.class"] = { fg = "#9be8a5" },
                    ["@lsp.type.enum"] = { fg = "#9be8a5", bold = true },
                    ["@lsp.type.struct"] = { fg = "#9be8a5" },
                    ["@struct"] = { fg = "#9be8a5" },
                },
            })
        end,
    },
    {
        "Mofiqul/vscode.nvim",
    },
}
