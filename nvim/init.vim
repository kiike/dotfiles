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
	Plug 'davidhalter/jedi-vim', {'for': 'python'}
endif

Plug 'benekastah/neomake'
Plug 'bling/vim-airline'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-grammarous'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdtree', {'on': 'NERDTree'}
Plug 'sudar/vim-arduino-syntax', {'for': 'arduino'}
Plug 'vim-pandoc/vim-pandoc', {'for': 'markdown'}
Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'markdown'}

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

" {{{ Remove trailing spaces function
function! Remove_Trailing_Space()
	normal :%s/\s\+$//e
endfunction
" }}}

" Arduino neomaker {{{
let g:neomake_arduino_avrgcc_maker = {
	\ 'exe': '/usr/share/arduino/hardware/tools/avr/bin/avr-g++',
	\ 'args': [
		\ '-mmcu=atmega328p',
		\ '-DF_CPU=16000000L',
		\ '-DARDUINO=165',
		\ '-DARDUINO_ARCH_AVR',
		\ '-ffunction-sections',
		\ '-fdata-sections',
		\ '-g',
		\ '-Os',
		\ '-I/usr/share/arduino/hardware/arduino/cores/arduino',
		\ '-I/usr/share/arduino/hardware/tools/avr/avr/include',
		\ '-I/usr/share/arduino/hardware/arduino/avr/variants/standard',
		\ '-include/usr/share/arduino/hardware/arduino/avr/cores/arduino/Arduino.h',
		\ '-fsyntax-only',
		\ '-Wextra',
		\ '-Wall',
		\ '-xc++',
	\ ],
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%f:%l:%c: %m,'.
            \ '%f:%l: %trror: %m,'.
            \ '%f:%l: %tarning: %m,'.
            \ '%f:%l: %m',
        \ }

let g:neomake_arduino_enabled_makers = ['avrgcc']

" }}}

" Auto-commands {{{
autocmd! BufWritePost * Neomake
autocmd! BufWritePost init.vim :so %

au BufNewFile,BufRead /tmp/mutt* :call MailInit()
au BufNewFile,BufRead *.markdown,*.md :call PandocInit()
au FileType python setlocal et ts=4 sw=4 sts=4 tw=72
au FileType lua setlocal et ts=4 sw=4 sts=4 tw=72
" }}}

" vim: fdm=marker
