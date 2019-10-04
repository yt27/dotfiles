" Modeled after https://github.com/bling/dotvim

" detect OS {{{
  let s:is_windows = has('win32') || has('win64')
  let s:is_cygwin = has('win32unix')
  let s:is_macvim = has('gui_macvim')
"}}}

" functions {{{
  let s:cache_dir = '~/.vim/cache'

  function! s:get_cache_dir(suffix) "{{{
    return resolve(expand(s:cache_dir . '/' . a:suffix))
  endfunction "}}}

  function! Source(begin, end) "{{{
    let lines = getline(a:begin, a:end)
    for line in lines
      execute line
    endfor
  endfunction "}}}

  function! Preserve(command) "{{{
    " preparation: save last search, and cursor position.
    let _s = @/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/ = _s
    call cursor(l, c)
  endfunction "}}}

  function! StripTrailingWhitespace() "{{{
    call Preserve("%s/\\s\\+$//e")
  endfunction "}}}

  function! EnsureExists(path) "{{{
    if !isdirectory(expand(a:path))
      call mkdir(expand(a:path))
    endif
  endfunction "}}}

  function! CloseWindowOrKillBuffer() "{{{
    let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

    " never bdelete a nerd tree
    if matchstr(expand("%"), 'NERD') == 'NERD'
      wincmd c
      return
    endif

    if number_of_windows_to_this_buffer > 1
      wincmd c
    else
      bdelete
    endif
  endfunction "}}}

  function! MakeExecutable()
    silent !chmod u+x <afile>
  endfunction

  function! CountBuffers()
    return len(filter(range(1,bufnr('$')),'buflisted(v:val)'))
  endfunction

  " http://vim.wikia.com/wiki/Move_current_window_between_tabs
  function! MoveToPrevTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
      return
    endif
    "preparing new window
    let l:cur_buf = bufnr('%')
    if tabpagenr() > 1
      let l:is_last_tab = tabpagenr() == tabpagenr('$')
      let l:should_tabprev = l:is_last_tab == 0 || (l:is_last_tab == 1 && winnr('$') > 1)

      close!
      if l:should_tabprev
        tabprev
      endif
      sp
    else
      close!
      exe "0tabnew"
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
  endfunc

  function! MoveToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
      return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() < tab_nr
      let l:should_tabnext = winnr('$') > 1

      close!
      if l:should_tabnext
        tabnext
      endif
      sp
    else
      close!
      tabnew
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
  endfunc
"}}}

" init setup {{{
  set nocompatible
  set all& "reset everything to their defaults
  if s:is_windows
    set rtp+=~/.vim
  endif
"}}}

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" setup dein {{{
  let s:dein_dir = expand('~/.vim/dein')
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
  endif

  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    call dein#add(s:dein_repo_dir)
    if !has('nvim')
      call dein#add('roxma/nvim-yarp')
      call dein#add('roxma/vim-hug-neovim-rpc')
    endif

    let g:rc_dir    = expand('~/.config/nvim')
    let s:toml      = g:rc_dir . '/dein.toml'
    let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
  endif

  if dein#check_install()
    call dein#install()
  endif
"}}}

" finish loading {{{
  filetype plugin indent on
  syntax enable

  if !has('nvim')
    NeoBundleCheck
  endif
"}}}

