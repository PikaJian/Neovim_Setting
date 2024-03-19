return
{
  {
    'ojroques/nvim-osc52',
    opts = {
      max_length = 0,           -- Maximum length of selection (0 for no limit)
      silent = false,           -- Disable message on successful copy
      trim = false,             -- Trim surrounding whitespaces before copy
      tmux_passthrough = true, -- Use tmux passthrough (requires tmux: set -g allow-passthrough on)
    },
    config = function(_, opts)
      require("osc52").setup(opts)
      local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
      end

      local function paste()
        return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
      end

      vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
      vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
      vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

      vim.g.clipboard = {
        name = 'osc52',
        copy = {['+'] = copy, ['*'] = copy},
        paste = {['+'] = paste, ['*'] = paste},
      }
    end,
    --[[ keys = {
          { '<leader>oc', mode = "n", require('osc52').copy_operator, desc = "copy" },
          { '<leader>cc', mode = "n", '<leader>c_', desc = "copy line" },
          { '<leader>oc', mode = "v", require('osc52').copy_visual, desc = "copy visual" },
      } ]]
  }
}
