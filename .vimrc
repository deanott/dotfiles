set nocompatible              " required
filetype off                  " required
set encoding=utf-8

" - Avoid using standard Vim directory names like 'plugin'
"~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

Plug 'tmhedberg/SimpylFold'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'tpope/vim-fugitive'
Plug 'junegunn/vim-emoji'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-scripts/sudo.vim'
Plug 'LnL7/vim-nix'
Plug 'fatih/vim-go'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'dag/vim-fish'

" Initialize plugin system
call plug#end()

" Spell checking {{{
"set spell! spelllang=en_gb
" }}}
"
"Display Numbers
set number

:"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"Switch to nerdtree view
nnoremap <silent> <C-\> :NERDTreeToggle<CR>
" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za
"add doc string to folder preview
let g:SimpylFold_docstring_preview=1

set tabstop=4

"Fish syntax support
syntax enable
filetype plugin indent on

"Dat emoji support :cat2:
set completefunc=emoji#complete



"Monokai Colour Theme
let g:molokai_original = 1
"let g:rehash256 = 1 "Dark theme

"Transparent background	
"hi Normal guibg=NONE ctermbg=NONE

"Change to sudo
" sudo save {{{
	command W w sudo:%
	command Wq wq sudo:%
" }}}


"Js support

let g:javascript_plugin_jsdoc = 1