" base configuration {{{
  " Force 256 colors if xterm is in use or builtin_gui (vimperator workaround)
  if &term == "xterm" || &term == "builtin_gui" || &term == "screen-256color"
     set t_Co=256
  endif

  set termguicolors

  " Allow backspacing over autoindent and over the start of insert
  set backspace=indent,eol,start

  " Remember marks for the last 20 files, contents of registers (up to 50 lines), registers with more than 100 KB text are
  " skipped, restore hlsearch and save them to ~/.viminfo
  " set viminfo='20,<50,s100,h,n~/.viminfo

  " Use enhanced command-line completion mode
  set wildmenu

  " When more than one match, list all matches and complete till longest common string
  set wildmode=list:longest,full

  " Ignore these file extensions
  set wildignore=*.o,*.obj,*.exe,*.class,*.pyc,*.pyo

  " Don't scan included files (default was .,w,b,u,t,i)
  set complete=.,w,b,u,t

  " configure tags - add additional tags here or comment out not-used ones
  set tags+=~/tags/cpp.ctags
  set tags+=~/tags/usr_inc.ctags

  " Sets how many lines of history VIM has to remember
  set history=2000

  " Maximum width of text that is being inserted. A longer line will wrap.
  set textwidth=78

  " Break at word endings
  set linebreak

  " Support all three fileformats, in this order
  set fileformats=unix,dos,mac

  " Ignore changes in amount of white spaces.
  " set diffopt+=iwhite

  " Allow backgrounding buffers without writing them.
  " set hidden

  " Report every change
  set report=0

  " Don't move the cursor to the start of line when scrolling
  set nostartofline

  " Highlight the screen line of the cursor
  " No cursorline as it's causing bad render perf on Mac's Terminal.app.
  set cursorline

  set cscopetag
  set cscopeprg=gtags-cscope

  " vim file/folder management {{{
    " persistent undo
    if exists('+undofile')
      set undofile
      let &undodir = s:get_cache_dir('undo')
    endif

    " backups
    set backup
    let &backupdir = s:get_cache_dir('backup')

    " swap files
    let &directory = s:get_cache_dir('swap')
    set noswapfile

    call EnsureExists(s:cache_dir)
    call EnsureExists(&undodir)
    call EnsureExists(&backupdir)
    call EnsureExists(&directory)
  "}}}

  if has('nvim')
    let g:terminal_scrollback_buffer_size  = 100000
  endif
"}}}

" indent {{{
  " Use spaces instead of tabs
  set expandtab

  " Number of spaces that a <Tab> counts for while performing editing operations
  set softtabstop=2

  " Number of spaces to use for each step of (auto)indent.
  set shiftwidth=2

  " Number of spaces that a <Tab> in the file counts for.
  set tabstop=2

  " Copy indent from current line when starting a new line
  set autoindent

  " Do smart autoindenting when starting a new line.
  set smartindent
"}}}

" ui {{{
  " Enable syntax highlighting
  syntax on
  set synmaxcol=200

  " Show the line and column number of the cursor position
  set ruler

  " Print the line number in front of each line.
  set number relativenumber

  " Always show the status line in the last window
  set laststatus=2

  " Show the mode in the status line
  set showmode

  " When a bracket is inserted, briefly jump to the matching one
  set showmatch

  " Tenths of a second to show the matching paren
  set matchtime=15

  " Show (partial) command in the last line of the screen.
  set showcmd

  " Minimal number of screen lines to keep above and below the cursor
  set scrolloff=5

  " Minimal number of columns to scroll horizontally.
  set sidescroll=1

  " Turn on folding
  set foldenable

  " fold according to syntax hl rules
  set foldmethod=syntax

  " Show invisible chars
  set list
  set listchars=tab:>~,trail:~,extends:>,precedes:<

  " Splitting a window will put the new window right of the current one.
  set splitright

  if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
  endif

  highlight Folded ctermbg=none ctermfg=darkmagenta
"}}}

" gui {{{
  if has("gui_running")
    " Remove toolbar
    set guioptions-=T
    " Remove menubar
    set guioptions-=m
    " Remove right-hand scrollbar
    set guioptions-=r
    " Remove left-hand scrollbar when there is a vertically split window
    set guioptions-=L
  endif
"}}}

" mouse {{{
  " Enable the use of mouse in all modes
  set mouse-=a

  if !has('nvim')
    " Name of the terminal type of which mouse codes are to be recognized.
    set ttymouse=xterm2
  endif
"}}}

