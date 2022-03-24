call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'

call plug#end()

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'colorscheme': 'nord',
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
    return &modifiable && &modified ? ':floppy_disk:' : ''
endfunction

" display relative file path rather than just name
" See https://github.com/itchyny/lightline.vim/issues/87#issuecomment-119130738
function! LightlineFilename()
    return expand('%')
endfunction

set number
syntax on


set laststatus=2
