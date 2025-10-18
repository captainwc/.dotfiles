return {
    {
        "voldikss/vim-floaterm",
        init = function()
            local default_shell = tostring(vim.fn.getenv("SHELL") or "/bin/bash")
            if jit.os == "Windows" then
                vim.g.floaterm_shell = "pwsh.exe"
                vim.g.floaterm_shellargs = "-NoLogo"
                vim.g.floaterm_title = "PWSH ($1/$2)"
            else
                if string.find(default_shell, "zsh") then
                    vim.g.floaterm_shell = default_shell
                    vim.g.floaterm_shellargs = "-i"
                else
                    vim.g.floaterm_shell = "/bin/bash"
                    vim.g.floaterm_shellargs = "-i"
                end
                vim.g.floaterm_title = (string.find(default_shell, "zsh") and "ZSH" or "BASH") .. " ($1/$2)"
            end
            vim.g.floaterm_width = 0.9
            vim.g.floaterm_height = 0.85
            vim.g.floaterm_autoclose = 0
        end,
        -- keys = {
        --   { "<leader>ft", "<cmd>FloatermToggle<cr>", desc = "Toggle terminal" },
        -- },
    },
}
