
require("toggleterm").setup{
    direction = 'float',
}

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<esc>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.g.mapleader = ','
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

vim.keymap.set('n', '<leader>ot', ':ToggleTerm<CR>', {noremap = true})

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = false

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

-- nvim-tree key
vim.keymap.set('n', '<leader>nt', '<cmd>NvimTreeToggle<CR>', {noremap = true})

