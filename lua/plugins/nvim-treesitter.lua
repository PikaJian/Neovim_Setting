local function ts_disable(_, bufnr)
    return vim.api.nvim_buf_line_count(bufnr) > 5000
end

local opts = {
  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      return lang == "cmake" or ts_disable(lang, bufnr)
    end,
  },
  indent = { enable = true },
  ensure_installed = {
    "bash",
    "c",
    "diff",
    "jsdoc",
    "json",
    "jsonc",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "python",
    "vim",
    "vimdoc",
    "yaml",
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
  },
}

require'nvim-treesitter.configs'.setup(opts)
