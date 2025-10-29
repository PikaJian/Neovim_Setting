return 
{
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    -- event = "VeryLazy",
    opts = {
          panel = {
            enabled = false,
          },
          suggestion = {
            enabled = false,
          },
          filetypes = {
            yaml = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          copilot_node_command = 'node', -- Node.js version must be > 18.x
          server_opts_overrides = {},
    },
    config = function(opts)
      print("copilot.lua setup")
      if vim.g.copilot == 1 then
        require('copilot').setup(opts)
      end
    end,

  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    event = "VeryLazy",
    opts = {
      model = 'gpt-5',
      debug = true, -- Enable debugging
      -- See Configuration section for rest
      -- default window options
      window = {
        layout = 'float', -- 'vertical', 'horizontal', 'float'
        -- Options below only apply to floating windows
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        width = 0.8, -- fractional width of parent
        height = 0.6, -- fractional height of parent
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = 'Copilot Chat', -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

}
