
require("toggleterm").setup{
    direction = 'float',
}


vim.g.mapleader = ','

require("plugins.toggleterm")
require("plugins.dressing")
require("plugins.noice")
--slow for big source file (line > 3000)
--require("plugins.indent-blankline")
require("plugins.nvim-treesitter")

if vim.g.git_old == 0
then
    require("plugins.nvim-tree")
end
