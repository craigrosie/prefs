" VUNDLE

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" add fzf to the runtime path
set rtp+=/usr/local/opt/fzf
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" https://github.com/scrooloose/nerdtree
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
"Plugin '/usr/local/opt/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'mileszs/ack.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" Enable file type based indentation
filetype plugin indent on    " required

" Enable file type detection
filetype on

" Enable syntax highlighting
syntax on

" Enable Tomorrow Night colourscheme
colorscheme Tomorrow-Night-Bright

" SETS

" Enable line numbers
set number

" Add coloured columns to indicate optimal line-width
set colorcolumn=80,100

" Increase history size
set history=1000

" Disable line wrapper
set nowrap

" Set tab to 4 spaces
set tabstop=4

" Set shiftwidth to 4 spaces to match tabstop
set shiftwidth=4

" Enable expandtab
set expandtab

" Enable autoindent
set autoindent

" Enable smartindent
set smartindent

" Enable highlighting of found search terms
set hlsearch

" Enable incremental search highlighting
set incsearch

" Highlight matching parenthesis
set showmatch

" Highlight current line
set cursorline

" Enable backspace in insert mode
set backspace=indent,eol,start

" Enable backups
set backup
set writebackup

" Set backup directory
set backupdir=~/.vim/backups

" Skip creating backups of files in sensitive directories
set backupskip=/tmp/*,/private/tmp/*

" Set swapfile directory
set directory=~/.vim/swaps

" Better searching
set ignorecase
set smartcase

" Enable larger preview window (e.g. for fugitive's Gstatus)
set previewheight=30

" Always show hidden files in NERDTree
let NERDTreeShowHidden=1

" Disable display of Bookmarks label and help text in NERDTree
let NERDTreeMinimalUI=1

" Highlight current cursor line in NERDTree
let NERDTreeHighlightCursorline=1

" Use ag for ack.vim
let g:ackprg = 'ag --vimgrep'

" MAPPINGS & ABBREVIATIONS

" Set leader key to space
let mapleader=" "

" Allow vim config reload without restart
map <leader>r :source ~/.vimrc<CR>

" Key combination for toggling NERDTree
map <C-n> :NERDTreeFocus<CR>

" Cancel a search with Esc
nnoremap <leader><space> :nohlsearch<CR>

" Don't jump to first result when searching with ack.vim
nnoremap <leader>a :Ack!<Space>

" Search for word under cursor with ack.vim
nmap <leader>f :Ack! <C-W> <CR>

" Open help in a vertical split
cabbrev h vert h

" Don't jump to first result when searching with ack.vim
cnoreabbrev Ack Ack!

" AUTOCMD

" Remove trailing whitespace on file save
autocmd BufWritePre * %s/\s\+$//e

" Make Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Allows cursor change in tmux mode (to vertical bar)
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Open NERDTree automatically if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
