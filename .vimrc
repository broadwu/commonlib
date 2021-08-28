"0. show line number
set nu

"1. enbale syntax highlight
syntax on

"2. Support to use mouse.
if has('mouse')
    set mouse-=a
endif

"3. When the enter key is pressed, the indentation of the next line will
" automatically follow the indentation of the next line.
set ai
set backspace=indent,eol,start

"4. Highlight the cursor as it moves forward.
set cursorline

"5. Replace tab with space.
set ts=4
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

"6. turn on matchit.Jump between opening and closing tags.
set nocompatible
filetype plugin on
runtime macros/matchit.vim
