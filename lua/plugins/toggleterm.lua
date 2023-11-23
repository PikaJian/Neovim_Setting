return {
    {
        'akinsho/toggleterm.nvim',
        opts = {
            direction = "float"
        },
        config = function (_, opts)
            require("toggleterm").setup(opts)
            local set_terminal_keymaps = function ()
                local term_opts = {buffer = 0}
                vim.keymap.set('t', '<esc>', [[<esc>]], term_opts)
                vim.keymap.set('t', 'jk', [[<C-\><C-n>]], term_opts)
                vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], term_opts)
                vim.keymap.set('t', '<Tab>', [[<Tab>]], term_opts)
            end
            vim.api.nvim_create_autocmd("TermOpen", {
                pattern = "term://*",
                callback = function()
                    set_terminal_keymaps()
                    return true
                end,
            })

        end,
        keys = {
            {'<leader>ot', '<Cmd>ToggleTerm<CR>', mode = 'n', silent = true, noremap = true, desc = "Toggle term"}
        }
    }
}
