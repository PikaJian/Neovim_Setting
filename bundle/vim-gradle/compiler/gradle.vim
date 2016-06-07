" Vim Compiler File
" Compiler: gradle

if exists("current_compiler")
    finish
endif
let current_compiler = "gradle"

if exists(":CompilerSet") != 2 " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=gradle

"CompilerSet errorformat=
"    \%E[ant:scalac]\ %f:%l:\ error:\ %m,
"    \%W[ant:scalac]\ %f:%l:\ warning:\ %m,
"    \%E%.%#:compile%\\w%#Java%f:%l:\ error:\ %m,%-Z%p^,%-C%.%#,
"    \%W%.%#:compile%\\w%#Java%f:%l:\ warning:\ %m,%-Z%p^,%-C%.%#,
"    \%E%f:%l:\ error:\ %m,%-Z%p^,%-C%.%#,
"    \%W%f:%l:\ warning:\ %m,%-Z%p^,%-C%.%#,
"    \%E%f:\ %\\d%\\+:\ %m\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
"    \%E%>%f:\ %\\d%\\+:\ %m,%C\ @\ line\ %l\\,\ column\ %c.,%-C%.%#,%Z%p^,
"    \%-G%.%#


CompilerSet errorformat=
        \%-G%f:%s:,
        \:compile%*[A-Za-z0-9]C%f:%l:\ %trror:\ %m,
        \:compile%*[A-Za-z0-9]C%f:%l:\ %tarning:\ %m,
        \%-G%f:%l:\ %#error:\ %#\(Each\ undeclared\ identifier\ is\ reported\ only%.%#,
        \%-G%f:%l:\ %#error:\ %#for\ each\ function\ it\ appears%.%#,
        \%-GIn\ file\ included%.%#,
        \%-G\ %#from\ %f:%l\\,,
        \%f:%l:%c:\ %trror:\ %m,
        \%f:%l:%c:\ %tarning:\ %m,
        \%f:%l:%c:\ %m,
        \%f:%l:\ %trror:\ %m,
        \%f:%l:\ %tarning:\ %m,
        \%f:%l:\ %m
