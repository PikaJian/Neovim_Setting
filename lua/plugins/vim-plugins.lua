return
{
  { 'junegunn/fzf',                   event = "LazyFile",               build = "./install --bin" },
  { 'junegunn/fzf.vim',               dependencies = { 'junegunn/fzf' } },
  { 'junegunn/vim-easy-align',        event = "LazyFile" },
  { 'mg979/vim-visual-multi',         event = "LazyFile" },
  { 'vim-scripts/VisIncr',            event = "LazyFile" },
  { 'jiangmiao/auto-pairs' },
  { 'tpope/vim-surround',             event = "LazyFile" },
  --{'terryma/vim-expand-region'},
  { 'kshenoy/vim-signature',          event = "LazyFile" },
  { 'gregsexton/gitv',                event = "LazyFile" },
  { 'tpope/vim-fugitive' },
  { 'mhinz/vim-signify', },
  { 'christoomey/vim-tmux-navigator', event = "LazyFile" },
  { 'tpope/vim-dispatch',             event = "LazyFile" },
  { 'tpope/vim-repeat',               event = "LazyFile" },
  { 'kana/vim-operator-user',         event = "LazyFile" },
}
