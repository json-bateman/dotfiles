" ----------------------------
" Variables
" ----------------------------
let mapleader = " "
let g:netrw_banner=0 "turns netrw banner off
let g:netrw_liststyle=2 "changes the way the explorer tree looks options 0,1,2,3,4

" set splitbelow "causes splits to happen below current window instead of above
set termguicolors "enables 24-bit RGB color in the TUI
set nohlsearch "turns off highlighting on search
set expandtab "insert mode puts in spaces when tabbing
set tabstop=4 "number of spaces a tab counts for
set softtabstop=4 "editing operations (like <BS>) are deleting 4 spaces
set shiftwidth=4 "number of spaces to use for each autoindent
set nowrap "makes it so text runs off the screen instead of wrapping
set number "sets number on side column
set relativenumber "makes line number relative to cursor position
set numberwidth=2 "number column char width
set scrolloff=10 "scroll (x) lines from top and bottom
set ignorecase  "can sEarch case ignoring caps
set cursorline "highlights current line

" Need this to enable syntax highlighting
syntax on 
syntax enable

set mouse=a "mouse in all modes
set formatoptions-=cro "comments don't continue when enter is pressed

set noswapfile "Living life on the edge

colorscheme slate

" ----------------------------
" Remaps
" ----------------------------
nnoremap <leader>E :e $MYVIMRC<CR>
nnoremap <leader>W <CMD>w\|so%<CR>

let mapleader = " "
nnoremap <s-tab> V<
" Normal Mode
nnoremap s <c-w>
nnoremap <leader>v :Vexplore<CR>
nnoremap <leader>s :Sexplore<CR>
nnoremap <leader>e :Explore<CR>
nnoremap <leader>D :bd<CR>
nnoremap <leader>d :bp \| sp \| bn \| bd<CR> " Keep splits, delete buffer
nnoremap <leader>bo :%bd\|e#\|bd#<CR>" Only keep current buffer
nnoremap gn :bn<CR>
nnoremap gp :bp<CR>

" If you have the + register
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>y "+p

" Visual Mode
vnoremap <leader>Y ygv<Esc>" Yank but keep cursor at current position

" Command Mode
cnoremap %% <C-R>=expand('%:h')<CR> 

" Terminal Mode
tnoremap qq <C-\><C-N>:q!<CR>
tnoremap <ESC> <C-\><C-N><CR>
