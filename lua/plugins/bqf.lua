return {
    "kevinhwang91/nvim-bqf",
    event = "LazyFile",
    ft = "qf",
    config = function()
        require("bqf").setup({
            qf_win_option = {
                wrap = true,
                number = false,
                relativenumber = false,
            },
            -- func_map = {
            --     tabdrop = "<cr>",
            --     open = "<c-e>",
            -- },
            preview = { win_height = 15 },
        })
    end,
}

