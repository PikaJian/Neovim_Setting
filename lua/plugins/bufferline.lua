return
{
  {
    "akinsho/bufferline.nvim",
    dependencies = {'nvim-tree/nvim-web-devicons'},
    event = "VeryLazy",
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
          separator_style = "thin",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
              local diagnostics = require("utils.ui").icons.diagnostics
              local ret = (diag.error and diagnostics.Error .. diag.error .. " " or "")
                  .. (diag.warning and diagnostics.Warn .. diag.warning or "")
              return vim.trim(ret)
          end,
          --[[diagnostics_indicator = function(count, level, diagnostics_dict, context)
               local icon = level:match("error") and " " or " "
               return " " .. icon .. count
           end,]]
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
