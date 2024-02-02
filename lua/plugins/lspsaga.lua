return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({})
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons'     -- optional
  },
  keys = {
      { "<leader>pd", mode = {"n"}, "<cmd>Lspsaga peek_definition<cr>", desc = "Flash" },
      { "<leader>ca", mode = {"n" , "v"}, "<cmd>Lspsaga code_action<cr>", desc = "Flash" },
  }
}
