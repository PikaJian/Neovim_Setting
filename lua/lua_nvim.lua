-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

require("config.options")

require("plugins.toggleterm")
require("plugins.dressing")
require("plugins.noice")

--slow for big source file (line > 3000)
require("plugins.indentscope")
require("plugins.indent-blankline")

--slow for big file
require("plugins.nvim-treesitter")

require("plugins.dashboard-nvim")
require("plugins.lsp")
require("plugins.nvim-cmp")
require("plugins.lualine")
require("plugins.bufferline")
require("plugins.nvim-spectre")

--slow for big file, nvim-ts-context-commentstring
require("plugins.coding")

require("plugins.illuminate")
require("plugins.trouble")
require("plugins.neo-tree")
require("plugins.osc52")
require("plugins.luasnip")

require("config.commands")
require("config.autocmds")
require("config.keybindings")

--require("plugins.flash")
--gitsigns require newer git version
--[[require("plugins.gitsigns")
if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.statuscolumn = [[%!v:lua.Status.statuscolumn()<]
end]]
