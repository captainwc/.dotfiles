return {
    "saghen/blink.cmp",
    build = "cargo build --release",
    opts = {
        fuzzy = { implementation = "rust" },
        completion = {
            accept = {
                -- experimental auto-brackets support
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                auto_show = true,
                draw = {
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = {
                enabled = vim.g.ai_cmp,
            },
        },

        -- experimental signature help support
        signature = { enabled = true },

        sources = {
            -- adding any nvim-cmp sources here will enable them
            -- with blink.compat
            compat = {},
            default = { "lsp", "path", "snippets", "buffer" },
        },

        cmdline = {
            enabled = true,
            keymap = { preset = "inherit" },
            completion = {
                menu = {
                    auto_show = true,
                },
            },
        },

        keymap = {
            preset = "default",
            ["<Tab>"] = { "select_and_accept", "fallback" },
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            ["<C-d>"] = { "scroll_documentation_up", "fallback" },
        },
    },
}
