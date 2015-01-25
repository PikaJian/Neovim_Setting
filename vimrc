

let g:pathogen_disabled = []
if !has('gui_running')
   call add(g:pathogen_disabled, 'powerline')
endif

execute pathogen#infect()
syntax on
filetype plugin indent on
" General Settings

set nocompatible	" not compatible with the old-fashion vi mode
set bs=2		" allow backspacing over everything in insert mode
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set autoread		" auto read when file is changed from outside


filetype off          " necessary to make ftdetect work on Linux
syntax on
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins


" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc


syntax on		" syntax highlight
set hlsearch		" search highlighting

if has("gui_running")	" GUI color and font settings
  set guifont=Osaka-Mono:h20
  set background=dark 
  set t_Co=256          " 256 color mode
  set cursorline        " highlight current line
  colors moria
  highlight CursorLine          guibg=#003853 ctermbg=24  gui=none cterm=none
else
" terminal color settings
   "colors vgod
  color vgod
endif

set clipboard=unnamed	" yank to the system register (*) by default
set showmatch		" Cursor shows matching ) and }
set showmode		" Show current mode
set wildchar=<TAB>	" start wild expansion in the command line using <TAB>
set wildmenu            " wild char completion menu

" ignore these files while expanding wild chars
set wildignore=*.o,*.class,*.pyc

set autoindent		" auto indentation
set incsearch		" incremental search
set nobackup		" no *~ backup files
set copyindent		" copy the previous indentation on autoindenting
set ignorecase		" ignore case when searching
set smartcase		" ignore case if search pattern is all lowercase,case-sensitive otherwise
set smarttab		" insert tabs on the start of a line according to context

