
local ui = require("utils.ui")

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
                                error = ui.icons.diagnostics.Error,
                                warn = ui.icons.diagnostics.Warn,
                                info = ui.icons.diagnostics.Info,
                                hint = ui.icons.diagnostics.Hint,
                            },
                        },
                    },
                    -- lualine_x = { "filename", { "diff", colored = false } },
                    lualine_x = {
                        {
                            function() return require("noice").api.status.mode.get() end,
                            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                            color = ui.fg("Constant"),
                        },
                    },
                    -- lualine_y = { "filetype", "progress" },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "filetype", padding = { left = 0, right = 1 } },
                        { "location", separator = { right = " " }, left_padding = 2 }
                    },
                    lualine_z = {
                        {
                            function()
                                return " " .. os.date("%R")
                            end,
                            separator = { right = "" }, left_padding = 2
                        }
                    },
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

