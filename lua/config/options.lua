vim.g.mapleader = ","

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
