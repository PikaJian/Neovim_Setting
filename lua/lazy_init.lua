vim.g.mapleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- for lazyload
require("utils.plugin").lazy_file()

require("lazy").setup("plugins", {
  dev = {
    path = "~/projects",
  },
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "-10" }, -- show the last 10 commits
    log = { "-8" },   -- show commits from the last 3 days
    timeout = 120,    -- kill processes that take more than 2 minutes
    url_format = "https://github.com/%s.git",
    -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
    -- then set the below to false. This should work, but is NOT supported and will
    -- increase downloads a lot.
    filter = false,
  },
  checker = { enabled = false }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

if require("utils").misc.GitVersion(2, 19, 0) == true then
  vim.g.git_old = 0
else
  vim.g.git_old = 1
end

require("lazy.view.commands").setup()

-- require("config.options")
-- require("config.commands")
-- require("config.autocmds")
-- require("config.keybindings")

require("config").init()
require("config").setup()

--[[ local function check_easymotion()
  local timer = vim.loop.new_timer()
  timer:start(500, 0, vim.schedule_wrap(function()
    -- vim.notify("check_easymotion")
    if vim.fn["EasyMotion#is_active"]() == 0 then
      vim.diagnostic.enable()
      vim.g.waiting_for_easy_motion = false
    else
      check_easymotion()
    end
  end))
end

-- workaround for easymotion let lsp weired.
vim.api.nvim_create_autocmd("User", {
    pattern = "EasyMotionPromptBegin",
    callback = function()
        vim.diagnostic.disable()
    end
})

vim.api.nvim_create_autocmd("User", {
  pattern = "EasyMotionPromptEnd",
  callback = function()
    if vim.g.waiting_for_easy_motion then return end
    vim.g.waiting_for_easy_motion = true
    check_easymotion()
  end
}) ]]

--require("plugins.flash")
--gitsigns require newer git version
--[[require("plugins.gitsigns")
if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.statuscolumn = [[%!v:lua.Status.statuscolumn()<]
end]]
