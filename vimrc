if has('nvim')
    let s:editor_root=expand("~/.nvim")
    "Restore cursor to file position in previous editing session
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
else
    let s:editor_root=expand("~/.vim")
    "Restore cursor to file position in previous editing session
    set viminfo='10,\"100,:20,%,n~/.viminfo
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
endif

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

" status line {
set laststatus=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L
set fillchars+=stl:\ ,stlnc:\


function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction

"}


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

"--------------------------------------------------------------------------- 
" insert ; after )
"--------------------------------------------------------------------------- 
function! <SID>InsSemiColon() abort
    let l:line = line('.')
    let l:content = getline('.')
    let l:eol = ';'
    " If the line ends with a semicolon we simply insert one.
    if l:content[col('$') - 2] ==# ';'
        normal! a;
        normal! l
        startinsert
    else
        if search('(', 'bcn', l:line)
            let l:eol = search(')', 'cn', l:line) ?  ';' : ');'
        endif
        call setline(l:line, l:content . l:eol)
        startinsert!
    endif
endfunction

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

"Insert semicolon
"inoremap <silent> ; <Esc>:call <SID>InsSemiColon()<CR>

"replace the current word in all opened buffers
map <leader>rw :call Replace()<CR>

set wmw=0                     " set the min width of a window to 0 so we can maximize others 
set wmh=0                     " set the min height of a window to 0 so we can maximize others
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

"--------------------------------------------------------------------------- 
" PROGRAMMING SHORTCUTS
"--------------------------------------------------------------------------- 
"split line
nnoremap K i<CR><Esc>

" Ctrl-[ jump out of the tag stack (undo Ctrl-])
"map <C-[> <ESC>:po<CR>

set cot-=preview "disable doc preview in omnicomplete

" make CSS omnicompletion work for SASS and SCSS
autocmd BufNewFile,BufRead *.scss             set ft=scss.css
autocmd BufNewFile,BufRead *.sass             set ft=sass.css

"--------------------------------------------------------------------------- 
" PLUGIN SETTINGS
"--------------------------------------------------------------------------- 

" ---yankring
"nnoremap <Leader>yr :YRShow<Cr>
"for windows platorms, you must change yankring replace key <C-P> and <C-N>
"let g:yankring_replace_n_nkey = '<c-r>'

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

"clang-format for formating cpp code
" //格式化最新的commit，并直接在原文件上修改
" git diff -U0 HEAD^ | clang-format-diff.py -i -p1
nnoremap <leader>lf :call FormatCode("LLVM")<CR>
vnoremap <leader>lf :call FormatCode("LLVM")<CR>
vnoremap <leader>cf :call FormatCode("Chromium")<CR>
nnoremap <leader>cf :call FormatCode("Chromium")<CR>
nnoremap <leader>gf :call FormatCode("Google")<CR>
vnoremap <leader>gf :call FormatCode("Google")<CR>
"let g:autoformat_verbosemode = 1
let g:autoformat_autoindent = 1

func! FormatCode(style)
  let firstline=line(".")
  let lastline=line(".")
  " Visual mode
  if exists(a:firstline)
    firstline = a:firstline
    lastline = a:lastline
  endif
  let g:formatdef_clangformat = "'clang-format-3.8
                          \ --lines='.a:firstline.':'.a:lastline.'        
                          \ --assume-filename='.bufname('%').'            
                          \ -style=" . a:style . "'"
  let formatcommand = ":" . firstline . "," . lastline . "Autoformat"
  exec formatcommand
endfunc

"command -nargs=1 PikaFormatCode :call FormatCode(<f-args>)

"rename tmux tab window name to open filename 
"check tmux installed
if executable('tmux')
  autocmd BufReadPost,FileReadPost,BufNewFile * call system('tmux rename-window '.expand("%:h"))
endif

"tmux navigator
"let g:loaded_tmux_navigator = 1
"let g:tmux_navigator_no_mappings = 1

"command! -bar -nargs=+ -complete=customlist,functions#GitBugComplete Gbug Git bug <q-args>
"command! -bar -nargs=+ -complete=customlist,functions#GitFeatureComplete Gfeature Git feature <q-args>
"command! -bar -nargs=+ -complete=customlist,functions#GitRefactorComplete Grefactor Git refactor <q-args>

"FZF
autocmd FileType qf wincmd J
nnoremap <leader><Enter> :FZF<CR>

if has('nvim')
tnoremap jk <C-c>   
endif

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

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! FZFMru call fzf#run({
\ 'source':  reverse(s:all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x +s',
\ 'down':    '40%' })

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/|term:\\\\'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>w :FZFMru<CR>
nnoremap <silent> <leader>y :History<CR>
nnoremap <silent> <c-p> :Buffers<CR>
nnoremap <silent> <leader>l :BLine<CR>
"nnoremap <leader>t :Tags<CR>
nnoremap <silent> bt :BTags<CR>
nnoremap <silent> <leader>s :Rg <C-r><C-w><CR>
nnoremap <silent> bs :vimgrep <C-r><C-w> %<CR>

" Replace the default dictionary completion with fzf-based fuzzy completion
"inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
imap <c-x><c-b> <plug>(fzf-complete-buffer-line)

"--preview "bat --color always --style numbers {2..}"

function! FZFWithDevIcons()
    let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "cat {2..}"'

  function! s:files()
    let l:files = split(system('find -type f'), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let result = []
    for candidate in a:candidates
      let filename = fnamemodify(candidate, ':p:t')
      let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
      call add(result, printf("%s %s", icon, candidate))
    endfor

    return result
  endfunction

  function! s:edit_file(items)
    let items = a:items
    let i = 1
    let ln = len(items)
    while i < ln
      let item = items[i]
      let parts = split(item, ' ')
      let file_path = get(parts, 1, '')
      let items[i] = file_path
      let i += 1
    endwhile
    call s:Sink(items)
  endfunction

  let opts = fzf#wrap({})
  let opts.source = <sid>files()
  let s:Sink = opts['sink*']
  let opts['sink*'] = function('s:edit_file')
  let opts.options .= l:fzf_files_options
  call fzf#run(opts)

endfunction
