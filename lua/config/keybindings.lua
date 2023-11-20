-- AutoClose - Inserts matching bracket, paren, brace or quote 
-- fixed the arrow key problems caused by AutoClose
if not vim.fn.has("gui_running") then
  -- Set terminal to linux
  vim.cmd('set term=linux')

  -- Insert mode mappings for arrow keys in terminal
  vim.api.nvim_set_keymap('i', '<Esc>OA', '<ESC>ki', {noremap = true})
  vim.api.nvim_set_keymap('i', '<Esc>OB', '<ESC>ji', {noremap = true})
  vim.api.nvim_set_keymap('i', '<Esc>OC', '<ESC>li', {noremap = true})
  vim.api.nvim_set_keymap('i', '<Esc>OD', '<ESC>hi', {noremap = true})

  -- Normal mode mappings for arrow keys in terminal
  vim.api.nvim_set_keymap('n', '<Esc>OA', 'k', {noremap = true})
  vim.api.nvim_set_keymap('n', '<Esc>OB', 'j', {noremap = true})
  vim.api.nvim_set_keymap('n', '<Esc>OC', 'l', {noremap = true})
  vim.api.nvim_set_keymap('n', '<Esc>OD', 'h', {noremap = true})

  -- Map <Esc>[B to <Down> for tmux wired character
  vim.api.nvim_set_keymap('', '<Esc>[B', '<Down>', {noremap = true})
end

vim.keymap.set('t', '<esc>', '<c-\\><c-n>', {noremap = true})

vim.keymap.set('v', '~',
    function ()
        vim.fn.setreg('', require("utils.misc").twiddle_case(vim.fn.getreg('"')), vim.fn.getregtype(''))
        vim.api.nvim_feedkeys('<CR>gv""Pgv', 'n', false)
    end
    ,{ noremap = true, silent = true }
)