" status line {{{
  " Clear statusline
  set statusline=

  " Append buffer number
  set statusline+=%-n

  " Append total number of buffers
  set statusline+=/%-3.3{CountBuffers()}

  " Append filename
  set statusline+=%F

  " Append filetype
  set statusline+=\ \[%{strlen(&ft)?&ft:'none'},

  " Append encoding
  set statusline+=%{&encoding},

  " Append fileformat
  set statusline+=%{&fileformat}]

  " Append help buffer ([help]), modified flag ([+]), readonly flag ([RO]), preview window flag ([Preview])
  set statusline+=\ %(%h%m%r%w%)

  " Append separation point between left and right aligned items and change color to black
  set statusline+=%=

  " Set git branch info
  " set statusline+=%(%{GitBranchInfoString()}\ %)

  " Append line number, column number, percentage
  set statusline+=%l:%c\ \(%p%%\)

  " Separator
  set statusline+=\ \|\ 

  " Append value of byte under cursor in hexadecimal
  set statusline+=char\ 0x%-2B
"}}}

" search {{{
  " While typing a search command, show where the pattern, as it was typed so far, matches
  set incsearch

  " When there is a previous search pattern, highlight all its matches
  set hlsearch

  " Ignore the case of normal letters
  set ignorecase

  " Don't override the 'ignorecase' option if the search pattern contains upper case characters
  "set nosmartcase
  set smartcase
"}}}

" search {{{
  " Don't ring the bell (beep or screen flash) for error messages.
  " set noerrorbells

  " Don't use visual bell instead of beeping.
  set novisualbell

  " Don't beep or flash
  set t_vb=
"}}}

" mapping {{{
  " smash escape
  inoremap jk <esc>
  inoremap kj <esc>

  map <leader>tn :tabnew .<cr>

  map <leader>wq :quit<cr>
  map <leader>ww :write<cr>
  map <leader>ws :split<cr>
  map <leader>wv :vsplit<cr>
  map <leader>wz :-tabnew %<cr>

  map <leader>qo :copen<cr>
  map <leader>qq :cclose<cr>

  map <leader>s :set spell!<cr>

  " Show invisible characters
  nmap <leader>l :set list!<cr>

  nmap <leader>nu :set number! relativenumber!<cr>

  nnoremap <C-w>. :call MoveToNextTab()<CR>
  nnoremap <C-w>, :call MoveToPrevTab()<CR>

  "This unsets the "last search pattern" register by hitting return
  nnoremap <CR> :noh<CR><CR>

  " Expand the directory of the current file anywhere at the command line by pressing %%
  " http://vimcasts.org/episodes/the-edit-command
  cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
"}}}

" autocommand {{{
  " Make sure autocommands are loaded only once
  if !exists("autocommands_loaded") && has("autocmd") "{{{
    " Reload vimrc after editing
    autocmd BufWritePost ~/.vimrc source ~/.vimrc

    " Automatically make shell scripts executable
    autocmd BufWritePost *.sh call MakeExecutable()

    " Enable spelling for *.txt files
    autocmd BufRead,BufNewFile *.txt set spell

    " go back to previous position of cursor if any
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \  exe 'normal! g`"zvzz' |
          \ endif

    " Close preview window
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " Set noexpandtab automatically when editing makefiles
    autocmd FileType make setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

    autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
    autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
    autocmd FileType python setlocal foldmethod=indent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    autocmd FileType markdown setlocal nolist
    autocmd FileType vim setlocal fdm=indent keywordprg=:help
    autocmd FileType cpp setlocal iskeyword-=:
    autocmd FileType java,groovy,scala setlocal colorcolumn=120 textwidth=118
    " Move the quickfix window to the bottom
    autocmd FileType qf wincmd J

    " augroup numbertoggle
    "   autocmd!
    "   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    "   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    " augroup END

    " for .hql files
    au BufNewFile,BufRead *.hql set filetype=hive expandtab

    " for .q files
    au BufNewFile,BufRead *.q set filetype=hive expandtab

    let autocommands_loaded = 1
  endif "}}}
"}}}
