set nocompatible
set ignorecase
set incsearch
set smartcase
set backspace=2

" Undo and backups {{{
" This enables backups and undo and creates an undo point after
" the end of every sentence.
set undofile
set undodir=~/.cache/vim/undo
set nobackup

inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p", 0700)
endif

"}}}

" vim-plug Config {{{

if !filereadable(expand("~/.vim/autoload/plug.vim"))
    !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.vim/plugged')

if has("python")
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    "Plug 'Valloric/YouCompleteMe'
    "Plug 'klen/python-mode'
    Plug 'davidhalter/jedi-vim'
endif

Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'ervandew/supertab'
Plug 'lepture/vim-jinja'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()
" }}}

" Look and Feel {{{
set showcmd
set laststatus=2

set number
set relativenumber

let base16colorspace=256
set background=dark
colorscheme base16-chalk

if has("syntax")
	syntax on
endif
"}}}

" Window mappings {{{
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
"}}}

" Leader mappings {{{
map <leader>t :NERDTree<CR>
map <leader>w :w !sudo tee % >/dev/null
"}}}

" Custom mappings {{{
nnoremap <S-Return> i<CR><Esc>
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

" Auto-commands {{{
autocmd BufWritePre * :%s/\s\+$//e
au BufNewFile,BufRead /tmp/mutt* :call MailInit()
au BufNewFile,BufRead *.markdown,*.md :call PandocInit()
au FileType python setlocal et ts=4 sw=4 sts=4 tw=72
" }}}

" vim: fdm=marker
