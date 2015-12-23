set ignorecase
set incsearch
set smartcase
set mouse=
set backspace=2

" vim-plug Config {{{

if !filereadable(expand("~/.config/nvim/autoload/plug.vim"))
    !curl --create-dirs -fLo ~/.config/nvim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.local/share/nvim/plugged')

if has("python")
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'davidhalter/jedi-vim'
endif

Plug 'sudar/vim-arduino-syntax'
Plug 'benekastah/neomake'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'
Plug 'lepture/vim-jinja'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'rhysd/vim-grammarous'

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'morhetz/gruvbox'

call plug#end()
" }}}

" Look and Feel {{{
set showcmd
set laststatus=2

set number
set relativenumber

set background=dark
colorscheme gruvbox

if has("syntax")
	syntax on
endif
"}}}

" Leader mappings {{{
map <leader>t :NERDTree<CR>
map <leader>w :w !sudo tee % >/dev/null
"}}}

" Custom mappings {{{
nnoremap <S-Return> i<CR><Esc>
"}}}

" Neovim Terminal emulation {{{
tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
"}}}

" Window navigation {{{
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
"}}}

" Toggle between relative, absolute, and no line numbers {{{
function! NumberToggle()
if(&relativenumber == 1)
	set norelativenumber
	set number
elseif(&number == 1)
	set nonumber
else
	set number
	set relativenumber
endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
"}}}

" UltiSnips Config {{{
let g:UltiSnipsSnippetDirectories=["UltiSnips","ultisnippets"]
"}}}

" File-type functions {{{
function! MailInit()
	set tw=72 ft=mail
	exe "normal O"
	exe "normal O"
	set spell
	start
endfunc

function! PandocInit()
	set tw=80 ts=4 sts=4 sw=4 et
	set ft=pandoc
	set spell
	autocmd BufWritePre,FileWritePre * :%s/\s\+$//e
endfun
" }}}

function! Remove_Trailing_Space()
	normal :%s/\s\+$//e
endfunction

" Auto-commands {{{
autocmd! BufWritePost * Neomake

au BufNewFile,BufRead /tmp/mutt* :call MailInit()
au BufNewFile,BufRead *.markdown,*.md :call PandocInit()
au FileType python setlocal et ts=4 sw=4 sts=4 tw=72
au FileType lua setlocal et ts=4 sw=4 sts=4 tw=72
" }}}

" vim: fdm=marker
