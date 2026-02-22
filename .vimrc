"==============================================================================
" 1. General Settings
"==============================================================================
syntax on
set number
set mouse=ni
set splitright
set shiftwidth=4
set smarttab
set noswapfile
set hlsearch

"==============================================================================
" 2. Navigation & Search
"==============================================================================
nnoremap <C-d> 5j0
nnoremap <C-u> 5k0

set path+=**                              " Enable recursive file search
set wildmenu                              " Use :find <name> <Tab>, or :find *<part_name>* <Tab>

"==============================================================================
" 3. Cursor Config
"==============================================================================
" set nocursorline
" autocmd VimEnter,WinEnter,BufEnter * setlocal nocursorline
" autocmd FileType netrw setlocal nocursorline

" set cursorline
highlight CursorLine    cterm=none ctermbg=238
highlight CursorLineNr  cterm=none ctermfg=255 ctermbg=238

" Hide cursorline when entering Insert mode
" augroup CursorLineToggle
"   autocmd!
"   autocmd InsertEnter * setlocal nocursorline
"   autocmd InsertLeave * setlocal cursorline
" augroup END

" Cursor shape (nvim style)
set ttimeoutlen=25                        " Faster switching cursor shape
let &t_EI = "\<Esc>[2 q"                  " Normal mode -> block
let &t_SI = "\<Esc>[6 q"                  " Insert mode -> bar
let &t_SR = "\<Esc>[4 q"                  " Replace mode -> underline

"==============================================================================
" 4. Netrw Config (File Explorer)
"==============================================================================
let g:netrw_altv            = 1           " Use vertical split for alternate
let g:netrw_browse_split    = 0           " Open file in current window
let g:netrw_preview         = 1           " Enable preview window (p)
let g:netrw_fastbrowse      = 0           " Disable directory cache
let g:netrw_list_hide       = '\(^\|\s\s\)\zs\.\S\+' " Hide dotfiles (gh to toggle)
let g:netrw_keepdir         = 0           " Update CWD on cd
let g:netrw_localcopydircmd = 'cp -r'     " Recursive directory copy

highlight! link netrwMarkFile Search

" Store pwd upon exit (support cd on quit)
" Add this to ~/.bashrc:
"==============================================================================
" export VIM_LASTDIR_FILE="${HOME}/.vim_lastdir"
" vim() {
"     command vim "$@"
"     if [[ -f "$VIM_LASTDIR_FILE" ]]; then
"         local last_dir=$(cat "$VIM_LASTDIR_FILE")
"         if [[ -d "$last_dir" ]]; then
"             cd "$last_dir"
"         fi
"     fi
" }
"==============================================================================
if exists('$VIM_LASTDIR_FILE')
  augroup StoreLastDir
    autocmd!
    autocmd VimLeavePre * call writefile([getcwd()], $VIM_LASTDIR_FILE)
  augroup END
endif

" Map '-' to open Netrw (vim-vinegar style)
nnoremap - :call OpenNetrwHere()<CR>

function! OpenNetrwHere() abort
  " Go up one directory if already in Netrw
  if &filetype ==# 'netrw'
    execute 'Explore ..'
    return
  endif

  let l:dir  = expand('%:p:h')
  let l:file = expand('%:t')

  " Ask to save changes only if the buffer is modified
  if &modified
    let l:choice = confirm("Save changes?", "&yes\n&no\n&cancel")
    if l:choice == 1
      write
    elseif l:choice == 3
      return
    endif
    set nomodified
    redraw!
  endif

  " Delete current file buffer
  bdelete!

  " Open netrw in the directory of the closed file
  execute 'Explore ' . fnameescape(l:dir)

  " Move the cursor to the position of the previously opened file
  if l:file != ''
    let l:pattern = '\%(^\%(| \)*\|\s\+\)\zs'
          \ . escape(l:file, '\.^$*[]~')
          \ . '[/*|@=]\=\%($\|\s\+\)'
    call search(l:pattern, 'wc')
  endif
endfunction

" Disable delete in Netrw for safer browsing
augroup NetrwDisableDelete
  autocmd!
  autocmd FileType netrw nnoremap <buffer> D <Nop>
  autocmd FileType netrw nnoremap <buffer> <Del> <Nop>
augroup END