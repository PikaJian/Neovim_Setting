return
{
    {
        'ojroques/nvim-osc52',
        config = function(_, opts)
            require("osc52").setup(opts)
            local function copy(lines, _)
                require('osc52').copy(table.concat(lines, '\n'))
            end

            local function paste()
                return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
            end

            vim.g.clipboard = {
                name = 'osc52',
                copy = {['+'] = copy, ['*'] = copy},
                paste = {['+'] = paste, ['*'] = paste},
            }
        end,
        --[[ keys = {
            { '<leader>oc', mode = "n", '"+y', desc = "copy" },
            { '<leader>occ', mode = "n", '"+yy', desc = "copy line" },
            { '<leader>oc', mode = "n", require('osc52').copy_operator, desc = "copy" },
            { '<leader>cc', mode = "n", '<leader>c_', desc = "copy line" },
            { '<leader>oc', mode = "v", require('osc52').copy_visual, desc = "copy visual" },
        } ]]
    }
}
