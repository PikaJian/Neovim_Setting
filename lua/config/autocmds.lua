local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end


-- callback return true to remove autocmd
-- auto reload vimrc when editing it
--
vim.api.nvim_create_autocmd('bufwritepost', {
  pattern = { '.vimrc' },
  callback = function()
    vim.api.nvim_command("source ~/.vimrc")
    return true
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'vim', 'lua' },
  callback = function()
    vim.opt_local.ts = 2
    vim.opt_local.sw = 2
    vim.opt_local.sts= 0
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' },
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'o' }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'sh', 'make'},
  callback = function()
    -- vim.api.nvim_set_hl(0, 'Pmenu', { ctermfg = 7, ctermbg = 236 })
    -- vim.api.nvim_set_hl(0, 'PmenuSel', { ctermfg = 'white', ctermbg = 32 })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'Makefile' },
  callback = function()
    vim.o.expandtab = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup("qf"),
  pattern = 'qf',
  callback = function ()
    vim.o.buflisted = false
  end
})
