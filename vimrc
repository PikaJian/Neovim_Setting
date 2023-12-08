let s:editor_root=expand("~/.nvim")
"Restore cursor to file position in previous editing session
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

lua require("lazy_init")

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
    "@= enter expression reg
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
"snoremap <silent> <expr> <leader>rs <sid>ReplSelect()
"vnoremap <silent> <expr> p <sid>Repl()

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

"vim-visual-multi
" Map start key separately from next key
let g:VM_maps = {}
let g:VM_maps['Skip Region'] = '<C-x>'
let g:VM_maps['Find Under'] = '<C-n>'

"surround vim
"- key
let b:surround_105 = "(\r)"
map <leader>gs      gSi

"easy align
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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
