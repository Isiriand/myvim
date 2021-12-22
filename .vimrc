syntax on
set encoding=utf-8 
set modeline
set expandtab
set tabstop=4
set shiftwidth=4
set exrc " .vimrc in local project dir
set secure
set mouse=a
autocmd BufRead,BufNewFile * set signcolumn=yes
autocmd FileType tagbar,nerdtree set signcolumn=no
set foldmethod=indent
set nofoldenable
set number relativenumber
set diffopt+=vertical
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
:augroup END

"-- PATHOGEN --
"execute pathogen#infect()
execute pathogen#infect('bundle/{}', '~/src/vim/bundle/{}')
"-- TRUE COLOR --
" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
" Based on Vim patch 7.4.1770 (`guicolors` option) - https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd
" https://github.com/neovim/neovim/wiki/Following-HEAD#20160511
if (has("termguicolors") && $TERM_PROGRAM ==# 'iTerm.app')
  set termguicolors
endif

"-- THEMING --
set cursorline
set background=dark

let g:material_theme_style = 'darker'
"colorscheme material
colorscheme DarkModeReloaded 
hi Normal       ctermbg=NONE guibg=NONE
hi SignColumn   ctermbg=235 guibg=#262626
hi LineNr       ctermfg=grey guifg=grey ctermbg=NONE guibg=NONE
hi CursorLineNr ctermbg=NONE guibg=NONE ctermfg=178 guifg=#d7af00

let g:gitgutter_set_sign_backgrounds = 0

"-- Whitespace highlight --
"match ExtraWhitespace /\s\+$/
"autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"autocmd BufWinLeave * call clearmatches()

"-- ALE --
hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '‚úò'
let g:ale_sign_warning = '‚óã'
hi Error    ctermfg=204 ctermbg=NONE guifg=#ff5f87 guibg=NONE
hi Warning  ctermfg=178 ctermbg=NONE guifg=#D7AF00 guibg=NONE
hi ALEError ctermfg=204 guifg=#ff5f87 ctermbg=52 guibg=#5f0000 cterm=undercurl gui=undercurl
hi link ALEErrorSign    Error
hi link ALEWarningSign  Warning

let g:ale_linters = {
            \ 'python': ['pylint'],
            \ 'javascript': ['eslint'],
            \ 'go': ['gobuild', 'gofmt'],
            \ 'rust': ['rls']
            \}
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'python': ['autopep8'],
            \ 'javascript': ['eslint'],
            \ 'go': ['gofmt', 'goimports'],
            \ 'rust': ['rustfmt']
            \}
let g:ale_fix_on_save = 1

"let g:ale_linters = {
"      \   'python': ['flake8', 'pylint'],
"      \   'ruby': ['standardrb', 'rubocop'],
"      \   'javascript': ['eslint'],
"      \}
"
"let g:ale_fixers = {
"      \    'python': ['yapf'],
"      \}
"nmap <F10> :ALEFix<CR>
"let g:ale_fix_on_save = 1
"
"function! LinterStatus() abort
"  let l:counts = ale#statusline#Count(bufnr(''))
"
"  let l:all_errors = l:counts.error + l:counts.style_error
"  let l:all_non_errors = l:counts.total - l:all_errors
"
"  return l:counts.total == 0 ? '✨ all good ✨' : printf(
"        \   '😞 %dW %dE',
"        \   all_non_errors,
"        \   all_errors
"        \)
"endfunction
"
"set statusline=
"set statusline+=%m
"set statusline+=\ %f
"set statusline+=%=
"set statusline+=\ %{LinterStatus()}

"let g:vimfiler_as_default_explorer = 1
"autocmd VimEnter * VimFiler

"-- NERDTree --
let NERDTreeShowHidden=1
let NERDTreeMouseMode=3
nnoremap <leader>n :NERDTreeFocus
nnoremap <C-n> :NERDTree
nnoremap <C-t> :NERDTreeToggle
nnoremap <C-f> :NERDTreeFind

" Start NERDTree and leave the cursor in it.
autocmd VimEnter * NERDTree

" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>

" change the default arrows
"let g:NERDTreeDirArrowExpandable = '?'
"let g:NERDTreeDirArrowCollapsible = '?'

"-- Airline --
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
"let g:airline_statusline_ontop=1
let g:airline_theme='oceanic'
"let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#gutentags#enabled = 1
" Dark
set background=dark
colorscheme vim-material

" Palenight
let g:material_style='palenight'
set background=dark
colorscheme vim-material

" Oceanic
let g:material_style='oceanic'
set background=dark
colorscheme vim-material

" Light
set background=light
colorscheme vim-material

"-- Exuberant Ctags --
set tags=tags

"-- NVIM configuration --
if has('nvim')
    " Enable deoplete when InsertEnter.
    let g:deoplete#enable_at_startup = 0
    autocmd InsertEnter * call deoplete#enable()

    set belloff=""
    call deoplete#custom#source('_',  'max_menu_width', 0)
    call deoplete#custom#source('_',  'max_abbr_width', 0)
    call deoplete#custom#source('_',  'max_kind_width', 0)

    set hidden
    let g:LanguageClient_serverCommands = {
        \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
        \ 'go': ['~/.go/bin/gopls']
        \ }
endif

" -- DevIcon --
" These are the basic settings to get the font to work (required):
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\ 12
let g:airline_powerline_fonts = 1
" loading the plugin
let g:webdevicons_enable = 1

" adding the flags to NERDTree
let g:webdevicons_enable_nerdtree = 1
