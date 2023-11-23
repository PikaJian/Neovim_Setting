require("neo-tree").setup(
    {
        window = {
          position = "left",
          width = 30,
        }
    }
)

vim.keymap.set('n', '<leader>fe',
    function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
    end,
    {noremap = true})
