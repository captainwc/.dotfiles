return {
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
