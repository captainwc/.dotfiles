return {
    {
        "luozhiya/fittencode.nvim",
        config = function()
            require("fittencode").setup()
        end,
        opts = {
            disable_specific_inline_completion = {
                suffixes = {},
            },
            inline_completion = {
                enable = false,
                disable_completion_within_the_line = false,
                disable_completion_when_delete = true,
                auto_triggering_completion = true,
            },
            delay_completion = {
                delaytime = 30, -- milliseconds
            },
            chat = {
                highlight_conversation_at_cursor = false,
                style = "floating", -- floating or sidebar
                sidebar = {
                    width = 42,
                    position = "left",
                },
                floating = {
                    border = "rounded",
                    -- <= 1: percentage of the screen size
                    -- >  1: number of lines/columns
                    size = { width = 0.8, height = 0.8 },
                },
            },
            use_default_keymaps = true,
            keymaps = {
                inline = {
                    -- ["<TAB>"] = "accept_all_suggestions",
                    ["<C-Up>"] = "accept_all_suggestions",
                    ["<C-Down>"] = "accept_line",
                    ["<C-Right>"] = "accept_word",
                    -- ["<C-Up>"] = "revoke_line",
                    ["<C-Left>"] = "revoke_word",
                    ["<A-\\>"] = "triggering_completion",
                },
                chat = {
                    ["q"] = "close",
                    ["[c"] = "goto_previous_conversation",
                    ["]c"] = "goto_next_conversation",
                    ["c"] = "copy_conversation",
                    ["C"] = "copy_all_conversations",
                    ["d"] = "delete_conversation",
                    ["D"] = "delete_all_conversations",
                },
            },
        },
    },
}
