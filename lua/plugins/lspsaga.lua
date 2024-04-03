return {
  'nvimdev/lspsaga.nvim',
  event = "LazyFile",
  config = function(opts)
    require('lspsaga').setup(opts)
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons'     -- optional
  },
  keys = {
      { "<leader>pd", mode = {"n"}, "<cmd>Lspsaga peek_definition<cr>", desc = "Lspsaga peek definition" },
      { "<leader>ca", mode = {"n" , "v"}, "<cmd>Lspsaga code_action<cr>", desc = "Lspsaga code action" },
      { "<leader>k", mode = {"n"}, "<cmd>Lspsaga hover_doc<cr>", desc = "Lspsaga hover doc" },
  }
}
