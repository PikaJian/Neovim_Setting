
require("toggleterm").setup{
    direction = 'float',
}


vim.g.mapleader = ','

--[[
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
--]]


--[[
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = false

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
--]]

require("plugins.toggleterm")
require("plugins.dressing")
require("plugins.noice")
--slow for big source file (line > 3000)
--require("plugins.indent-blankline")
require("plugins.nvim-treesitter")
require("plugins.dashboard-nvim")