" disable sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" TAB setting{
   set expandtab        "replace <TAB> with spaces
   set tabstop=8           " number of spaces a tab counts for
   set shiftwidth=2        " spaces for autoindents
   au FileType Makefile set noexpandtab
"}      							

" status line {
set laststatus=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L

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
autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

"--------------------------------------------------------------------------- 
" Tip #382: Search for <cword> and replace with input() in all open buffers 
"--------------------------------------------------------------------------- 
fun! Replace() 
    let s:word = input("Replace " . expand('<cword>') . " with:") 
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge' 
    :unlet! s:word 
endfun 


"--------------------------------------------------------------------------- 
" USEFUL SHORTCUTS
"--------------------------------------------------------------------------- 
" set leader to ,
let mapleader=","
let g:mapleader=","

"replace the current word in all opened buffers
map <leader>r :call Replace()<CR>

" open the error console
map <leader>cc :botright cope<CR> 
" move to next error
map <leader>] :cn<CR>
" move to the prev error
map <leader>[ :cp<CR>

" --- move around splits {
" move to and maximize the below split 
map <C-J> <C-W>j<C-W>_
" move to and maximize the above split 
map <C-K> <C-W>k<C-W>_
" move to and maximize the left split 
nmap <c-h> <c-w>h<c-w><bar>
" move to and maximize the right split  
nmap <c-l> <c-w>l<c-w><bar>
set wmw=0                     " set the min width of a window to 0 so we can maximize others 
set wmh=0                     " set the min height of a window to 0 so we can maximize others
" }

" move around tabs. conflict with the original screen top/bottom
" comment them out if you want the original H/L
" go to prev tab 
map <S-H> gT
" go to next tab
map <S-L> gt

" new tab
map <C-t><C-t> :tabnew<CR>
" close tab
map <C-t><C-w> :tabclose<CR> 

" ,/ turn off search highlighting
nmap <leader>/ :nohl<CR>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

" ,p toggles paste mode
nmap <leader>p :set paste!<BAR>set paste?<CR>

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" :cd. change working directory to that of the current file
cmap cd. lcd %:p:h

" Writing Restructured Text (Sphinx Documentation) {
   " Ctrl-u 1:    underline Parts w/ #'s
   noremap  <C-u>1 yyPVr#yyjp
   inoremap <C-u>1 <esc>yyPVr#yyjpA
   " Ctrl-u 2:    underline Chapters w/ *'s
   noremap  <C-u>2 yyPVr*yyjp
   inoremap <C-u>2 <esc>yyPVr*yyjpA
   " Ctrl-u 3:    underline Section Level 1 w/ ='s
   noremap  <C-u>3 yypVr=
   inoremap <C-u>3 <esc>yypVr=A
   " Ctrl-u 4:    underline Section Level 2 w/ -'s
   noremap  <C-u>4 yypVr-
   inoremap <C-u>4 <esc>yypVr-A
   " Ctrl-u 5:    underline Section Level 3 w/ ^'s
   noremap  <C-u>5 yypVr^
   inoremap <C-u>5 <esc>yypVr^A
"}

"--------------------------------------------------------------------------- 
" PROGRAMMING SHORTCUTS
"--------------------------------------------------------------------------- 

" Ctrl-[ jump out of the tag stack (undo Ctrl-])
map <C-[> <ESC>:po<CR>

" ,g generates the header guard
map <leader>g :call IncludeGuard()<CR>
fun! IncludeGuard()
   let basename = substitute(bufname(""), '.*/', '', '')
   let guard = '_' . substitute(toupper(basename), '\.', '_', "H")
   call append(0, "#ifndef " . guard)
   call append(1, "#define " . guard)
   call append( line("$"), "#endif // for #ifndef " . guard)
endfun



" Enable omni completion. (Ctrl-X Ctrl-O)
"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType c set omnifunc=ccomplete#Complete
"autocmd FileType java set omnifunc=javacomplete#Complete


set cot-=preview "disable doc preview in omnicomplete

" make CSS omnicompletion work for SASS and SCSS
autocmd BufNewFile,BufRead *.scss             set ft=scss.css
autocmd BufNewFile,BufRead *.sass             set ft=sass.css

"--------------------------------------------------------------------------- 
" ENCODING SETTINGS
"--------------------------------------------------------------------------- 
set encoding=utf-8                                  
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

fun! ViewUTF8()
	set encoding=utf-8                                  
	set termencoding=big5
endfun

fun! UTF8()
	set encoding=utf-8                                  
	set termencoding=big5
	set fileencoding=utf-8
	set fileencodings=ucs-bom,big5,utf-8,latin1
endfun

fun! Big5()
	set encoding=big5
	set fileencoding=big5
endfun


"--------------------------------------------------------------------------- 
" PLUGIN SETTINGS
"--------------------------------------------------------------------------- 


" ------- vim-latex - many latex shortcuts and snippets {

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash
set grepprg=grep\ -nH\ $*
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

"}


" --- AutoClose - Inserts matching bracket, paren, brace or quote 
" fixed the arrow key problems caused by AutoClose
if !has("gui_running")	
   set term=linux
   imap OA <ESC>ki
   imap OB <ESC>ji
   imap OC <ESC>li
   imap OD <ESC>hi

   nmap OA k
   nmap OB j
   nmap OC l
   nmap OD h
endif


" ---yankring
"let g:yankring_replace_n_nkey = '<c-r>'

"ctrlp
let g:ctrlp_map = '<c-c>'
let g:ctrlp_cmd = 'CtrlP'
nnoremap <F10> :CtrlPBuffer<CR>
"vim-indent-guides
"let g:indent_guides_auto_colors = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
"let g:indent_guides_enable_on_vim_startup = 1 
let g:indent_guides_color_change_percent = 7
let g:indent_guides_guide_size            = 0
let g:indent_guides_start_level      = 2


" --- EasyMotion
let g:EasyMotion_leader_key = '\' " default is <Leader>w
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment
let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
 " " Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1"
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
" Gif config
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

omap  tt <Plug>(easymotion-bd-tl)
" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
"smartcase(lazy search)
"let g:EasyMotion_smartcase = 1

" --- TagBar
" toggle TagBar with F7
nnoremap <silent> <F7> :TagbarToggle<CR> 
" set focus to TagBar when opening it
"let g:tagbar_autofocus = 1
let g:tagbar_width=20
" --- PowerLine
" let g:Powerline_symbols = 'fancy' " require fontpatcher



" --- coffee-script
au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw! " recompile coffee scripts on write

" --- vim-gitgutter
let g:gitgutter_enabled = 1


"CPP Complete
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"


"youcompleteme
"YCM diagnostic
let g:ycm_register_as_syntastic_checker = 0 "default 1
let g:Show_diagnostics_ui = 0 "default 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 0 "default 1
"YCM others options
let g:ycm_key_invoke_completion = '<F8>'
"let g:ycm_key_list_select_completion=['<c-n>']
let g:ycm_key_list_select_completion = ['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=01
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_cache_omnifunc=0      
let g:ycm_seed_identifiers_with_syntax=1    
"nnoremap <leader>lo :lopen<CR> "open locationlist
"nnoremap <leader>lc :lclose<CR>        "close locationlist
inoremap <leader><leader> <C-x><C-o>
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 0
let g:ycm_collect_identifiers_from_tags_files = 1
"Check if the file is compilable
nnoremap <leader>y :YcmForceCompileAndDiagnostics
"Jump to Definition
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>jx :YcmCompleter GoToDefinition<CR>


" --- syntastic
let g:syntastic_error_symbol = '@'      "set error or warning signs
"let g:syntastic_warning_symbol = '*'
let g:syntastic_check_on_open=1
let g:syntastic_enable_highlighting = 1
"let g:syntastic_python_checker="flake8,pyflakes,pep8,pylint"
"let g:syntastic_python_checkers=['pyflakes']
"highlight SyntasticErrorSign guifg=white guibg=black

"let g:syntastic_cpp_include_dirs = ['/usr/include/']
"let g:syntastic_cpp_remove_include_errors = 1
"let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
"let g:syntastic_enable_balloons = 1     "whether to show balloons
"let g:syntastic_debug = 1
let g:syntastic_c_make_args = "-j4"
"let g:syntastic_c_make_options = '-j4'
let g:syntastic_c_check_header = 1
let syntastic_c_cflags = '-nostdinc -include /home/pikachu123/test_src/include/linux/autoconf.h -D__KERNEL__ -D__nds32__ -mabi=2 -D__OPTIMIZE__ -G0 -D__ARCH_WANT_SYS_WAITPID -Unds32 -DSTRICT_MM_TYPECHECKS '
let g:syntastic_c_checkers = ['make']
let g:syntastic_c_compiler = 'nds32le-linux-gcc'
let g:syntastic_c_include_dirs = [ 
            \ '/home/pikachu123/test_src/arch/nds32/include',
            \ '/home/pikachu123/Andestech/BSPv321/toolchains/nds32le-linux-glibc-v2/lib/gcc/nds32le-linux/4.4.4/include',
            \ '/home/pikachu123/test_src/arch/nds32/include']

"UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Vallor"ic/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-tab>"
"let g:UltiSnipsListSnippets="<c-s-tab>"
let g:UltiSnipsSnippetDirectories=["bundle/vim-snippets/UltiSnips"]




"Tabular
nmap <leader>bb :Tab /=<CR>
nmap <leader>bn :Tab /
"F9 to trigger clang-format
autocmd FileType c,cpp,objc noremap <F9> :ClangFormat<CR>
"auto-pairs
let g:AutoPairs = {'<' : '>' ,'(' : ')', '[' : ']', '{' : '}', "'" : "'", '"' : '"', '`' : '`'}
"fswitch
au BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = './,./include,../include'
au BufEnter *.c let b:fswitchdst = 'h,hh' | let b:fswitchlocs = './,./include,../include'
au BufEnter *.hh let b:fswitchdst = 'cc,cpp' | let b:fswitchlocs = '../,./'
au BufEnter *.h let b:fswitchdst = 'cpp,cc' | let b:fswitchlocs = './,../'

"nerdtree
let g:NERDTreeWinSize=20
"nerdtree tab
nnoremap <F6> :NERDTreeTabsToggle<CR>

"support markdown hightlight
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd


autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 1
autocmd BufReadPre *.js let b:javascript_lib_use_underscore = 1
autocmd BufReadPre *.js let b:javascript_lib_use_backbone = 1
autocmd BufReadPre *.js let b:javascript_lib_use_prelude = 0
autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 0


