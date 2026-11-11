return
{
  {
    'ojroques/nvim-osc52',
    opts = {
      max_length = 0,
      silent = false,
      trim = false,
      tmux_passthrough = true,
    },
    config = function(_, opts)
      require("osc52").setup(opts)

      vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
      vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
      vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

      -- 只有在 ssh 裡才用 OSC 52；本機交給 nvim 內建的 pbcopy/pbpaste
      if vim.env.SSH_CONNECTION then
        local function copy(lines, _)
          require('osc52').copy(table.concat(lines, '\n'))
        end
        local paste = require('vim.ui.clipboard.osc52').paste('+')
        vim.g.clipboard = {
          name = 'osc52',
          copy = {['+'] = copy, ['*'] = copy},
          paste = {['+'] = paste, ['*'] = paste},
        }
      end
    end,
  }
}

