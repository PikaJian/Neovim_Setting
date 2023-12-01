let s:editor_root=expand("~/.nvim")
"Restore cursor to file position in previous editing session
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

lua require("lazy_init")

if executable('clipboard-provider')
  let g:clipboard = {
          \ 'name': 'myClipboard',
          \     'copy': {
          \         '+': 'clipboard-provider copy',
          \         '*': 'clipboard-provider copy',
          \     },
          \     'paste': {
          \         '+': 'clipboard-provider paste',
          \         '*': 'clipboard-provider paste',
          \     },
          \ }
endif

" C/C++ specific settings
"autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.

"cwindow make bqf error

autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
"autocmd FileType c,cpp,cc set shellpipe=1>

"--------------------------------------------------------------------------- 
" Tip #382: Search for <cword> and replace with input() in all open buffers 
"--------------------------------------------------------------------------- 
fun! Replace() 
    let s:word = input("Replace " . expand('<cword>') . " with:") 
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge' 
    :unlet! s:word 
endfun 

"ctags for c files and header
command! -nargs=0 -bar Ctags call system('ctags `find . -type f -regex ".*\.[ch]?$"`')

" visual select paste not overwrite clipboard register
function! RestoreRegister()
  if &clipboard == 'unnamed'
    let @* = s:restore_reg
  elseif &clipboard == 'unnamedplus'
    let @+ = s:restore_reg
  elseif &clipboard == 'unnamed,unnamedplus'
    let @+ = s:restore_reg
    let @* = s:restore_reg
  else
    let @" = s:restore_reg
  endif
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

function! s:ReplSelect()
    echo "Register to paste over selection? (<cr> => default register: ".strtrans(@").")"
    let c = nr2char(getchar())
    let reg = c =~ '^[0-9a-z:.%#/*+~]$'
                \ ? '"'.c
                \ : ''
    return "\<C-G>".reg.s:Repl()
endfunction

" Mappings on <s-insert>, that'll also work in select mode!
"xnoremap <silent> <expr> <S-Insert> <sid>Repl()
"snoremap <silent> <expr> <S-Insert> <sid>ReplSelect()
vnoremap <silent> <expr> p <sid>Repl()

" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command! -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>

"replace the current word in all opened buffers
map <leader>rw :call Replace()<CR>

" }

" Writing Restructured Text (Sphinx Documentation) {
   " Ctrl-u 1:    underline Parts w/ #'s
   " noremap  <C-u>1 yyPVr#yyjp
   " inoremap <C-u>1 <esc>yyPVr#yyjpA
   " " Ctrl-u 2:    underline Chapters w/ *'s
   " noremap  <C-u>2 yyPVr*yyjp
   " inoremap <C-u>2 <esc>yyPVr*yyjpA
   " " Ctrl-u 3:    underline Section Level 1 w/ ='s
   " noremap  <C-u>3 yypVr=
   " inoremap <C-u>3 <esc>yypVr=A
   " " Ctrl-u 4:    underline Section Level 2 w/ -'s
   " noremap  <C-u>4 yypVr-
   " inoremap <C-u>4 <esc>yypVr-A
   " " Ctrl-u 5:    underline Section Level 3 w/ ^'s
   " noremap  <C-u>5 yypVr^
   " inoremap <C-u>5 <esc>yypVr^A
"}

" ---------------------------------------------------------------------------
" EasyMotion
" --------------------------------------------------------------------------- 
let g:EasyMotion_leader_key = '\' " default is <Leader>w
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment
let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
 " " Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1"
map <leader>l <Plug>(easymotion-lineforward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>h <Plug>(easymotion-linebackward)
" Gif config
"nmap <leader>s <Plug>(easymotion-s2)
"nmap <leader>t <Plug>(easymotion-t2)

"without incsearch
"map  / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)
"It has problem with noice.nvim
""noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())

map  ww <Plug>(easymotion-bd-w)
omap  tt <Plug>(easymotion-bd-tl)
" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  <leader>n <Plug>(easymotion-next)
map  <leader>N <Plug>(easymotion-prev)
"smartcase(lazy search)
let g:EasyMotion_smartcase = 1

"map ctrl-space to trigger autocomplete under terminal
if !has("gui_running")
    inoremap <C-@> <C-x><C-o>
else
    inoremap <C-Space> <C-x><C-o>
endif

"auto-pairs
"'<' : '>'
let g:AutoPairs = { '(' : ')', '[' : ']', '{' : '}', "'" : "'", '"' : '"', '`' : '`'}

"vim-visual-multi
" Map start key separately from next key
let g:VM_maps = {}
let g:VM_maps['Skip Region'] = '<C-x>'
let g:VM_maps['Find Under'] = '<leader>c'



"surround vim
"- key
let b:surround_105 = "(\r)"
map <leader>gs      gSi

"easy align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"buffer operation for tabline
nmap <leader>T :enew<cr>
nmap <silent> <leader>bd :bp <BAR> bd! #<cr>

"buffer map
" Move to the next buffer
nmap <silent> <S-l> :bnext<CR>
" Move to the previous buffer
nmap <silent> <S-h> :bprevious<CR>

"fugitive
autocmd User fugitive 
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=hide

"rename tmux tab window name to open filename 
"check tmux installed
if executable('tmux')
  autocmd BufReadPost,FileReadPost,BufNewFile * call system('tmux rename-window '.expand("%:h"))
endif

"tmux navigator
"let g:loaded_tmux_navigator = 1
"let g:tmux_navigator_no_mappings = 1

"FZF
"command! -bar -nargs=+ -complete=customlist,functions#GitBugComplete Gbug Git bug <q-args>
"command! -bar -nargs=+ -complete=customlist,functions#GitFeatureComplete Gfeature Git feature <q-args>
"command! -bar -nargs=+ -complete=customlist,functions#GitRefactorComplete Grefactor Git refactor <q-args>

" Augmenting Rg command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"   * Preview script requires Ruby
"   * Install Highlight or CodeRay to enable syntax highlighting
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* -complete=file Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.
  \   shellescape(<q-args>)[1:strlen(shellescape(<q-args>)) - 2],
  \   1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

