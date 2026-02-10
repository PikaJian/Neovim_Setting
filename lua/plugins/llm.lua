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
  "olimorris/codecompanion.nvim",
    -- 你也可以改成 VeryLazy 或 BufRead 後載入
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- 可選：更漂亮的浮窗輸入 UX（LazyVim 通常已有）
      "stevearc/dressing.nvim",
      {
        "nvim-mini/mini.diff",
        config = function()
          local diff = require("mini.diff")
          diff.setup()
        end,
      },
      {
        "folke/snacks.nvim",
        opts = {
          statusline = { enabled = false },  -- 你用 lualine，關掉這個
          layout = { enabled = true },
          picker     = {
            enabled = true ,
            -- 用比較像 Demo 的簡潔佈局
            layout  = { preset = "telescope" },     -- 其他可試 "dropdown" / "minimal"
            -- 有些版本提供格式選項（有就打開），讓清單以表格呈現
          },   -- 只給 CodeCompanion 的選單用
          input      = { enabled = true },   -- 只給 CodeCompanion 的輸入框用
          notifier   = { enabled = false },   -- 可選
          ui = { border = "rounded", backdrop = 0.9 },
        },
      },
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    opts = {
      language = "Chinese",
      memory = {
        paths = { "~/.config/nvim/codecompanion/rules" },
        opts = {
          chat = { default_memory = { "default", "zh" } },
          inline = { default_memory = { "default", "zh" } },
        },
      },
      -- 直接指定使用 Copilot 當後端；符合「公司只買了 Copilot」的場景
      strategies = {
        chat = {
            adapter = {
              model = "claude-sonnet-4.5",
              name = "copilot"
            },
        },
        inline = {
          adapter = {
            model = "claude-sonnet-4.5",
            name = "copilot"
          },
          keymaps = {
            accept_change = {
              modes = { n = "ga" }, -- Remember this as DiffAccept
            },
            reject_change = {
              modes = { n = "gr" }, -- Remember this as DiffReject
            },
            always_accept = {
              modes = { n = "gy" }, -- Remember this as DiffYolo
            },
          },
        },
      },
      -- 推薦：保留乾淨 UI
      display = {
        diff = {
          enabled = true,
          -- Specifies the diff provider to use. Options: 'mini_diff', 'split', or 'inline'.
          provider = "inline", -- mini_diff|split|inline
        },
        chat = {
          show_settings = true,
        },
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            title = "CodeCompanion actions", -- The title of the action palette
          },
        },
      },

      -- 你也可以在這裡自定快捷鍵與指令模板（prompt library）
    },
    keys = {
      -- 開聊天（側邊/浮窗，由 CodeCompanion 決定，可再調整）
      { "<leader>ac",
        function ()
            require("codecompanion").chat(
              {
                window_opts = {
                  layout = "float",
                  width = 0.8
                },
              }
            )
        end,
        desc = "AI Chat (CodeCompanion)"
      },
      -- 視覺模式下對選區做改寫（Inline Assistant）
      {
        "<leader>ai",
        mode = { "v" },
        function()
          -- 把「:'<,'>CodeCompanionInline<CR>」送進命令列
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(":'<,'>CodeCompanion<CR>", true, false, true),
            "nx!",  -- normal + keep selection context + remain insert mode with x
            false
          )
        end,
        desc = "AI Inline on Selection (CodeCompanion)",
      },
      -- 打開動作面板（檔案/選區的一鍵任務）
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions (CodeCompanion)" },
    },
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
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false, -- 強制立即加載，不要延遲
    opts = {
      terminal_cmd = "~/.local/bin/claude", -- Point to local installation
      terminal = {
        ---@module "snacks"
        ---@type snacks.win.Config|{}
        snacks_win_opts = {
          position = "float",
          width = 0.8,
          height = 0.8,
          keys = {
            claude_hide = {
              ",ch",
              function(self)
                self:hide()
              end,
              mode = "t",
              desc = "Hide",
            },
          },
        },
      },
    },
    config = true,
    keys = {
      { ",ch", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "x" } },
      -- { "<leader>a", nil, desc = "AI/Claude Code" },
      -- { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      -- { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      -- { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      -- { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      -- { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      -- { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      -- { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      -- {
      --   "<leader>as",
      --   "<cmd>ClaudeCodeTreeAdd<cr>",
      --   desc = "Add file",
      --   ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      -- },
      -- Diff management
      --{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      --{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  }
}
