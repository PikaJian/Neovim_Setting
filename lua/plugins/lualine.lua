
local icons = require("utils.ui").icons

return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons'},
        opts = function()
            return
            {
                options = {
                    theme = "auto",
                    component_separators = "|",
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                    },
                    -- lualine_x = { "filename", { "diff", colored = false } },
                    lualine_x = {},
                    lualine_y = { "filetype", "progress" },
                    lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
                },
                inactive_sections = {
                    lualine_a = { "filename" },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                --[[ tabline = {
                    lualine_a = {
                        {
                            "buffers",
                            separator = { left = "", right = "" },
                            right_padding = 2,
                            symbols = { alternate_file = "" },
                        },
                    },
                }, ]]
            }
        end
    }
}

