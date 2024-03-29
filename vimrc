" Dan's vimrc file

" set default python
let g:python3_host_prog = expand('~/.pyenv/versions/nvim-default-py310/bin/python')

" correct the tab sizes
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" delete trailing whitespace in only these files
:filetype on
autocmd FileType markdown,c,cpp,java,php,python,html,yaml,md autocmd BufWritePre <buffer> :%s/\s\+$//e

" apparently these commands just make things that much better
" set encoding=utf-8
" set scrolloff=3
" set autoindent
" set showmode
" set showcmd
" set hidden
" set wildmenu
" set wildmode=list:longest
set visualbell
set noerrorbells
" set nocursorline
" set ttyfast
" set ruler
" set backspace=indent,eol,start
" set laststatus=2
set number
" set undofile

" do something with the cursorline
" :hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" :hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" :nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" this helps with searching and replacing
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
"set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" and this handles long lines 
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

" show invisibles just like TextMate does
set list
set listchars=tab:▸\ ,eol:¬

" feel the pain
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" remove help key that is similar to escape key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" and remap the ; to :
nnoremap ; :

" easier buffer cycling / switching
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>

" let's just say that W is the same as w ...
command! W  write
command! Q  quit


" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

""" https://github.com/junegunn/vim-plug
""" then run (from vim) ':PlugInstall'
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')

Plug 'nanotech/jellybeans.vim', { 'tag': 'v1.6' } 
" Plug 'alaviss/nim.nvim'
" Plug 'hashivim/vim-terraform'

" Initialize plugin system
call plug#end()

colorscheme jellybeans

""" macro
" import IPython; IPython.embed()
nnoremap <silent> emb :let a='import IPython; IPython.embed(header='''')'\|put=a<cr>

""" buffers in nvim
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_nr_show = 1
