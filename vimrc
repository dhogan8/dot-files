call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'fatih/vim-go'
Plug 'preservim/nerdcommenter'
Plug 'alvan/vim-closetag'
Plug 'chun-yang/auto-pairs'
Plug 'ap/vim-css-color'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'
  
call plug#end()

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'colorscheme': 'wombat',
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'modified': 'LightlineModified',
      \ }
      \ }

let g:lightline.active = {
      \   'right': [
      \     [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
      \     [ 'lineinfo' ],
      \     [ 'percent' ],
      \     [ 'fileformat', 'fileencoding', 'filetype']
      \   ]
      \ }

function! LightlineModified()
    return &modifiable && &modified ? '💾' : ''
endfunction

" display relative file path rather than just name
" See https://github.com/itchyny/lightline.vim/issues/87#issuecomment-119130738
function! LightlineFilename()
    return expand('%')
endfunction

nnoremap <C-n> :NERDTreeToggle<CR>

let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-go',
  \ 'coc-markdownlint',
  \ 'coc-perl',
  \ ]

set number
set re=0
syntax on
colorscheme nord
set updatetime=100

set smartindent
set tabstop=2
set expandtab
set shiftwidth=2
	
let g:mapleader = ","
nnoremap <leader>f : <C-u>FZF<CR>
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

let g:closetag_filenames = '*.html,*.jsx,*.tsx,*.js,*.pm,*.go'
let g:closetag_regions =  {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }

set laststatus=2
