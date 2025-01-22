function! MaxColumn()
    let max_col = 0
    for line in getline(1, '$')
        let max_col = max([max_col, strwidth(line)])
    endfor
    return max_col
endfunction

function! ModifiedFN()
    return &modified ? expand('%:f') : ''
endfunction

function! UnModifiedFN()
    return &modified ? '' : expand('%:f')
endfunction

function! CurrentMode()
    let l:mode = mode()
    return
                \ l:mode ==# 'n' ? 'N' :
                \ l:mode ==# 'i' ? 'I' :
                \ l:mode ==# 'c' ? 'C' :
                \ l:mode ==# 'R' ? 'R' :
                \ l:mode ==# 'v' ? 'V' :
                \ l:mode ==# 'V' ? 'VL' :
                \ l:mode ==# "\<C-v>" ? 'VB' :
                \ l:mode ==# 't' ? 'T' :
                \ 'UNKNOWN'
endfunction

set statusline=
set statusline+=%#ModeGroup#
set statusline+=\ %{CurrentMode()}
set statusline+=%#LeftGroup#
set statusline+=%{strlen(FugitiveHead())?'\ \ │\ ':''}
set statusline+=%{FugitiveHead()}
set statusline+=\ │\ %{strlen(&filetype)?&filetype:'none'}
set statusline+=\ │\ %{strlen(&fenc)?&fenc:'none'}\ │
set statusline+=%{&readonly?'\ RO\ │\ ':''}
set statusline+=%=

set statusline+=%#ModifiedGroup#
set statusline+=%{ModifiedFN()}
set statusline+=%#UnModifiedGroup#
set statusline+=%{UnModifiedFN()}
set statusline+=%=

set statusline+=%#RightGroup#
" set statusline+=\ %ls
set statusline+=│\ %l:%L
set statusline+=\ │\ %c:%{MaxColumn()}
set statusline+=\ │\ W:%{ale#statusline#Count(1).warning}
set statusline+=\ │\ E:%{ale#statusline#Count(1).error}


" ===================================================================
"                    SYNTAX AND APPEARANCE
" ===================================================================
syntax on " Enable syntax highlighting
set termguicolors
set background=dark
set number relativenumber " Show absolute and relative line numbers

" Highlighting customizations
set cursorline " Highlight the current line
highlight Normal ctermbg=NONE guibg=NONE guifg=#EAE0C8
highlight CursorLine ctermbg=NONE guibg=#1e1e1e
highlight Comment ctermbg=NONE guifg=#6C6874
highlight LineNr ctermfg=darkgrey guibg=NONE guifg=#6c6c6c 
highlight CursorLineNr ctermfg=yellow guibg=NONE guifg=#e0af68
highlight Todo ctermfg=yellow guifg=#ffbb00 gui=bold
"Statusline
highlight ModeGroup guibg=#1e1e1e gui=bold 
highlight LeftGroup guibg=#1e1e1e
highlight RightGroup guibg=#1e1e1e 
highlight ModifiedGroup guibg=#1e1e1e guifg=#BDB76B
highlight UnModifiedGroup guibg=#1e1e1e guifg=#85BB65

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
set viminfo="NONE"
set nobackup " Disable backup files
set noswapfile " Disable swap files
set encoding=utf-8 " Set default file encoding to UTF-8
set fileencodings=utf8,cp1251 " Recognize UTF-8 and CP1251 encodings
"set termencoding=utf-8 " Set terminal encoding to UTF-8


" ===================================================================
"                    MISCELLANEOUS SETTINGS
" ===================================================================
set belloff=all " Disable all bells
set backspace=indent,eol,start " Allow backspacing over everything
set nowrap " Disable line wrapping
" set linebreak " Break wrapped lines at word boundaries
set so=30 " Keep current line on the screens center

inoremap jj <ESC>

