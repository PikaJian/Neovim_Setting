vim.o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.o.hidden = true
vim.o.compatible = false
vim.opt.backspace = "indent,eol,start"
vim.o.history = 50
vim.o.ruler = true
vim.o.autoread = true
vim.o.number = true
vim.opt.listchars = { tab = "| " }
vim.opt_local.textwidth = 80

vim.o.viminfo = "'10,\"100,:20,%,n~/.nviminfo"
vim.opt.mouse = "a"

vim.g.python2_host_prog = "/usr/bin/python2"
vim.g.python3_host_prog = "/usr/bin/python3"

if vim.fn.has("mac") == 1 then
	vim.g.python3_host_prog = "/usr/local/bin/python3"
elseif vim.fn.has("unix") == 1 then
	vim.g.python3_host_prog = "/usr/bin/python3"
end

vim.g.python_host_skip_check = 1
vim.g.python3_host_skip_check = 1

-- ENCODING SETTINGS
-- set encoding=utf-8                                
vim.o.termencoding = "utf-8"
vim.o.fileencoding = "utf-8"
-- big5 must behide gbk encoding
vim.o.fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5" -- ucs-bom

if vim.fn.has("gui_running") then
    vim.cmd[[highlight CursorLine guibg=#003853 ctermbg=24  gui=none cterm=none]]
    vim.o.cursorline = true
    vim.o.autochdir = true
    -- set t_Co = 256
    vim.o.termguicolors = true
    vim.cmd([[colorscheme tokyonight-moon]])
    vim.o.hlsearch = true
    vim.guifont = "Hack Nerd Font:h20"
else
    vim.cmd[[highlight CursorLine guibg=#003853 ctermbg=24  gui=none cterm=none]]
    vim.o.cursorline = true
    -- terminal color settings
    vim.o.termguicolors = true
    vim.cmd([[colorscheme tokyonight-moon]])
    vim.o.hlsearch = true
    vim.guifont = "Hack Nerd Font:h20"
end

