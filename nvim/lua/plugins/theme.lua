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
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
    },
    {
        "olimorris/onedarkpro.nvim",
    },
    {
        "marko-cerovac/material.nvim",
    },
    {
        "Mofiqul/dracula.nvim",
    },
    {
        "Mofiqul/vscode.nvim",
    },
}
