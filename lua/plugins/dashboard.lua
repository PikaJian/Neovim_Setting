return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {'nvim-tree/nvim-web-devicons'},
  opts = {
    theme = "hyper",
    hide = {
      -- this is taken care of by lualine
      -- enabling this messes up the actual laststatus setting after loading a file
      statusline = false,
    },
  },
  config = function(_, opts)
    require("dashboard").setup(opts)
  end
}
