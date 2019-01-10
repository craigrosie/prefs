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
Plugin 'docker/docker' , {'rtp': '/contrib/syntax/vim/'}
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-commentary'
Plugin 'w0rp/ale'
Plugin 'tpope/vim-surround'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'fatih/vim-go'
Plugin 'fatih/molokai'
Plugin 'SirVer/ultisnips'
Plugin 'Valloric/YouCompleteMe'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'janko-m/vim-test'
Plugin 'ambv/black'

"All of your Plugins must be added before the following line
call vundle#end()            " required
" Enable file type based indentation
filetype plugin indent on    " required

" Enable file type detection
filetype on

" Enable syntax highlighting
syntax on

" Enable modified molokai colourscheme
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

" VIM-TEST
let test#python#pytest#executable = 'python -m pytest -v --flake8 --cov=.'
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>

" COMMANDS

" Define Silent command to effectively run shell commands in the background
:command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

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

" Enable hidden buffers
set hidden

" Use vertical splits when running :Gdiff
set diffopt+=vertical

" Set ctags location
set tags=./tags,tags,./.git/tags;

" More intuitive splits
set splitright
set splitbelow

" keep x lines off the edges of the screen when scrolling vertically
set scrolloff=2
" keep x columns off the edges of the screen when scrolling horizontally
set sidescrolloff=2

" Fix bash here{doc,string} syntax highlighting
" https://stackoverflow.com/a/42640338
let g:is_bash=1

" Disable tmux navigator when zooming the vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" Always show hidden files in NERDTree
let NERDTreeShowHidden=1

" Disable display of Bookmarks label and help text in NERDTree
let NERDTreeMinimalUI=1

" Highlight current cursor line in NERDTree
let NERDTreeHighlightCursorline=1

" Hide certain files in NERDTree
let NERDTreeIgnore = [
    \'\.pyc$',
    \'\.vim$',
    \'\.git$',
    \'\.vscode$',
    \'__pycache__$',
    \'\.cache$',
    \'\.gitlab$',
    \'\.sonarlint',
    \'\.ipynb_checkpoints$',
    \'\.egg-info',
    \'\.ds_store',
    \'\.eggs',
    \]

" Use ag for ack.vim
let g:ackprg = 'ag --vimgrep --hidden'

" ALE customisation
let g:ale_sign_error='✘'
let g:ale_sign_warning='▲'
let g:ale_echo_msg_format = '%severity% %linter%: [%code%] %s'
let g:ale_echo_msg_error_str = '✘'
let g:ale_echo_msg_warning_str = '▲'
highlight ALEErrorSign ctermbg=None ctermfg=Red
highlight ALEWarningSign ctermbg=None ctermfg=Yellow

" Ultisnips
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetsDir="~/github/prefs/vim/ultisnips"
let g:UltiSnipsSnippetDirectories=["Ultisnips", "custom_snippets"]
let g:UltiSnipsExpandTrigger="<c-e>"

" vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
let g:go_metalinter_autosave = 1
let g:go_auto_type_info = 1

" YCM
let g:ycm_python_binary_path='python'
let g:ycm_max_num_candidates = 10

" Vim Markdown Preview (https://github.com/JamshedVesuna/vim-markdown-preview)
let vim_markdown_preview_hotkey='<leader>m'
let vim_markdown_preview_browser='Google Chrome'
let vim_markdown_preview_github=1

" ENDSETS

" MAPPINGS

" Set leader key to space
let mapleader=" "

" Allow vim config reload without restart
map <leader>sv :source ~/.vimrc<CR>

" Key combination for toggling NERDTree
map <C-n> :NERDTreeFocus<CR>

" Shortcut for regenerating ctags
map <leader>ct :Silent ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./.git/tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))") > /dev/null 2>&1<CR>

" Cancel a search with space
nnoremap <leader><space> :nohlsearch<CR>

" Don't jump to first result when searching with ack.vim
nnoremap <leader>a :Ack! -Q<Space>

" Search for word under cursor with ack.vim
nmap <leader>f :Ack! <C-W> <CR>

" Shortcut for searching files with fzf
nmap <leader>p :Files<CR>

" Shortcut for ctags (in the current buffer) with fzf
nmap <leader>r :BTags<CR>

" Shortcut for :Gstatus
nmap <leader>gs :Gstatus<CR>

" Shortcut for :Gdiff
nmap <leader>gd :Gdiff<CR>

" Shortcut for git push
nmap <leader>gp :Gpush<space>

" Shortcut for git push with --force-with-lease
nmap <leader>gpfl :Gpush --force-with-lease<space>

" Shortcut for refreshing current buffer
nmap <leader>e :e!<CR>

" Shortcut for running Black Python code formatter
nmap <leader>b :Black<CR>

" Vertical visual movement when lines are wrapped
nmap j gj
nmap k gk

" ENDMAPPINGS

"" ABBREV

" Open help in a vertical split
cabbrev h vert h

" Don't jump to first result when searching with ack.vim
cnoreabbrev Ack Ack!

" ENDABBREV

" AUTOCMD

" Remove trailing whitespace on file save
autocmd BufWritePre * %s/\s\+$//e

" Make Vim jump to the last position when reopening a file, except for commit
" messages. https://stackoverflow.com/a/16728794
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit"
    \| exe "normal! g'\"" | endif
endif

" Open NERDTree automatically if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Enable spellcheck in commit msg editor, markdown files, .txt files
autocmd BufRead COMMIT_EDITMSG setlocal spell spelllang=en_gb
autocmd BufRead *.aliases,*.extra,*.functions setlocal syntax=sh
autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown,*.txt setlocal spell spelllang=en_gb wrap linebreak nolist
autocmd BufNewFile,BufRead *.yaml,*.yml setlocal tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.cs setlocal tabstop=8 shiftwidth=8 noexpandtab autoindent
autocmd BufNewFile,BufRead *.bq setlocal syntax=sql
autocmd BufNewFile,BufRead *Dockerfile* setlocal syntax=dockerfile

" ENDAUTOCMD

" MISC

" Allows cursor change in tmux mode (to vertical bar)
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Enable red fg highlighting for spellcheck errors to work with cursorline
hi clear SpellBad
hi SpellBad ctermfg=red

" ENDMISC
