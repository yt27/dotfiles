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
  if has('vim_starting')
    " Saving/restoring colums/lines before/after set all& as the window size
    " is messed up due to https://github.com/neovim/neovim/issues/11066
    let s:columns_bak = &columns
    let s:lines_bak = &lines

    set all& "reset everything to their defaults

    let &columns = s:columns_bak
    let &lines = s:lines_bak
    unlet s:columns_bak
    unlet s:lines_bak
  endif
  if s:is_windows
    set rtp+=~/.vim
  endif
"}}}

" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" setup vim-plug {{{
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Color scheme
  Plug 'kristijanhusak/vim-hybrid-material'

  " General
  Plug 'easymotion/vim-easymotion'
  Plug 'google/vim-searchindex'
  Plug 'itchyny/lightline.vim'
  Plug 'mbbill/undotree'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'RRethy/vim-illuminate'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 't9md/vim-choosewin'
  Plug 'tpope/vim-obsession'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-vinegar'
  Plug 'tpope/vim-unimpaired'
  Plug 'Yggdroot/indentLine'
  Plug 'dstein64/nvim-scrollview', { 'branch': 'main' }

  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

  " completion
  "Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  "Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  " Tmux
  Plug 'benmills/vimux'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'edkolev/tmuxline.vim'

  " Dev
  Plug 'neovim/nvim-lspconfig'
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'airblade/vim-rooter'
  Plug 'andymass/vim-matchup'
  Plug 'machakann/vim-sandwich'
  Plug 'majutsushi/tagbar'
  Plug 'tomtom/tcomment_vim'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-scripts/vcscommand.vim'

  " Snippets
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  " Syntax
  Plug 'autowitch/hive.vim'
  Plug 'motus/pig.vim'
call plug#end()
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
  set history=10000

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
  set background=dark
  let g:hybrid_custom_term_colors = 1
  colorscheme hybrid_material

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

  " Keep the current line in the middle
  "set scrolloff=999

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
  highlight CursorColumn guibg=#404040
  highlight CursorLine guibg=#404040
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

" bell {{{
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

  " switch j/k with gj/gk (down/up visible line)
  nnoremap j gj
  nnoremap k gk
  nnoremap gj j
  nnoremap gk k

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

    autocmd FileType c,cpp,java,js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
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
    autocmd BufNewFile,BufRead *.hql set filetype=hive expandtab

    " for .q files
    autocmd BufNewFile,BufRead *.q set filetype=hive expandtab

    let autocommands_loaded = 1
  endif "}}}
"}}}

" plugin: nvim-lspconfig {{{
lua << EOF
  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local nvim_lsp = require('lspconfig')
  local servers = { 'pyright' }
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = require('keybindings').lspOnAttachCallback(),
      capabilities = capabilities
    }
  end
EOF
"}}}

" plugin: fzf {{{
  let $FZF_DEFAULT_OPTS .= ' --no-height'
"}}}

" plugin: fzf.vim {{{
  " Enable per-command history.
  " CTRL-N and CTRL-P will be automatically bound to next-history and
  " previous-history instead of down and up. If you don't like the change,
  " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
  let g:fzf_history_dir = '~/.local/share/fzf-history'

  let g:fzf_commits_log_options = '--graph --pretty=format:"%C(#ff5555)[%ci]%C(#88ff88)[%h] %Creset%s%C(#77ffff)\\ [%cn]" --decorate'
  " let g:fzf_preview_window = ['up:40%', 'ctrl-/']

  command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
    \   'git grep --line-number -- '.shellescape(<q-args>), 0,
    \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

  nmap <space> [fzf]
  nnoremap [fzf] <nop>

  nnoremap <silent> [fzf]f :<C-u>Files<cr>
  nnoremap <silent> [fzf]gg :<C-u>GGrep<cr>
  nnoremap <silent> [fzf]gG :<C-u>GGrep <c-r><c-w><cr>
  nnoremap <silent> [fzf]gf :<C-u>GFiles<cr>
  nnoremap <silent> [fzf]gF :<C-u>GFiles <c-r><c-w><cr>
  nnoremap <silent> [fzf]gs :<C-u>GFiles?<cr>
  nnoremap <silent> [fzf]gl :<C-u>Commits<cr>
  nnoremap <silent> [fzf]gL :<C-u>BCommits<cr>
  nnoremap <silent> [fzf]b :<C-u>Buffers<cr>
  nnoremap <silent> [fzf]r :<C-u>Rg<cr>
  nnoremap <silent> [fzf]R :<C-u>Rg <c-r><c-w><cr>
  nnoremap <silent> [fzf]l :<C-u>Lines<cr>
  nnoremap <silent> [fzf]L :<C-u>Lines <c-r><c-w><cr>
  nnoremap <silent> [fzf]bl :<C-u>BLines<cr>
  nnoremap <silent> [fzf]bL :<C-u>BLines <c-r><c-w><cr>
  nnoremap <silent> [fzf]t :<C-u>Tags<cr>
  nnoremap <silent> [fzf]T :<C-u>BTags<cr>
  nnoremap <silent> [fzf]m :<C-u>Marks<cr>
  nnoremap <silent> [fzf]w :<C-u>Windows<cr>
  nnoremap <silent> [fzf]h :<C-u>History<cr>
  nnoremap <silent> [fzf]ch :<C-u>History:<cr>
  nnoremap <silent> [fzf]sh :<C-u>History/<cr>
  nnoremap <silent> [fzf]c :<C-u>Commands<cr>
  nnoremap <silent> [fzf]M :<C-u>Maps<cr>
  nnoremap <silent> [fzf]h :<C-u>Helptags<cr>
"}}}

" plugin: telescope-fzf-native {{{
lua << EOF
  require('config.telescope').setup()
EOF
"}}}

" plugin: nvim-cmp {{{
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-k>'] = cmp.mapping.scroll_docs(-4),
      ['<C-j>'] = cmp.mapping.scroll_docs(4)
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    --}, {
      { name = 'buffer' }
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
EOF
"}}}

" plugin: vim-vsnip {{{
  " Jump forward or backward
  imap <expr> \<Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> \<Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> \<S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> \<S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
"}}}

" plugin: coq_nvim {{{
  let g:coq_settings = { 'auto_start': v:true, 'keymap': { 'jump_to_mark': '<c-m>', 'bigger_preview': '', 'repeat': 'c.' } }
"}}}

" plugin: nvim-scrollview {{{
  highlight ScrollView ctermbg=159 guibg=LightCyan
"}}}

" plugin: vim-illuminate {{{
  map <leader>in :IlluminationToggle<cr>
"}}}

" plugin: undotree {{{
  nmap <leader>ut :UndotreeToggle<cr>
"}}}

" plugin: indentLine {{{
  let g:indentLine_leadingSpaceEnabled = 1

  function! YtToggleIndentLineAndLeadingSpace()
    execute 'IndentLinesToggle'
    execute 'LeadingSpaceToggle'
  endfunction
  map <leader>il :call YtToggleIndentLineAndLeadingSpace()<cr>

  let g:indentLine_bufNameExclude = ['NERD_tree.*']
"}}}

" plugin: vim-choosewin {{{
  nmap  <leader>cw <Plug>(choosewin)
  let g:choosewin_overlay_enable = 1
"}}}

" plugin: easymotion {{{
  let g:EasyMotion_use_upper = 1
  let g:EasyMotion_keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ;'

  nmap <leader>e [easymotion]
  nnoremap [easymotion] <nop>

  " <Leader>f{char} to move to {char}
  map  [easymotion]f <Plug>(easymotion-bd-f)
  nmap [easymotion]f <Plug>(easymotion-overwin-f)

  " s{char}{char} to move to {char}{char}
  nmap s <Plug>(easymotion-overwin-f2)

  " Move to line
  map [easymotion]l <Plug>(easymotion-bd-jk)
  nmap [easymotion]l <Plug>(easymotion-overwin-line)

  " Move to word
  map  [easymotion]w <Plug>(easymotion-bd-w)
  nmap [easymotion]w <Plug>(easymotion-overwin-w)
"}}}

" plugin: lightline {{{
  let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'gitbranch' ],
      \     [ 'readonly', 'filename' ]
      \   ],
      \   'right': [
      \     [ 'lineinfo', 'percent' ],
      \     [ 'fileformat', 'fileencoding', 'filetype' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filename': 'LightlineFilename'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
    \ }
  function! LightlineModified()
    if &filetype == "help"
      return ""
    elseif &modified
      return "+"
    elseif &modifiable
      return ""
    else
      return ""
    endif
  endfunction

  function! LightlineReadonly()
    if &filetype == "help"
      return ""
    elseif &readonly
      return ""
    else
      return ""
    endif
  endfunction

  function! LightlineFilename()
    return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
          \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
          \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
  endfunction
"}}}

" plugin: vimux {{{
  " Hack to fix issue running command when in copy-mode
  let g:VimuxResetSequence='-X cancel'

  " Prompt for a command to run
  map <Leader>vp :VimuxPromptCommand<CR>

  " Run last command executed by VimuxRunCommand
  map <Leader>vl :VimuxRunLastCommand<CR>

  " Inspect runner pane
  map <Leader>vi :VimuxInspectRunner<CR>

  " Open vim tmux runner
  map <Leader>vo :call VimuxOpenRunner()<CR>

  " Close vim tmux runner opened by VimuxRunCommand
  map <Leader>vq :VimuxCloseRunner<CR>

  " Interrupt any command running in the runner pane
  map <Leader>vx :VimuxInterruptRunner<CR>

  " Zoom the runner pane (use <bind-key> z to restore runner pane)
  map <Leader>vz :call VimuxZoomRunner()<CR>
"}}}

" plugin: vim-matchup {{{
  let g:matchup_matchparen_status_offscreen = 0
"}}}

" plugin: tagbar {{{
  let g:tagbar_left = 1
  " Toggle Tag list plugin
  map <leader>tb :TagbarToggle<cr>
"}}}

" plugin: vcscommand {{{
  let g:VCSCommandMapPrefix = "<space>v"
"}}}

" plugin: vim-fugitive {{{
  map <leader>gl :Glog<cr>
  map <leader>gs :Git<cr>
  map <leader>gb :Git blame<cr>
  map <leader>gr :Gread<cr>
  map <leader>gd :Gvdiff<cr>
"}}}
