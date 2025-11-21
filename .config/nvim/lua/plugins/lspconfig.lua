return {
    "neovim/nvim-lspconfig",
    opts = {
        inlay_hints = {
            enabled = false,
            exclude = { "python" },
        },

        servers = {
            clangd = {
                cmd = {
                    "clangd",
                    "--background-index",
                    "-j=12",
                    "--clang-tidy",
                    -- "--clang-tidy-checks=performance-*,bugprone-*",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders=false",
                    "--fallback-style=Google",
                    "--all-scopes-completion",
                    "--enable-config",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            },
            rust_analyzer = {
                standalone = true,
            },
        },
    },
}
