" ===================================================================
"                        PLUGINS SETUP
" ===================================================================
call plug#begin()

" --- Themes and Appearance ---
Plug 'olimorris/onedarkpro.nvim'
" Plug 'rafi/awesome-vim-colorschemes'

" --- Status Line and Airline ---
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' " Themes for vim-airline

" --- Linting and Code Analysis ---
Plug 'dense-analysis/ale' " Asynchronous Lint Engine (ALE)

" --- Git Integration ---
Plug 'tpope/vim-fugitive'

" --- Autocompletion ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" --- Clang Format Support ---
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user' " Recommended for vim-clang-format

call plug#end()


" ===================================================================
"                        AIRLINE CONFIGURATION
" ===================================================================
" | A | B |                   C                    X | Y | Z |  [...]

let g:airline_theme='onedark'

" Statusline sections setup
let g:airline_section_a = ''
let g:airline_section_c = '%t %{CustomModifiedFlag()}' " filename
let g:airline_section_x = ''
let g:airline_section_y = '%{strlen(&filetype) ?
            \ &filetype : "none"} %{strlen(&fenc) ? &fenc : "none"}'
" line:column | total lines : total columns
let g:airline_section_z = '%l:%c | %L:%{MaxColumn()}'

" Function to show modified flag
function! CustomModifiedFlag()
  return &modified ? '✗' : ''
endfunction

" Function to get max column number
function! MaxColumn()
    let max_col = 0
    for line in getline(1, '$')
        let max_col = max([max_col, strwidth(line)])
    endfor
    return max_col
endfunction

" Enable ALE integration with Airline
let g:airline#extensions#coc#enabled = 0
let g:airline#extensions#ale#enabled = 1
let g:ale_set_quickfix = 0
let g:airline#extensions#ale#warnings_format = '%l'
let g:airline#extensions#ale#errors_format = '%l'

" Git branch display in airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#branch#displayed_head_limit = 25

" Airline symbols
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.dirty=' ⚝'


" ===================================================================
"                          CLANG FORMAT
" ===================================================================
let g:clang_format#detect_style_file = 1 " Auto-detect .clang-format
let g:clang_format#auto_format = 1 " Auto-format on save
let g:clang_format#auto_format_on_insert_leave = 1


" ===================================================================
"                    SYNTAX AND APPEARANCE
" ===================================================================
syntax on " Enable syntax highlighting
set termguicolors
set background=dark
colorscheme onedark
set number relativenumber " Show absolute and relative line numbers

" Highlighting customizations
set cursorline " Highlight the current line
highlight Normal ctermbg=NONE guibg=#262626 guifg=#afafaf
highlight CursorLine ctermbg=gray guibg=#1e1e1e
highlight Comment ctermbg=NONE guifg=#5f5f5f
highlight LineNr ctermfg=darkgrey guibg=#262626 guifg=#6c6c6c
highlight CursorLineNr ctermfg=yellow guibg=#262625 guifg=#e0af68
highlight Todo ctermbg=yellow guifg=#ffbb00 gui=bold

set incsearch " Highlight search results as you type
set hlsearch " Highlight all search matches


" ===================================================================
"                      INDENTATION AND TABS
" ===================================================================
set expandtab " Use spaces instead of tabs
set tabstop=4 " Set tab width to 4 spaces
set shiftwidth=4 " Set indentation width to 4 spaces
set smartindent " Auto-indent new lines based on syntax


" ===================================================================
"                        FILES, ENCODINGS
" ===================================================================
set nobackup " Disable backup files
set noswapfile " Disable swap files
set encoding=utf-8 " Set default file encoding to UTF-8
set fileencodings=utf8,cp1251 " Recognize UTF-8 and CP1251 encodings
set termencoding=utf-8 " Set terminal encoding to UTF-8


" ===================================================================
"                    MISCELLANEOUS SETTINGS
" ===================================================================
set belloff=all " Disable all bells
set backspace=indent,eol,start " Allow backspacing over everything
set wrap " Enable line wrapping
set linebreak " Break wrapped lines at word boundaries


" ===================================================================
"                            MAPPINGS
" ===================================================================
" Key mappings for navigating Coc's completion menu
inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#confirm() : "\<TAB>"
inoremap <silent><expr> <CR>
            \ coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <C-j>
            \ coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k>
            \ coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"

" Save and quit with Ctrl+Q
nnoremap <C-q> :wqa<CR>
