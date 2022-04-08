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
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'
Plug 'ryanpcmcquen/fix-vim-pasting' "Automatically set paste mode when inserting via insert mode
Plug 'bronson/vim-trailing-whitespace' " highlight trailing whitespace

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

" ########### Ale ###########

" statusline error display doesn't seem to work
let g:ale_set_quickfix = 1
let g:ale_open_list = 1

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
"\   'java': ['remove_trailing_lines', 'trim_whitespace', 'google_java_format'],
"\   'javascript': ['eslint','prettier_eslint', 'remove_trailing_lines'],
"\   'json': ['prettier'],
"\   'lua': ['luafmt', 'remove_trailing_lines', 'trim_whitespace'],
"\   'markdown': ['prettier'],
"\   'perl': ['perltidy'],
"\   'ruby': ['rubocop'],
"\   'rust': ['remove_trailing_newlines', 'rustfmt', 'trim_whitespace'],
"\   'sh': ['shfmt'],
"\   'typescript': ['prettier'],
"\   'toml': ['prettier'],
"\   'yaml': ['prettier'],
\}
" gometalinter currently not enabled
let g:ale_linters = {
\   'ansible' : ['ansible-lint'],
\   'go': ['gofmt', 'golangci-lint', 'gopls'],
\   'dockerfile': ['hadolint'],
\   'html': ['alex', 'fecs', 'htmlhint', 'stylelint', 'tidy',],
\   'javascript': ['eslint', 'tsserver'],
\   'markdown': ['markdownlint', 'write-good'],
\   'perl': ['syntax-check', 'perlcritic'],
\   'rust': ['cargo', 'rls'],
\   'sh': ['language_server','shell', 'shellcheck'],
\   'typescript': ['tslint', 'tsserver'],
\   'vim': ['vint'],
\   'yaml': ['yamllint'],
\}


let g:ale_type_map = {
\    'perlcritic': {'ES': 'WS', 'E': 'W'},
\}

let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-go',
  \ 'coc-markdownlint',
  "\ 'coc-perl',
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

"remove all trailing whitespace
:nnoremap <silent> - :FixWhitespace<CR>

let g:closetag_filenames = '*.html,*.jsx,*.tsx,*.js,*.pm,*.go'
let g:closetag_regions =  {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }

set laststatus=2

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

fun HideGutter()
    :GitGutterDisable
    :set nonumber
    :set nolist
endfun

fun! ShowGutter()
    :GitGutterEnable
    :set number
    ":set list
endfun

autocmd BufEnter .tidyallrc       :setlocal filetype=dosini
autocmd BufRead,BufNewFile *.html.ep  set filetype=html
autocmd BufRead,BufNewFile *.tsx set filetype=typescript

nnoremap <leader>sv :source $MYVIMRC<cr>
