return
{
    {
        'ojroques/nvim-osc52',
        event = "LazyFile",
        config = function(_, opts)
            require("osc52").setup(opts)
            local function copy(lines, _)
                require('osc52').copy(table.concat(lines, '\n'))
            end

            local function paste()
                print(vim.fn.getreg(''))
                return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
            end

            vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
            vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
            vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

            --[[ vim.g.clipboard = {
                name = 'osc52',
                copy = {['+'] = copy, ['*'] = copy},
                paste = {['+'] = paste, ['*'] = paste},
            } ]]
        end,
        --[[ keys = {
            { '<leader>oc', mode = "n", require('osc52').copy_operator, desc = "copy" },
            { '<leader>cc', mode = "n", '<leader>c_', desc = "copy line" },
            { '<leader>oc', mode = "v", require('osc52').copy_visual, desc = "copy visual" },
        } ]]
    }
}
