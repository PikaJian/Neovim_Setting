local Util = require("utils")

-- AutoClose - Inserts matching bracket, paren, brace or quote
-- fixed the arrow key problems caused by AutoClose
if not vim.fn.has("gui_running") then
  -- Set terminal to linux
  vim.cmd('set term=linux')

  -- Insert mode mappings for arrow keys in terminal
  vim.api.nvim_set_keymap('i', '<Esc>OA', '<ESC>ki', { noremap = true })
  vim.api.nvim_set_keymap('i', '<Esc>OB', '<ESC>ji', { noremap = true })
  vim.api.nvim_set_keymap('i', '<Esc>OC', '<ESC>li', { noremap = true })
  vim.api.nvim_set_keymap('i', '<Esc>OD', '<ESC>hi', { noremap = true })

  -- Normal mode mappings for arrow keys in terminal
  vim.api.nvim_set_keymap('n', '<Esc>OA', 'k', { noremap = true })
  vim.api.nvim_set_keymap('n', '<Esc>OB', 'j', { noremap = true })
  vim.api.nvim_set_keymap('n', '<Esc>OC', 'l', { noremap = true })
  vim.api.nvim_set_keymap('n', '<Esc>OD', 'h', { noremap = true })

  -- Map <Esc>[B to <Down> for tmux wired character
  vim.api.nvim_set_keymap('', '<Esc>[B', '<Down>', { noremap = true })
end

--This make fzf esc abnormal FixedMe
--vim.keymap.set('t', '<esc>', '<c-\\><c-n>', {noremap = true})

vim.keymap.set('v', '~',
  function()
    vim.fn.setreg('', require("utils").misc.twiddle_case(vim.fn.getreg('"')), vim.fn.getregtype(''))
    vim.api.nvim_feedkeys('<CR>gv""Pgv', 'n', false)
  end
  , { noremap = true, silent = true }
)

vim.keymap.set('n', '<leader>p', function()
  vim.o.paste = not vim.o.paste
  vim.cmd [[set paste?]]
end, { silent = true })

-- spell select
vim.keymap.set('n', '<C-C>', 'z=', { silent = true })


-- map esc key
vim.keymap.set('i', 'jk', '<ESC>', { remap = false })
vim.keymap.set('v', 'jk', '<ESC>', { remap = false })

-- movement in insert mode
vim.keymap.set('i', '<C-w>', '<S-RIGHT>', { remap = false })
vim.keymap.set('i', '<C-b>', '<S-LEFT>', { remap = false })

-- open the error console

vim.keymap.set('', '<leader>co', '<Cmd>botright cope<CR>', {})
vim.keymap.set('', '<leader>cx', '<Cmd>cclose<CR>', {})

-- move to next error
vim.keymap.set('', ']e', '<Cmd>cn<CR>', {})
-- move to the prev error
vim.keymap.set('', '[e', '<Cmd>cp<CR>', {})

-- --- move around splits {
-- decrease window
vim.keymap.set('', '<leader><leader>l', '<C-W><', {})
-- increase window
vim.keymap.set('', '<leader><leader>h', '<C-W>>', {})
-- decrease window
vim.keymap.set('', '<leader><leader>j', '<C-W>-', {})
-- increase window
vim.keymap.set('', '<leader><leader>k', '<C-W>+', {})
-- move to and maximize the below split
-- vim.keymap.set('', '<C-j>', '<C-w>j<C-w>_', {})
-- move to and maximize the above split
-- vim.keymap.set('', '<C-k>', '<C-w>k<C-w>_', {})
-- move to and maximize the left split
-- vim.keymap.set('', '<C-h>', '<C-w>h<C-w>|', {})
-- move to and maximize the right split
-- vim.keymap.set('', '<C-l>', '<C-w>l<C-w>|', {})


-- move around tabs. conflict with the original screen top/bottom
-- comment them out if you want the original H/L
-- go to prev tab
--map <S-H> gT
-- go to next tab
--map <S-L> gt

-- new tab
vim.keymap.set('', '<C-t><C-t>', '<Cmd>tabnew<CR>', { silent = true })

-- close tab
vim.keymap.set('', '<C-t><C-w>', '<Cmd>tabclose<CR>', { silent = true })

-- ,/ turn off search highlighting
vim.keymap.set('', '<leader>/', '<Cmd>nohl<CR>', { silent = true })

-- Bash like keys for the command line
vim.keymap.set('c', '<C-A>', '<Home>', { noremap = true })
vim.keymap.set('c', '<C-E>', '<End>', { noremap = true })
--vim.keymap.set('c', 'C-K', '<C-U>', {noremap = true})
vim.keymap.set('c', '<C-k>', '<Up>', { noremap = true })
vim.keymap.set('c', '<C-j>', '<Down>', { noremap = true })
vim.keymap.set('c', '<C-h>', '<Left>', { noremap = true })
vim.keymap.set('c', '<C-l>', '<Right>', { noremap = true })


-- allow multiple indentation/deindentation in visual mode
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

-- :cd. change working directory to that of the current file
vim.keymap.set('c', 'cd.', 'lcd %:p:h', {})

-- formatting
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  Util.format({ force = true })
end, { desc = "Format" })

vim.keymap.set({ "n", "v" }, "<leader>lf",
  '<esc><Cmd>lua require("utils").misc.format_code("LLVM")<CR>'
  , { desc = "Format" })
