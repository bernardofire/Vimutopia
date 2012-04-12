" Vundle
"   Better Management of VIM plugins
set rtp+=./bundle/vundle/
call vundle#rc()

" Set colorscheme
colorscheme desert

" Setting VIMHOME
let $VIMHOME = $HOME."/.vim"

syntax on       " Syntax colored
filetype on     " Try to detect filetype
set number      " Put line numbers
set background=dark
set encoding=utf-8
set fileformat=unix
set wildmenu
set wildmode=list:longest
set title
set nobackup    " Don't make backup

" Moving/Editing configs
set mouse=a     " Use the mouse
set backspace=2 " Activate backspace to delete characters
set ruler       " Show cursos location all the time
set cursorline  " Line idicating the cursor location
set pastetoggle=<F3>    " Paste from clipboard, with original indentation. Press F2 and paste

" Show markup characters
set list
set listchars=eol:¬,trail:▸,tab:\ \

" Dynamic search
set incsearch
set hlsearch

" Allow :W and :Q
cab W w
cab Q q
cab Wq wq
cab WQ wq

" Change statusbar color in insert mode
au InsertEnter * hi StatusLine term=bold cterm=bold
au InsertLeave * hi StatusLine term=bold,reverse cterm=bold,reverse

" Reload .vimrc file (F12)
map ,v :e $HOME/.vimrc<CR>
nmap <F12> : <C-u>source ~/.vimrc<CR>: echo "VIM's files reloaded"<CR>
imap <F12> <ESC>: <C-u>source ~/.vimrc<CR>a

" Hide search results
imap <S-F11> <ESC>:let @/=""<CR>a
nmap <S-F11> :let @/=""<CR>

" Tab manager shortcuts
imap <C-t> <ESC> :tabnew
nnoremap <C-t>   :tabnew
map <leader>tn :tabnew<cr>¬
map <leader>te :tabedit¬
map <leader>tc :tabclose<cr>¬
map <leader>tm :tabmove¬

" Move between tabs
imap <C-Right> <ESC>:tabnext<CR>a
imap <C-Left> <ESC>:tabprevious<CR>a
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-Left>  :tabprevious<CR>

" NerdTree
nmap <F2> :NERDTreeToggle<CR>
imap <F2> <Esc>:NERDTreeToggle<CR>a

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

" change tabs for spaces when the file is saved
autocmd BufWritePre * :retab
