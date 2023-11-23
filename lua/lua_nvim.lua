vim.g.mapleader = ","
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--[[
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = false

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
--]]

require("config.options")

require("plugins.toggleterm")
require("plugins.dressing")
require("plugins.noice")

--slow for big source file (line > 3000)
require("plugins.indentscope")
require("plugins.indent-blankline")

--slow for big file
require("plugins.nvim-treesitter")

require("plugins.dashboard-nvim")
require("plugins.lsp")
require("plugins.nvim-cmp")
require("plugins.lualine")
require("plugins.bufferline")
require("plugins.nvim-spectre")

--slow for big file, nvim-ts-context-commentstring
require("plugins.coding")

require("plugins.illuminate")
require("plugins.trouble")
require("plugins.neo-tree")
require("plugins.osc52")
require("plugins.luasnip")

require("config.commands")
require("config.autocmds")
require("config.keybindings")

vim.api.nvim_create_autocmd("User", {pattern = {"EasyMotionPromptBegin"},
    callback = function()
        vim.diagnostic.disable()
    end
})

local function check_easymotion()
  local timer = vim.loop.new_timer()
  timer:start(500, 0, vim.schedule_wrap(function()
    --vim.notify("check_easymotion")
    if vim.fn["EasyMotion#is_active"]() == 0 then
      vim.diagnostic.enable()
      vim.g.waiting_for_easy_motion = false
    else
      check_easymotion()
    end
  end))
end
vim.api.nvim_create_autocmd("User", {
  pattern = "EasyMotionPromptEnd",
  callback = function()
    if vim.g.waiting_for_easy_motion then return end
    vim.g.waiting_for_easy_motion = true
    check_easymotion()
  end
})

--require("plugins.flash")
--gitsigns require newer git version
--[[require("plugins.gitsigns")
if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.statuscolumn = [[%!v:lua.Status.statuscolumn()<]
end]]
