scriptencoding utf-8
let g:ale_disable_lsp = 1

" Suppress error messages at startup to avoid 'Press ENTER' prompts
set shortmess+=F

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-slash' "Highlight search results
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'preservim/nerdcommenter'
Plug 'alvan/vim-closetag'
Plug 'chun-yang/auto-pairs'
Plug 'ap/vim-css-color'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'
Plug 'ryanpcmcquen/fix-vim-pasting' "Automatically set paste mode when inserting via insert mode
Plug 'bronson/vim-trailing-whitespace' "Highlight trailing whitespace
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/matchtag' "Highlights matching tags
Plug 'mxw/vim-jsx'
Plug 'ervandew/supertab' "Tab completion
Plug 'mustache/vim-mustache-handlebars' "Handlebars syntax highlighting
Plug 'bkad/CamelCaseMotion' "Tab camelcase words
Plug 'haya14busa/vim-auto-mkdir' " Makes directories

if has('nvim')
  Plug 'ellisonleao/glow.nvim'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'lvimuser/lsp-inlayhints.nvim'
  Plug 'onsails/lspkind.nvim'
  Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}  "We recommend updating the parsers on update
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'lukas-reineke/lsp-format.nvim'
  Plug 'akinsho/bufferline.nvim'
  Plug 'kyazdani42/nvim-web-devicons' "Recommended (for coloured icons for bufferline.nvim)
  Plug 'SmiteshP/nvim-navic'
  Plug 'SmiteshP/nvim-navbuddy'
  Plug 'MunifTanjim/nui.nvim'
  Plug 'folke/noice.nvim'
  Plug 'rcarriga/nvim-notify'
  Plug 'shellRaining/hlchunk.nvim' "Highlight indent
  Plug 'folke/trouble.nvim'
  "Plug 'zbirenbaum/copilot.lua'
  "Plug 'zbirenbaum/copilot-cmp'
  Plug 'kevinhwang91/promise-async' "Folding
  Plug 'kevinhwang91/nvim-ufo' "Folding
  Plug 'folke/which-key.nvim' " better organization of key mappings
  Plug 'Wansmer/treesj' " SplitJoin replacement
  Plug 'sindrets/diffview.nvim' " File explorer for git diffs
  Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
  Plug 'nvim-tree/nvim-web-devicons' "optional for icon support
endif

call plug#end()

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'colorscheme': 'wombat',
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'modified': 'LightlineModified',
      \ },
      \ 'enable': {
      \   'tabline': 0
      \ },
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

let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 0

let g:lightline#ale#indicator_checking = '👀'
let g:lightline#ale#indicator_errors = '🚨'
let g:lightline#ale#indicator_infos = 'ℹ️'
let g:lightline#ale#indicator_ok = '👍'
let g:lightline#ale#indicator_warnings = '🚫'

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_ok': 'lightline#ale#ok',
      \  'linter_warnings': 'lightline#ale#warnings',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }

let g:lightline.active = {
      \   'right': [
      \     [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
      \     [ 'lineinfo' ],
      \     [ 'percent' ],
      \     [ 'fileformat', 'fileencoding', 'filetype']
      \   ]
      \ }

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_fixers = {
  \   '*': ['remove_trailing_lines', 'trim_whitespace'],
  \   'go': ['gofumpt'],
  \   'gohtml': ['prettier'],
  \   'java': ['google_java_format'],
  \   'javascript': ['eslint', 'prettier_eslint'],
  \   'javascriptreact': ['eslint', 'prettier'],
  \   'json': ['prettier'],
  \   'lua': ['luafmt'],
  \   'markdown': ['prettier'],
  \   'perl': ['perltidy', 'perlimports'],
  \   'ruby': ['rubocop'],
  \   'rust': ['rustfmt'],
  \   'sh': ['shfmt'],
  \   'typescript': ['prettier'],
  \   'typescriptreact': ['eslint', 'prettier'],
  \   'toml': ['prettier'],
  \   'yaml': ['prettier'],
  \}

let g:ale_linters = {
  \   'ansible' : ['ansible-lint'],
  \   'go': ['gofmt', 'golangci-lint', 'gopls', 'revive'],
  \   'gohtml': ['prettier'],
  \   'dockerfile': ['hadolint'],
  \   'html': ['alex', 'fecs', 'htmlhint', 'stylelint', 'tidy',],
  \   'javascript': ['eslint', 'tsserver'],
  \   'markdown': ['markdownlint', 'write-good'],
  \   'perl': ['syntax-check', 'perlcritic', 'perlimports'],
  \   'rust': ['cargo', 'rls'],
  \   'sh': ['language_server','shell', 'shellcheck'],
  \   'typescript': ['tslint', 'tsserver'],
  \   'yaml': ['yamllint'],
  \}


let g:ale_type_map = {
  \    'perlcritic': {'ES': 'WS', 'E': 'W'},
  \}

let g:jsx_ext_required = 1

set number
set regexpengine=0
syntax on
colorscheme nord
set updatetime=100

set smartindent
set tabstop=2
set expandtab
set shiftwidth=2

let g:mapleader = ','
nnoremap <leader>f : <C-u>FZF<CR>
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" vim-mustache-handlebars
let g:mustache_abbreviations = 1

"remove all trailing whitespace
:nnoremap <silent> - :FixWhitespace<CR>

let g:closetag_filenames = '*.html,*.jsx,*.tsx,*.js,*.pm,*.go'
let g:closetag_regions =  {
  \ 'typescript.tsx': 'jsxRegion,tsxRegion',
  \ 'javascript.jsx': 'jsxRegion',
  \ }

set laststatus=2

fun HideGutter()
    :GitGutterDisable
    :set nonumber
    :set nolist
    :set scl=no " sign column
endfun

fun! ShowGutter()
    :GitGutterEnable
    :set number
    :set list
    :set scl=auto
endfun

" CamelCaseMotion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

" Prevent vim swap files from being included with important files
set directory="$HOME"/.vimtmp

augroup filetypes
  autocmd BufEnter .tidyallrc               :setlocal filetype=dosini
  autocmd BufRead,BufNewFile *.html.ep      set filetype=html
  autocmd BufRead,BufNewFile *.scss         set filetype=scss
  autocmd BufRead,BufNewFile bash_profile   set filetype=sh
  autocmd BufRead,BufNewFile *.tx           set filetype=html
  autocmd BufRead,BufNewFile *.gohtml      set filetype=html
augroup END

"dictionary sort unique
:vnoremap <silent> su :!sort -d --ignore-case<bar> uniq<CR>

nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap .. :nohlsearch<cr>

" Split management
nnoremap <leader>v         :vsplit<CR>
nnoremap <leader>s         :split<CR>
nnoremap <leader>w         <C-w>w
nnoremap <leader><leader>  <c-^>
nnoremap <leader>b         :Buffers<CR>

" Trouble
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
