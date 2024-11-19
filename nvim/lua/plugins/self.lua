return {
    {
        "voldikss/vim-floaterm",
    },
    {
        "hrsh7th/nvim-cmp",
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local cmp = require("cmp")

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<CR>"] = cmp.mapping.abort(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    elseif vim.snippet.active({ direction = 1 }) then
                        vim.schedule(function()
                            vim.snippet.jump(1)
                        end)
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                -- ["<Up>"] = cmp.mapping.select_prev_item(),
                -- ["<Down>"] = cmp.mapping.select_next_item(),
            })
        end,
    },
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
    {
        -- 大纲插件，默认快捷键参见 https://github.com/hedyhli/outline.nvim?tab=readme-ov-file#default-keymaps
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        keys = { -- 示例映射以切换大纲
            { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
        },
        opts = {
            -- 在这里放置你的设置选项
            outline_window = {
                position = "right",
                width = 20,
                relative_width = true,
                -- 当触发goto_location而不是peek_location时自动关闭大纲窗口
                auto_close = false,
                -- 导航大纲窗口时自动滚动到代码位置
                auto_jump = true,
                -- 大纲窗口的Vim选项
                show_numbers = false,
                show_relative_numbers = false,
                wrap = false,
            },

            symbol_folding = {
                autofold_depth = 3,
            },
        },
    },
}
