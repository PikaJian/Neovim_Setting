local function ts_disable(lang, bufnr)
  if lang == "cmake" then
    return true
  end
  return vim.api.nvim_buf_line_count(bufnr) > 5000
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "+", desc = "Increment selection" },
      { "-", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSClang == "cpp" or onfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = {
        enable = true,
        disable = function(lang, bufnr)
          return ts_disable(lang, bufnr)
        end,

      },
      indent = {
        enable = true,
        disable = function(lang, bufnr)
          return ts_disable(lang, bufnr)
        end,
      },
      ensure_installed = {
        "c",
        "cpp",
        "bash",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml"
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "+",
          node_incremental = "+",
          scope_incremental = false,
          node_decremental = "-",
        },
      },
      --[[ textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      } ]]--,
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter").setup(opts)
    end,
  },
  --[[
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    enabled = true,
    opts = { mode = "cursor" },
    keys = {
      {
        "<leader>ut",
        function()
          local Util = require("utils")
          local tsc = require("treesitter-context")
          tsc.toggle()
          if Util.inject.get_upvalue(tsc.toggle, "enabled") then
            Util.info("Enabled Treesitter Context", { title = "Option" })
          else
            Util.warn("Disabled Treesitter Context", { title = "Option" })
          end
        end,
        desc = "Toggle Treesitter Context",
      },
      {
        "<C-t>",
        mode = "n",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        { silent = true }

      }
    },
  },
  ]]--

}
