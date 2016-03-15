let s:old_cursor_position = []
let s:cursor_moved = 0
let s:moved_vertically_in_insert_mode = 0
let s:previous_num_chars_on_current_line = strlen(getline('.'))
let s:first_enter = 1
let s:plugin_trigger = 0
function! s:text_change()
  
  let num_chars_in_current_cursor_line = strlen( getline('.') )
  if s:moved_vertically_in_insert_mode
    let s:previous_num_chars_on_current_line = num_chars_in_current_cursor_line
    return 0
  endif
  let changed_text_on_current_line = num_chars_in_current_cursor_line !=
         \ s:previous_num_chars_on_current_line
  let s:previous_num_chars_on_current_line = num_chars_in_current_cursor_line
  return changed_text_on_current_line
endfunction

function! s:UpdateCursorMoved()
  let current_position = getpos('.')
  let s:cursor_moved = current_position != s:old_cursor_position

  let s:moved_vertically_in_insert_mode = s:old_cursor_position != [] &&
        \ current_position[ 1 ] != s:old_cursor_position[ 1 ]

  let s:old_cursor_position = current_position
endfunction

function! s:Aabbcc()
  call s:UpdateCursorMoved()
  if s:text_change()
    let line = getline(".")
    let i = 0
    while i < 150
      let i = i + 1
      call setline(line('.') + i, line) 
    endwhile
  endif
endfunction

function! s:Aabb()
  "if s:first_enter == 1
  "  call s:UpdateCursorMoved()
  "  call s:text_change()
  "  let s:first_enter = 0
  "  return 0
  "endif
  call s:UpdateCursorMoved()
  if s:text_change() 
    let line = getline(".")
    let i = 0
    while i < 150
      let i = i + 1
      call setline(line('.') + i, line) 
    endwhile
  endif
endfunction

function! s:Aab()
  augroup pika
    autocmd CursorMovedI * call s:Aabbcc()
    autocmd CursorMoved * call s:Aabb()
  augroup End
endfunction
imap <buffer> <silent> <expr> <F12> Double("\<F12>")
function! Double(mymap)
  try
    let char = getchar()
  catch /^Vim:Interrupt$/
    let char = "\<Esc>"
  endtry
  "exec BPBreakIf(char == 32, 1)
  if char == '^\d\+$' || type(char) == 0
    let char = nr2char(char)
  endif " It is the ascii code.
  if char == "\<Esc>"
    return ''
  endif
  redraw
  return char.a:mymap
  "return char."\<C-R>=Redraw()\<CR>".a:mymap
endfunction

function! Redraw()
  redraw
  return ''
endfunction

"imap <buffer> <silent> <expr> <F12> Test_Func()
"imap <buffer> <silent> <expr> <F11> Test()
let s:saved_keys = ""
function! Test()
  let c = nr2char(getchar())
  let char_type = type(c)
  "call feedkeys(c)
endfunction
"autocmd CursorMovedI * call Test()
command! -nargs=0 Fuckyou :call <SID>Aab()
