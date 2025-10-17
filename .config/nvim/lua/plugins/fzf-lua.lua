return {
    {
        "ibhagwan/fzf-lua",
        config = function()
            require("fzf-lua").setup({
                winopts = {
                    height = 0.9,
                    width = 0.9,
                    -- row = 0,
                    -- col = 0,
                    preview = {
                        layout = "horizontal",
                        vertical = "up:40%",
                        horizontal = "down:60%",
                        -- scrollbar = false,
                    },
                },
                grep = {
                    winopts = {
                        height = 0.95,
                        width = 0.95,
                        preview = {
                            layout = "horizontal",
                            vertical = "up:40%",
                            horizontal = "down:60%",
                        },
                    },
                },
                files = {
                    winopts = {
                        height = 0.95,
                        width = 0.95,
                        preview = {
                            layout = "vertical",
                            vertical = "right:45%",
                            horizontal = "left:55%",
                        },
                    },
                },
                lsp = {
                    symbols = {
                        winopts = {
                            preview = {
                                layout = "vertical",
                                vertical = "right:45%",
                                horizontal = "left:55%",
                            },
                        },
                    },
                },
                buffers = {},
            })
        end,
    },
}
