let s:editor_root=expand("~/.nvim")

lua require("lazy_init")

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
