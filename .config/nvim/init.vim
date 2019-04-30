call plug#begin('~/.vim/plugged')

Plug 'lifepillar/vim-solarized8'
Plug 'neomake/neomake'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'neovim/node-host'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'alvan/vim-closetag', { 'for': 'html' }
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-rhubarb'
Plug 'scrooloose/nerdcommenter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'w0rp/ale'
Plug 'tpope/vim-fireplace'
Plug 'eraserhd/parinfer-rust', {'do':
        \  'cargo build --release'}

call plug#end()
 
" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Change cursor size on insert and normal
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Solarized theme using true color
if exists('$TMUX')
" Colors in tmux
  let &t_8f = "<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

set background=dark
colorscheme solarized8

" Commenting
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

" deoplete autocomplete
let g:deoplete#enable_at_startup = 1

" Linting with ale
let g:ale_fixers = {'javascript': ['eslint'], 'typescript': ['prettier']}
let g:ale_linters = {'javascript': ['eslint'], 'typescript': ['eslint']}
" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_completion_enabled = 1

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Key re-map
let mapleader=","
map <C-p> :Files<cr>
nmap <C-p> :Files<cr>
noremap <Leader>f :GitFiles<cr>
" this one lists buffers in fzf list
nmap ; :Buffers<CR>
" Easy most-recent-buffer switching
nnoremap <Tab> :b#<CR>
noremap <Leader>w <C-w><C-w>
set number
set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2
set expandtab
" Use system clipboard on copy
set clipboard+=unnamedplus
" terminal switch from insert to normal mode
:tnoremap <Esc> <C-\><C-n>

" run tests in js/ts
noremap <Leader>t :term npm t<cr>

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" spell check on
map <Leader>S <ESC>:setlocal spell spelllang=en_us<CR>
