local Util = require("utils")

return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = false
      }
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { "<leader>fe",
        function()
          -- 如果已經有任何 oil 視窗，就把它關掉（達到 toggle 效果）
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "oil" then
              vim.api.nvim_win_close(win, true)
              return
            end
          end
          -- 開一個左側直分割並設定寬度，再在該分割裡開 oil
          vim.cmd("leftabove vsplit")
          vim.cmd("vertical resize 25")  -- 自訂側欄寬度
          require("oil").open(vim.loop.cwd()) -- 也可帶路徑參數，見下方說明
          --（可選）側欄一些習慣性的視窗選項
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.wrap = false
        end,
        desc = "Open parent directory" },
    },
  },
  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
  -- search/replace in multiple files
  --[[ {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  }, ]]

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  {
    "RRethy/vim-illuminate",
    event = "LazyFile",
    opts = {
      delay = 200,
      large_file_cutoff = 5000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      should_enable = function(bufnr)
        local mode = vim.fn.mode()
        if mode == 'v' or mode == 'V' or mode == "" then
          return false
        else
          return true
        end
      end,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",  desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  --[[ {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  }, ]]
  {
    'stevearc/aerial.nvim',
    event = "LazyFile",
    opts = function()

      local opts = {
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },
        show_guides = true,
        layout = {
          resize_to_content = false,
          win_opts = {
            winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
            signcolumn = "yes",
            statuscolumn = " ",
          },
        },
        -- icons = icons,
        -- filter_kind = filter_kind,
        -- stylua: ignore
        guides = {
          mid_item   = "├╴",
          last_item  = "└╴",
          nested_top = "│ ",
          whitespace = "  ",
        },
        -- Disable aerial on files with this many lines 
        disable_max_lines = 20000,
      }
      return opts
    end,
    -- Optional dependencies
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>t",  "<cmd>AerialToggle!<CR>",                desc = "Aerial Toggle" },
    }
  },
  -- Fuzzy finder.
  -- The default key bindings to find files will use Telescope's
  -- `find_files` or `git_files` depending on whether the
  -- directory is a git repo.
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
    },
    keys = {
      { "<leader>,",  "<cmd>Telescope buffers show_all_buffers=true<cr>",                desc = "Switch Buffer" },
      { "<leader>/",  Util.telescope("live_grep"),                                       desc = "Grep (root dir)" },
      { "<leader>:",  "<cmd>Telescope command_history<cr>",                              desc = "Command History" },
      { "<leader>ff", Util.telescope("files"),                                           desc = "Find Files (root dir)" },
      -- find
      { "<C-p>", "<cmd>Telescope buffers<cr>",                                      desc = "Buffers" },
      { "<leader>fc", Util.telescope.config_files(),                                     desc = "Find Config File" },
      { "<leader>ff", Util.telescope("files"),                                           desc = "Find Files (root dir)" },
      { "<leader>f",      Util.telescope("files", { cwd = false }),                          desc = "Find Files (cwd)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                     desc = "Recent" },
      { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }),              desc = "Recent (cwd)" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>",                                  desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>",                                   desc = "status" },
      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>",                                    desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>",                                 desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",                    desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>",                              desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>",                                     desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>",                          desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>",                                  desc = "Workspace diagnostics" },
      { "<leader>sg", Util.telescope("live_grep"),                                       desc = "Grep (root dir)" },
      { "<leader>sG", Util.telescope("live_grep", { cwd = false }),                      desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",                                    desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>",                                   desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",                                      desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>",                                    desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>",                                        desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>",                                  desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>",                                       desc = "Resume" },
      { "<leader>w",  Util.telescope("grep_string", { word_match = "-w" }),              desc = "Word (root dir)" },
      { "<leader>W",  Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>w",  Util.telescope("grep_string"),                                     mode = "v",                       desc = "Selection (root dir)" },
      { "<leader>W",  Util.telescope("grep_string", { cwd = false }),                    mode = "v",                       desc = "Selection (cwd)" },
      { "<leader>uC", Util.telescope("colorscheme", { enable_preview = true }),          desc = "Colorscheme with preview" },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = require("config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
            symbols = require("lazyvim.config").get_kind_filter(),
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
    opts = function()
      local actions = require("telescope.actions")
      local actions_set = require('telescope.actions.set')
      -- define custom actions
      local myactions = require("telescope.actions.mt").transform_mod({
        select_scrollup = {
          action = function(prompt_bufnr)
            return actions_set.shift_selection(prompt_bufnr, -4)
          end,
        },
        select_scrolldown = {
          action = function(prompt_bufnr)
            return actions_set.shift_selection(prompt_bufnr, 4)
          end,
        },
      })



      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        Util.telescope("find_files", { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        Util.telescope("find_files", { hidden = true, default_text = line })()
      end
      local delete_buffer = function()
        local prompt_bufnr = vim.api.nvim_get_current_buf()
        local action_state = require("telescope.actions.state")
        local selection = action_state.get_selected_entry()
        print("delete_buffer "..selection.bufnr)
        actions.close(prompt_bufnr)
        vim.api.nvim_buf_delete(selection.bufnr, {force = 1})
        vim.cmd("Telescope buffers")
      end

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              ["<c-w>"] = actions.send_selected_to_qflist,
              ["<C-q>"] = actions.send_to_qflist,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-b>"] = actions.preview_scrolling_down,
              ["<C-f>"] = actions.preview_scrolling_up,
              ["<C-u>"] = myactions.select_scrollup,
              ["<C-d>"] = myactions.select_scrolldown,
              ["<C-a>"] = actions.select_all,
              ["<C-z>"] = delete_buffer,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
  },
  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    init = function()
      require("flash").toggle(true)
    end,
    opts = {
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "ww", mode = {"o", "n", "x"}, function ()
        local Flash = require("flash")

        ---@param opts Flash.Format
        local function format(opts)
          -- always show first and second label
          return {
            { opts.match.label1, "FlashMatch" },
            { opts.match.label2, "FlashLabel" },
          }
        end

        Flash.jump({
          search = { mode = "search" },
          label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
          pattern = [[\<]],
          action = function(match, state)
            state:hide()
            Flash.jump({
              search = { max_length = 0 },
              highlight = { matches = false },
              label = { format = format },
              matcher = function(win)
                -- limit matches to the current label
                return vim.tbl_filter(function(m)
                  return m.label == match.label and m.win == win
                end, state.results)
              end,
              labeler = function(matches)
                for _, m in ipairs(matches) do
                  m.label = m.label2 -- use the second label
                end
              end,
            })
          end,
          labeler = function(matches, state)
            local labels = state:labels()
            for m, match in ipairs(matches) do
              match.label1 = labels[math.floor((m - 1) / #labels) + 1]
              match.label2 = labels[(m - 1) % #labels + 1]
              match.label = match.label1
            end
          end,
        })
        end, desc = "jump any word"
      }
    },
  },
}
