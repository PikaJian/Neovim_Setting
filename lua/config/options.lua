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

-- folding settings
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
vim.o.foldenable = false
vim.foldlevel = 1

vim.o.updatetime = 4000
vim.o.clipboard = "unnamed,unnamedplus"
vim.o.showmatch = true
vim.o.showmode = true
-- set wildchar='<TAB>'
vim.o.wildchar = vim.fn.char2nr('	')
vim.o.wildmenu = true

vim.o.wildignore = "*.o,*.class,*.pyc"
vim.o.autoindent = true
vim.o.incsearch = true
vim.o.backup = false
vim.o.copyindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smarttab = true

vim.o.errorbells = true
vim.o.visualbell = true
vim.o.t_vb = ""
vim.o.tm = 500

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.wmw = 0
vim.o.wmh = 0
-- set cot-=preview
vim.o.cot = vim.o.cot:gsub("preview", "")


--disabe autoformat onSave 
vim.g.autoformat = false

if vim.fn.has("gui_running") == 1 then
  vim.cmd [[highlight CursorLine guibg=#003853 ctermbg=24  gui=none cterm=none]]
  vim.o.cursorline = true
  vim.o.autochdir = true
  -- set t_Co = 256
  vim.o.termguicolors = true
  vim.cmd([[colorscheme tokyonight-moon]])
  vim.o.hlsearch = true
  vim.guifont = "Hack Nerd Font:h20"
else
  vim.cmd [[highlight CursorLine guibg=#003853 ctermbg=24  gui=none cterm=none]]
  vim.o.cursorline = true
  vim.o.autochdir = false
  -- terminal color settings
  vim.o.termguicolors = true
  vim.cmd([[colorscheme tokyonight-moon]])
  vim.o.hlsearch = true
  vim.guifont = "Hack Nerd Font:h20"
end


-- set custom statusline, overwrite by lualine.
vim.o.laststatus = 2
local custom_statusline = function()
  return table.concat({
    "%{%v:lua.require(\"utils.misc\").HasPaste()%}",
    "%<%-15.25(%f%)%m%r%h %w  ",
    "   [%{&ff}/%Y]",
    "   %<%20.30(".. "%{hostname()}" .. ":%{%v:lua.require(\"utils.misc\").CurDir()%}%) ",
    "%=%-10.(%l,%c%V%) %p%%/%L"
    })
end
vim.o.statusline = custom_statusline()
vim.opt.fillchars:append({ stl = ' ', stlnc = "\\" })


local function change_fold()
  if vim.o.foldmethod == 'syntax' then
    vim.o.foldmethod = 'indent'
  else
    vim.o.foldmethod = 'syntax'
  end
  vim.cmd [[set foldmethod?]]
end

vim.keymap.set('n', 'fd', function() change_fold() end, { remap = false })
