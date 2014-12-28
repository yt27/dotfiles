" Modeled after https://github.com/bling/dotvim

" detect OS {{{
  let s:is_windows = has('win32') || has('win64')
  let s:is_cygwin = has('win32unix')
  let s:is_macvim = has('gui_macvim')
"}}}

" setup & neobundle {{{
  set nocompatible
  set all& "reset everything to their defaults
  if s:is_windows
    set rtp+=~/.vim
  endif
  set rtp+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
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
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
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
"}}}

" base configuration {{{
  " Force 256 colors if xterm is in use or builtin_gui (vimperator workaround)
  if &term == "xterm" || &term == "builtin_gui"
     set t_Co=256
  endif

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
  set hidden

  " Report every change
  set report=0

  " Don't move the cursor to the start of line when scrolling
  set nostartofline

  " Highlight the screen line of the cursor
  set cursorline

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

  " Show the line and column number of the cursor position
  set ruler

  " Print the line number in front of each line.
  set number

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

  " Try to use colors that look good on a dark background
  set background=dark

  " Minimal number of screen lines to keep above and below the cursor
  set scrolloff=5

  " Minimal number of columns to scroll horizontally.
  set sidescroll=1

  " Turn on folding
  set foldenable

  " fold according to syntax hl rules
  set foldmethod=syntax

  " Set colorscheme
  colorscheme desert

  " Splitting a window will put the new window right of the current one.
  set splitright
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

  " Name of the terminal type of which mouse codes are to be recognized.
  set ttymouse=xterm2
"}}}

