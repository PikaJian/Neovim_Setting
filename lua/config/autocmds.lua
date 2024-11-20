local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end


-- C/C++ specific settings
-- autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30

--[[

vim.api.nvim_create_autocmd("FileType", {
  pattern = {"c", "cpp", "cc"},
  callback = function()
    -- 设置 cindent
    vim.opt.cindent = true
    -- 设置 comments 选项
    vim.opt.comments = "sr:/*,mb:*,el:*/,://"
    -- 设置 cinoptions
    vim.opt.cinoptions = ">s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30"
  end
})

]]


-- callback return true to remove autocmd
-- auto reload vimrc when editing it
--
vim.api.nvim_create_autocmd('BufWritePost', {
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*.scss' },
  callback = function ()
    vim.o.filetype = 'scss.css'
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*.sass' },
  callback = function ()
    vim.o.filetype = 'sass.css'
  end
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark_line = vim.fn.line("'\"")
    local last_line = vim.fn.line("$")
    if mark_line > 0 and mark_line <= last_line then
      -- 跳转到标记位置
      vim.cmd("normal '\"")
    else
      -- 跳转到文件末尾
      -- vim.cmd("normal $")
      vim.cmd("normal G")
    end
  end
})

-- Automatically open, but do not go to (if there are errors) the quickfix /
-- location list window, or close it when is has become empty.
--
-- Note: Must allow nesting of autocmds to enable any customizations for quickfix
-- buffers.
-- Note: Normally, :cwindow jumps to the quickfix window if the command opens it
-- (but not if it's already open). However, as part of the autocmd, this doesn't
-- seem to happen.



-- cwindow make bqf error
-- 对于不以 "l" 开头的快速修复命令后执行的操作
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*",
  nested = true,
  callback = function()
    vim.cmd("cwindow")
  end
})

-- 对于以 "l" 开头的快速修复命令后执行的操作
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "l*",
  nested = true,
  callback = function()
    vim.cmd("lwindow")
  end
})

if vim.fn.executable('tmux') == 1 then
  vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost", "BufNewFile"}, {
    pattern = "*",
    callback = function()
      -- 获取当前文件的目录名
      local dirname = vim.fn.expand("%:p:h")
      local tmux_cmd = "tmux rename-window " .. dirname
      -- print(tmux_cmd)
      -- 拼接并执行 tmux 命令
      vim.fn.system(tmux_cmd)
    end
  })
end
