" Basic settings
set nocompatible              " Use Vim defaults instead of Vi
syntax on                     " Enable syntax highlighting
filetype plugin indent on     " Enable filetype detection

" UI Configuration
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set showcmd                   " Show command in bottom bar
set cursorline                " Highlight current line
set wildmenu                  " Visual autocomplete for command menu
set showmatch                 " Highlight matching brackets
set ruler                     " Show cursor position

" Search settings
set incsearch                 " Search as characters are entered
set hlsearch                  " Highlight matches
set ignorecase                " Ignore case when searching
set smartcase                 " Override ignorecase if search contains uppercase

" Indentation
set tabstop=4                 " Number of visual spaces per TAB
set softtabstop=4             " Number of spaces in tab when editing
set shiftwidth=4              " Number of spaces for autoindent
set expandtab                 " Tabs are spaces
set autoindent                " Auto-indent new lines
set smartindent               " Smart indenting

" Performance
set lazyredraw                " Redraw only when needed

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Backups and undo
set nobackup                  " Don't create backup files
set noswapfile                " Don't create swap files
set undofile                  " Enable persistent undo
set undodir=~/.vim/undo       " Undo directory

" Create undo directory if it doesn't exist
if !isdirectory($HOME . "/.vim/undo")
    call mkdir($HOME . "/.vim/undo", "p")
endif

" Color scheme
set background=dark
colorscheme desert

" Key mappings
let mapleader = ","           " Leader key

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Move vertically by visual line
nnoremap j gj
nnoremap k gk

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
