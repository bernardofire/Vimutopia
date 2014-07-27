" ================
" Plugins included
" ================
" Vundle
"   Better Management of VIM plugins
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
""" Vundle plugins:
"" General
Bundle 'gmarik/vundle'
Bundle 'ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'xolox/vim-session'
Bundle 'mileszs/ack.vim'
Bundle 'Lokaltog/vim-powerline'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'FuzzyFinder'
Bundle 'L9'
Bundle 'TaskList.vim'
Bundle 'Syntastic'
Bundle 'tomtom/tlib_vim'
Bundle 'snipmate-snippets'
Bundle 'garbas/vim-snipmate'
Bundle 'matchindent.vim'
Bundle 'vim-misc'
"" Ruby
Bundle 'tpope/vim-rails.git'
Bundle 'skalnik/vim-vroom'
"" Javascript
Bundle 'pangloss/vim-javascript'
Bundle 'jslint.vim'
"To use jsbeautify: <leader> ff
Bundle 'jsbeautify'
" CoffeeScript
Bundle 'kchmck/vim-coffee-script'
Bundle 'coffee.vim'
" Python
Bundle 'pythonhelper'
Bundle 'pyflakes.vim'

"" Plugins Configs
let g:session_autosave = 'no'
"Vundle
let g:vundle_default_git_proto = 'git'
"NERDTree-tabs
"autocmd vimenter * NERDTreeTabsToggle "Opens NERDTree-tabs when vim starts
autocmd vimenter * wincmd l "Focus on file instead focus NERDTree
map <F3> <plug>NERDTreeTabsToggle<CR>
"Ack.vim
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

" ========
" Settings
" ========

" This must be first, because it changes other options as side effect
set nocompatible

" Set colorscheme
"colorscheme ir_black
colorscheme mango

" Setting VIMHOME
let $VIMHOME = $HOME."/.vim"

syntax on                   " syntax highlighting
filetype off                 " try to detect filetypes
filetype plugin indent on   " enable loading indent file for filetype
set number                  " show line numbers
set background=dark
set encoding=utf-8
set fileformat=unix
set wildmenu
set wildmode=list:longest
set title
set nobackup                " don't make backup

" Show markup characters
set list
set listchars=eol:¬,trail:▸,tab:\ \

" Moving/Editing configs
set backspace=2
set mouse=a             " allow us to use mouse
set cursorline          " line indicating the cursor location
set ruler               " show cursor location all the time
set linebreak           " don't wrap text in the middle of a word
set expandtab           " use spaces, not tabs
set ignorecase
set showbreak=...       " put ... in wrapped lines
set smartindent
set shiftround
set smartcase
set smarttab
set shiftwidth=2
set softtabstop=2
set showtabline=2
set tabstop=2
set autoindent         " always set autoindent
set matchpairs+=<:>    " show matching <>
set pastetoggle=<F2>   " to paste from clipboard, with the original ident

" Search and Patterns
set ignorecase         " use case insensitive in searches
set smarttab           " handle tabs more intelligently
set hlsearch           " highlight searches by default
set incsearch          " dynamic search

" Messages, Status, Infos
set laststatus=2       " always show statusline
set showcmd            " show incomplete normal commands as we type
set vb t_vb=           " disable all bells
set confirm            " Yes/No/Cancel prompt if closing with unsaved changes

"=============================
"=+++++++++ Mapping +++++++++=
"=============================

" Tabs navigation
" nmap <C-Tab> gt
" nmap <C-S-Tab> gT

" Don't use arrows, uncomment when you're ready!
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>

" Allow :wq upper case
cab W w
cab Q q
cab WQ wq
cab Wq wq

" Map tab creation and close (also for last tab) shortcuts
nmap <C-t> :tabnew<CR>
nmap <C-w> :q<CR>   " because <C-w>q will close it anyway
nmap <silent><A-Right> :tabnext<CR>
nmap <silent><A-Left> :tabprevious<CR>

" Speed up buffer switching
 map <C-k> <C-W>k
 map <C-j> <C-W>j
 map <C-h> <C-W>h
 map <C-l> <C-W>l

" Change statusbar color in insert mode
au InsertEnter * hi StatusLine term=bold cterm=bold
au InsertLeave * hi StatusLine term=bold,reverse cterm=bold,reverse

" Reload .vimrc file (F12)
map ,v :e $HOME/.vimrc <CR>
nmap <F12> : <C-u>source ~/.vimrc<CR>: echo "VIM's files reloaded"<CR>
imap <F12> <ESC>: <C-u>source ~/.vimrc<CR>a

if has ("autocmd")
  " Enable file type detection ('filetype on').
  filetype plugin indent on
  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  " Treat sh correctly
  autocmd FileType sh setlocal ts=4 sts=4 sw=4 expandtab
  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss,*.atom setfiletype xml
endif

" Hide search results <Shift> + F11
imap <S-F11> <ESC>:let @/=""<CR>a
nmap <S-F11> :let @/=""<CR>

" Tab configuration
map <leader>tn :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Remove trailling spaces
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
autocmd BufWritePre * :retab

" ToggleFold
function ToggleFold()
   if foldlevel('.') == 0
      " No fold exists at the current line,
      " so create a fold based on indentation

      let l_min = line('.')   " the current line number
      let l_max = line('$')   " the last line number
      let i_min = indent('.') " the indentation of the current line
      let l = l_min + 1

      " Search downward for the last line whose indentation > i_min
      while l <= l_max
         " if this line is not blank ...
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            if indent(l) <= i_min
               " we've gone too far
               let l = l - 1    " backtrack one line
               break
            endif
         endif
         let l = l + 1
      endwhile

      " Clamp l to the last line
      if l > l_max
         let l = l_max
      endif

      " Backtrack to the last non-blank line
      while l > l_min
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            break
         endif
         let l = l - 1
      endwhile

      "execute "normal i" . l_min . "," . l . " fold"   " print debug info

      if l > l_min
         " Create the fold from l_min to l
         execute l_min . "," . l . " fold"
      endif
   else
      " Delete the fold on the current line
      normal zd
   endif
endfunction

nmap <space> :call ToggleFold()<CR>
