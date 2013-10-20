filetype plugin on
syntax on
set smartindent
map Z :tabp<CR>
map X :tabn<CR>
set number
highlight Comment ctermfg=cyan
set ls=2
set hlsearch

set tabstop=4
set shiftwidth=4
set expandtab

"nmap <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
imap <c-d> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>
set backspace=indent,eol,start
