-- " Augmenting Rg command using fzf#vim#with_preview function
-- "   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
-- "   * Preview script requires Ruby
-- "   * Install Highlight or CodeRay to enable syntax highlighting
--
-- command! -bang -nargs=* -complete=file Rg
--   \ call fzf#vim#grep(
--   \   'rg --column --line-number --no-heading --color=always '.
--   \   shellescape(<q-args>)[1:strlen(shellescape(<q-args>)) - 2],
--   \   1,
--   \   <bang>0 ? fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline', '--preview', 'bat --color=always --style=numbers --line-range=:500 {}']}, 'up:50%')
--   \           : fzf#vim#with_preview('right:50%:hidden', '?'),
--   \   <bang>0)


local function fzf_preview_select(bang)
  if not bang then
    -- FIXME: tricky solution setting options for fzf#vim#with_preview
    local preview_opts = {
      options = {
        '--info=inline', '--preview', 'bat --color=always --style=numbers --line-range=:500 {}'
      }
    }
    return vim.call('fzf#vim#with_preview', preview_opts, 'right:50%')
  else
    return vim.call('fzf#vim#with_preview', 'right:50%:hidden', '?')
  end
end

local function fzf_vim_grep(fargs, bang)
  local query = '""'
  local qargs = ''
  for _, v in pairs(fargs) do
    qargs = qargs .. " " .. v -- concatenate only value pairs
  end
  if qargs ~= nil then
    query = vim.fn.shellescape(qargs)
    query = string.sub(query, 2, string.len(query) - 1)
    -- print("query:" .. query)
  end

  local sh = 'rg --column --line-number --no-heading --color=always' .. query
  -- print("sh = " .. sh)
  vim.call('fzf#vim#grep', sh, 1, fzf_preview_select(bang), bang)
end


return
{
  { 'junegunn/fzf',                   event = "LazyFile",               build = "./install --bin" },
  { 'junegunn/fzf.vim',               dependencies = { 'junegunn/fzf' },
    init = function()
        vim.api.nvim_create_user_command('Rg', function(arg)
          fzf_vim_grep(arg.fargs, arg.bang)
        end, { complete = 'file', bang = true, nargs = '*' })
    end
  },
  { 'junegunn/vim-easy-align',        event = "LazyFile" },
  { 'mg979/vim-visual-multi',
    event = "LazyFile",
    init = function()
        vim.g.VM_maps = vim.g.VM_maps or {}
        vim.g.VM_maps['Skip Region'] = '<C-x>'
        vim.g.VM_maps['Increase']    = '+'
        vim.g.VM_maps['Decrease']    = '-'
    end
  },
  { 'vim-scripts/VisIncr',            event = "LazyFile" },
  { 'tpope/vim-surround',             event = "LazyFile" },
  --{'terryma/vim-expand-region'},
  { 'kshenoy/vim-signature',          event = "LazyFile" },
  { 'gregsexton/gitv',                event = "LazyFile" },
  { 'tpope/vim-fugitive' },
  { 'mhinz/vim-signify', },
  { 'christoomey/vim-tmux-navigator',
    event = "LazyFile",
    init = function()
      -- tmux navigator
      -- let g:loaded_tmux_navigator = 1
      -- let g:tmux_navigator_no_mappings = 1
    end
  },
  { 'tpope/vim-dispatch',             event = "LazyFile" },
  { 'tpope/vim-repeat',               event = "LazyFile" },
  { 'kana/vim-operator-user',         event = "LazyFile" },
}