" status line {{{
  " Clear statusline
  set statusline=

  " Append buffer number
  set statusline+=%-n

  " Append total number of buffers
  set statusline+=/%-3.3{CountBuffers()}

  " Append filename
  set statusline+=%F\

  " Append filetype
  set statusline+=\[%{strlen(&ft)?&ft:'none'},

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
  " Append line number, column number, virtual column number
  set statusline+=%l,%c

  " Separator
  set statusline+=\ \ \|\ \

  " Append percentage through file of displayed window
  set statusline+=%3p%%

  " Separator
  set statusline+=\ \ \|\ \

  " Append value of byte under cursor in hexadecimal
  set statusline+=0x%-2B
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

" plugin/mapping configuration {{{
  NeoBundle 'a.vim'

  NeoBundle 'jlanzarotta/bufexplorer'

  NeoBundle 'chazy/cscope_maps'

  NeoBundle 'xolox/vim-session'
  NeoBundle 'xolox/vim-misc'

  "NeoBundle 'ervandew/supertab'

  NeoBundle 'taglist.vim'

  NeoBundle 'git://repo.or.cz/vcscommand'

  NeoBundle 'SirVer/ultisnips'
  NeoBundle 'honza/vim-snippets'

  NeoBundle 'Valloric/YouCompleteMe', {'vim_version':'7.3.584'}

  NeoBundle 'tranngocthachs/gtags-cscope-vim-plugin'

  NeoBundle 'vim-scripts/gtags.vim'

  NeoBundle 'Shougo/unite.vim'

  NeoBundle 'kmnk/vim-unite-svn'

  NeoBundle 'Shougo/vimproc.vim', {
    \ 'build': {
      \ 'mac': 'make -f make_mac.mak',
      \ 'unix': 'make -f make_unix.mak',
      \ 'cygwin': 'make -f make_cygwin.mak',
      \ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe" make_msvc32.mak',
    \ },
  \ }

  NeoBundle 'Shougo/neomru.vim'

  NeoBundle 'Shougo/vimshell.vim'

  NeoBundle 'mbbill/undotree'

  NeoBundle 'tomtom/tcomment_vim'

  NeoBundle 'terryma/vim-multiple-cursors'

  NeoBundle 'Raimondi/delimitMate'
"}}}

" mapping {{{
  map <leader>tn :tabnew .<cr>

  " Show invisible characters
  nmap <leader>l :set list!<cr>
"}}}

" autocommand {{{
  " Make sure autocommands are loaded only once
  if !exists("autocommands_loaded") && has("autocmd") "{{{
    " Set noexpandtab automatically when editing makefiles
    autocmd FileType make setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

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

    autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
    autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType markdown setlocal nolist
    autocmd FileType vim setlocal fdm=indent keywordprg=:help

    let autocommands_loaded=1
  endif "}}}
"}}}

" finish loading {{{
  call neobundle#end()
  filetype plugin indent on
  syntax enable
  "exec 'colorscheme '.s:settings.colorscheme

  NeoBundleCheck
"}}}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GNU Global
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let GtagsCscope_Auto_Load = 1

" let GtagsCscope_Auto_Map = 1

let GtagsCscope_Quiet = 1

let GtagsCscope_Absolute_Path = 1

set cscopetag

" set csprg=gtags-cscope

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyboard mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle NERDTree plugin
" map <silent> <c-b> :NERDTreeToggle<cr>

" Toggle Tag list plugin
map <leader>tl :TlistToggle<cr>

" vim-session plugin
let g:session_autosave_periodic=1
let g:session_default_to_last=1

" ControlP plugin
let g:ctrlp_working_path_mode = 'a'

" Disable arrows
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>
" map <up> <nop>

" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>
" imap <up> <nop>

" Switch to current directory
" map <leader>cd :cd %:p:h<cr>

" Detect filetype again
" map <leader>fd :filetype detect<cr>

" Remove the Windows ^M
" noremap <leader>m mmHmt:%s/<c-v><cr>//ge<cr>'tzt'm

" Spell toggle
" nmap <silent> <leader>s :set spell!<cr>

" Paste toggle
" set pastetoggle=<f3>

" Remove indenting on empty lines
" map <f2> :%s/\s*$//g<cr> :nohlsearch <cr>''

" Toggle line numbers
" map <f1> :set number!<cr>

" Move line up
" nnoremap <A-k> :m-2<cr>
" Move line down
" nnoremap <A-j> :m+<cr>
" Move visual selection up
" vnoremap <A-k> :m-2<cr>gv
" Move visual selection down
" vnoremap <A-j> :m'>+<cr>gv

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let NERDTreeQuitOnOpen = 1
" let NERDTreeShowHidden = 1
" let NERDTreeIgnore = ['\.o$', '\.obj$', '\.exe$', '\.class$', '\.pyc$', '\.jpg$', '\.png$', '\.gif$', '\.pdf$']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git branch plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't show any message when there is no git repository on the current dir
" let g:git_branch_status_nogit=""

" Don't show any text before branch name.
" let g:git_branch_status_text=""

" Show just the current head branch name.
" let g:git_branch_status_head_current=1

" Characters to put around the branch strings.
" let g:git_branch_status_around="[]"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" A (alternate) plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:alternateExtensions_cpp="hh"
" let g:alternateExtensions_hh="cpp"
let alternateSearchPath='sfr:../Src,sfr:../Inc,sfr:../source,sfr:../src,sfr:../include,sfr:../inc'

highlight Folded ctermbg=none ctermfg=darkmagenta

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Taglist plugin
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let Tlist_Auto_Open=1
let Tlist_Exit_OnlyWindow=1
"let Tlist_Show_One_File=1
"let Tlist_Display_Prototype=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_WinWidth = 40

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniCppComplete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" http://vim.wikia.com/wiki/C%2B%2B_code_completion
" let OmniCpp_NamespaceSearch = 1
" let OmniCpp_GlobalScopeSearch = 1
" let OmniCpp_ShowAccess = 1
" let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
" let OmniCpp_MayCompleteDot = 1 " autocomplete after .
" let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
" let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
" let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
"set completeopt=menuone,menu,longest,preview
" set completeopt=menuone,menu,preview

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimdiff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if &diff
   " Jump backwards to the previous start of a change.
   map <up> [c

   " Jump forwards to the next start of a change.
   map <down> ]c

   " Modify the current buffer to undo difference with another buffer.
   map <left> :diffget<cr>

   " Modify another buffer to undo difference with the current buffer.
   map <right> :diffput<cr>

   " Update the diff highlighting and folds
   map <f5> :diffupdate<cr>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ultisnips
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"

" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ycm_global_ycm_extra_conf = '~/.default_ycm_extra_conf.py'
let g:ycm_always_populate_location_list=1
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_completion=1

map <leader>yg :YcmComplete GoTo<cr>
map <leader>yd :YcmComplete GoToDeclaration<cr>
map <leader>yD :YcmComplete GoToDefinition<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unite
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" From https://github.com/bling/dotvim/blob/master/vimrc
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('line,outline','matchers','matcher_fuzzy')
call unite#custom#profile('default', 'context', {
      \ 'start_insert': 1,
      \ 'direction': 'botright',
      \ })

let g:unite_source_grep_command='ag'
let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S'
let g:unite_source_grep_recursive_opt=''
let g:unite_data_directory=expand("~/.vim/cache/unite")
let g:unite_source_history_yank_enable=1
let g:unite_source_rec_max_cache_files=5000

nmap <space> [unite]
nnoremap [unite] <nop>

nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async buffer file_mru bookmark<cr><c-u>
nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async<cr><c-u>
nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DelimitMate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:delimitMate_expand_cr=1
let g:delimitMate_expand_space=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" command! -nargs=? Vhelp vert help <args>
" command! Wsu w !sudo tee %
" command! Q confirm qall
