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
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() != 1
      close!
      if l:tab_nr == tabpagenr('$')
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
      close!
      if l:tab_nr == tabpagenr('$')
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

" setup dein / neobundle {{{
  if has('nvim')
    set rtp+=~/.vim/dein-plugins/repos/github.com/Shougo/dein.vim
    call dein#begin(expand('~/.vim/dein-plugins'))
    call dein#add('~/.vim/dein-plugins/repos/github.com/Shougo/dein.vim')

    " plugin/mapping configuration {{{
      call dein#add('Shougo/denite.nvim') "{{{
        nmap <space> [denite]
        nnoremap [denite] <nop>

        nnoremap <silent> [denite]<space> :<C-u>Denite file_mru<cr><c-u>
        nnoremap <silent> [denite]f :<C-u>Denite file_rec<cr><c-u>
        nnoremap <silent> [denite]y :<C-u>Denite neo_yank<cr>
        nnoremap <silent> [denite]l :<C-u>Denite line<cr>
        nnoremap <silent> [denite]b :<C-u>Denite buffer<cr>
        nnoremap <silent> [denite]/ :<C-u>Denite grep<cr>
      "}}}

      call dein#add('Shougo/neomru.vim')
      call dein#add('Shougo/neoyank.vim')

      call dein#add('Shougo/deoplete.nvim') "{{{
        let g:deoplete#enable_at_startup = 1
        " Tab to cycle thru matches
        inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
        inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
        if !exists('g:deoplete#omni#input_patterns')
          let g:deoplete#omni#input_patterns = {}
        endif
      "}}}

      call dein#add('zchee/deoplete-jedi')

      "call dein#add('LuXuryPro/deoplete-rtags')

      call dein#add('Rip-Rip/clang_complete') "{{{
        let g:clang_library_path='/usr/lib/llvm-3.8/lib'
        let g:clang_complete_auto = 0
        let g:clang_auto_select = 0
        let g:clang_omnicppcomplete_compliance = 0
        let g:clang_make_default_keymappings = 0
        "let g:clang_use_library = 1
      "}}}

      call dein#add('lyuts/vim-rtags') "{{{
        let g:rtagsUserLocationList = 0
      "}}}

      call dein#add('itchyny/lightline.vim') "{{{
        let g:lightline = {
            \ 'colorscheme': 'PaperColor',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'fugitive', 'filename' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'LightlineFugitive',
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

        function! LightlineFugitive()
          if exists("*fugitive#head")
            let branch = fugitive#head()
            return branch !=# '' ? ' '.branch : ''
          endif
          return ''
        endfunction
      "}}}

      call dein#add('edkolev/tmuxline.vim')

      call dein#add('tpope/vim-fugitive')

      call dein#add('vim-scripts/a.vim') "{{{
        let g:alternateSearchPath = 'reg:/include/src/g/,reg:/src/include/g/'
        let g:alternateNoDefaultAlternate = 1
      "}}}

      call dein#add('tpope/vim-repeat')

      call dein#add('tpope/vim-obsession')

      call dein#add('chazy/cscope_maps')

      call dein#add('taglist.vim') "{{{
        " Toggle Tag list plugin
        map <leader>tl :TlistToggle<cr>

        let Tlist_Auto_Open = 0
        let Tlist_Exit_OnlyWindow = 1
        "let Tlist_Show_One_File = 1
        "let Tlist_Display_Prototype = 1
        let Tlist_File_Fold_Auto_Close = 1
        let Tlist_WinWidth = 40
      "}}}

      call dein#add('vim-scripts/vcscommand.vim')

      call dein#add('honza/vim-snippets')

      call dein#add('SirVer/ultisnips') "{{{
        " Trigger configuration. Do not use <tab> if you use
        " https://github.com/Valloric/YouCompleteMe.
        let g:UltiSnipsExpandTrigger = "<leader><tab>"
        let g:UltiSnipsJumpForwardTrigger = "<leader><tab>"
        let g:UltiSnipsJumpBackwardTrigger = "<leader><s-tab>"
        let g:UltiSnipsListSnippets = "<leader>sn"
        let g:UltiSnipsSnippetDirectories = ["snips-private", "UltiSnips"]

        " " If you want :UltiSnipsEdit to split your window.
        let g:UltiSnipsEditSplit = "vertical"
      "}}}

      call dein#add('tranngocthachs/gtags-cscope-vim-plugin')

      call dein#add('vim-scripts/gtags.vim') "{{{
        let GtagsCscope_Auto_Load = 1

        " let GtagsCscope_Auto_Map = 1

        let GtagsCscope_Quiet = 1

        let GtagsCscope_Absolute_Path = 1
      "}}}

      call dein#add('kmnk/vim-unite-svn')

      call dein#add('Shougo/vimproc.vim', {
        \ 'build': {
          \ 'mac': 'make -f make_mac.mak',
          \ 'unix': 'make -f make_unix.mak',
          \ 'cygwin': 'make -f make_cygwin.mak',
          \ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe" make_msvc32.mak',
        \ },
      \ })

      call dein#add('Shougo/vimshell.vim')

      call dein#add('mbbill/undotree') "{{{{
        nmap <leader>ut :UndotreeToggle<cr>
      "}}}}

      call dein#add('tomtom/tcomment_vim')

      call dein#add('terryma/vim-multiple-cursors')

      "call dein#add('jiangmiao/auto-pairs')

      call dein#add('tmhedberg/matchit')

      call dein#add('tpope/vim-surround')
      call dein#add('tpope/vim-dispatch')

      call dein#add('pangloss/vim-javascript', {'on_ft': ['javascript']})
      call dein#add('leshill/vim-json', {'on_ft': ['javascript', 'json']})

      call dein#add('terryma/vim-expand-region')

      call dein#add('justinmk/vim-sneak') "{{{
        let g:sneak#streak = 0
      "}}}

      " call dein#add('nathanaelkane/vim-indent-guides') "{{{
      "   let g:indent_guides_start_level=1
      "   let g:indent_guides_guide_size=1
      "   let g:indent_guides_enable_on_vim_startup=1
      "   let g:indent_guides_color_change_percent=3
      "   if !has('gui_running')
      "     let g:indent_guides_auto_colors=0
      "     function! s:indent_set_console_colors()
      "       hi IndentGuidesOdd ctermbg=235
      "       hi IndentGuidesEven ctermbg=236
      "     endfunction
      "     autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
      "   endif
      "}}}

      call dein#add('Yggdroot/indentLine') "{{{
      "}}}

      call dein#add('guns/xterm-color-table.vim', {'on_cmd': 'XtermColorTable'})

      call dein#add('vim-scripts/multisearch.vim') "{{{
        function! s:initMsearch()
          " Add your Msearch initialization commands here ...
          Msearch highlight add ctermbg=blue
          Msearch highlight add ctermbg=yellow
          Msearch highlight add ctermbg=green
          Msearch highlight add ctermbg=cyan
          Msearch highlight add ctermbg=magenta
          Msearch highlight add ctermbg=lightyellow
          Msearch highlight add ctermbg=lightred
          Msearch highlight add ctermbg=lightgreen
          Msearch highlight add ctermbg=lightcyan
          Msearch highlight add ctermbg=lightmagenta
          Msearch highlight add ctermbg=lightgray
          Msearch highlight add ctermbg=brown
          Msearch highlight add ctermbg=darkgreen
          Msearch highlight add ctermbg=darkmagenta
          Msearch highlight add ctermbg=darkred

          map <leader>m/ :Msearch add 
          map <leader>mn :Msearch next<cr>
          map <leader>mN :Msearch previous<cr>
        endfunction
        autocmd VimEnter * call s:initMsearch()
      "}}}

      call dein#add('jrosiek/vim-mark') "{{{
        let g:mwDefaultHighlightingPalette = 'maximum'
      "}}}

      call dein#add('zhaocai/GoldenView.Vim') "{{{
        let g:goldenview__enable_at_startup = 0

        " 1. split to tiled windows
        nmap <silent> <C-L>  <Plug>GoldenViewSplit

        " 2. quickly switch current window with the main pane
        " and toggle back
        nmap <silent> <F8>   <Plug>GoldenViewSwitchMain
        nmap <silent> <S-F8> <Plug>GoldenViewSwitchToggle

        " 3. jump to next and previous window
        nmap <silent> <C-N>  <Plug>GoldenViewNext
        nmap <silent> <C-P>  <Plug>GoldenViewPrevious
      "}}}
    "}}}

    call dein#end()
  else
    set rtp+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'

    " plugin/mapping configuration {{{
      NeoBundle 'a.vim' "{{{
        let g:alternateSearchPath = 'reg:/include/src/g/,reg:/src/include/g/'
        let g:alternateNoDefaultAlternate = 1
      "}}}

      NeoBundle 'tpope/vim-repeat'

      NeoBundle 'tpope/vim-obsession'

      NeoBundle 'chazy/cscope_maps'

      NeoBundle 'taglist.vim' "{{{
        " Toggle Tag list plugin
        map <leader>tl :TlistToggle<cr>

        let Tlist_Auto_Open = 0
        let Tlist_Exit_OnlyWindow = 1
        "let Tlist_Show_One_File = 1
        "let Tlist_Display_Prototype = 1
        let Tlist_File_Fold_Auto_Close = 1
        let Tlist_WinWidth = 40
      "}}}

      NeoBundle 'git://repo.or.cz/vcscommand'

      NeoBundle 'honza/vim-snippets'

      NeoBundle 'Valloric/YouCompleteMe', {'vim_version':'7.3.584'} "{{{
        let g:ycm_global_ycm_extra_conf = '~/.default_ycm_extra_conf.py'
        let g:ycm_auto_trigger = 1
        "let g:ycm_key_invoke_completion = '<tab>'
        let g:ycm_always_populate_location_list = 1
        let g:ycm_complete_in_comments = 1
        let g:ycm_collect_identifiers_from_comments_and_strings = 1
        let g:ycm_add_preview_to_completeopt = 1
        let g:ycm_autoclose_preview_window_after_completion = 1
        let g:ycm_confirm_extra_conf = 0
        let g:ycm_goto_buffer_command = 'horizontal-split'

        map <leader>yg :YcmComplete GoTo<cr>
        map <leader>yd :YcmComplete GoToDeclaration<cr>
        map <leader>yD :YcmComplete GoToDefinition<cr>
      "}}}

      NeoBundle 'SirVer/ultisnips' "{{{
        " Trigger configuration. Do not use <tab> if you use
        " https://github.com/Valloric/YouCompleteMe.
        let g:UltiSnipsExpandTrigger = "<leader><tab>"
        let g:UltiSnipsJumpForwardTrigger = "<leader><tab>"
        let g:UltiSnipsJumpBackwardTrigger = "<leader><s-tab>"
        let g:UltiSnipsListSnippets = "<leader>sn"
        let g:UltiSnipsSnippetDirectories = ["snips-private", "UltiSnips"]

        " " If you want :UltiSnipsEdit to split your window.
        let g:UltiSnipsEditSplit = "vertical"
      "}}}

      NeoBundle 'tranngocthachs/gtags-cscope-vim-plugin'

      NeoBundle 'vim-scripts/gtags.vim' "{{{
        let GtagsCscope_Auto_Load = 1

        " let GtagsCscope_Auto_Map = 1

        let GtagsCscope_Quiet = 1

        let GtagsCscope_Absolute_Path = 1
      "}}}

      NeoBundle 'Shougo/unite.vim' "{{{
        let bundle = neobundle#get('unite.vim')
        function! bundle.hooks.on_source(bundle)
          call unite#filters#matcher_default#use(['matcher_fuzzy'])
          call unite#filters#sorter_default#use(['sorter_rank'])
          call unite#custom#source('line,outline','matchers','matcher_fuzzy')
          call unite#custom#profile('default', 'context', {
                \ 'start_insert': 1,
                \ 'direction': 'topleft',
                \ })
        endfunction

        let g:unite_data_directory = s:get_cache_dir('unite')
        let g:unite_source_history_yank_enable = 1
        let g:unite_source_rec_max_cache_files = 5000

        if executable('ag')
          let g:unite_source_grep_command = 'ag'
          let g:unite_source_grep_default_opts = '--nocolor --line-numbers --nogroup -S'
          let g:unite_source_grep_recursive_opt = ''
        elseif executable('ack')
          let g:unite_source_grep_command = 'ack'
          let g:unite_source_grep_default_opts = '--no-heading --no-color'
          let g:unite_source_grep_recursive_opt = ''
        endif

        nmap <space> [unite]
        nnoremap [unite] <nop>

        if s:is_windows
          nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec:! buffer file_mru bookmark<cr><c-u>
          nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec:!<cr><c-u>
        else
          nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr><c-u>
          nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
        endif
        nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
        nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
        nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
        nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
        nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
        nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>
      "}}}

      NeoBundleLazy 'Shougo/neomru.vim', {'autoload':{'unite_sources':'file_mru'}} "{{{
        nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
      "}}}

      NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':['tag','tag/file']}} "{{{
        nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<cr>
      "}}}

      NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}} "{{{
        nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>
      "}}}

      NeoBundleLazy 'Shougo/unite-help', {'autoload':{'unite_sources':'help'}} "{{{
        nnoremap <silent> [unite]h :<C-u>Unite -auto-resize -buffer-name=help help<cr>
      "}}}

      NeoBundle 'kmnk/vim-unite-svn'

      NeoBundle 'Shougo/vimproc.vim', {
        \ 'build': {
          \ 'mac': 'make -f make_mac.mak',
          \ 'unix': 'make -f make_unix.mak',
          \ 'cygwin': 'make -f make_cygwin.mak',
          \ 'windows': '"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\nmake.exe" make_msvc32.mak',
        \ },
      \ }

      NeoBundle 'Shougo/vimshell.vim'

      NeoBundle 'mbbill/undotree' "{{{{
        nmap <leader>ut :UndotreeToggle<cr>
      "}}}}

      NeoBundle 'tomtom/tcomment_vim'

      NeoBundle 'terryma/vim-multiple-cursors'

      "NeoBundle 'jiangmiao/auto-pairs'

      NeoBundle 'edsono/vim-matchit'

      NeoBundle 'tpope/vim-surround'
      NeoBundle 'tpope/vim-dispatch'

      NeoBundleLazy 'pangloss/vim-javascript', {'autoload':{'filetypes':['javascript']}}
      NeoBundleLazy 'leshill/vim-json', {'autoload':{'filetypes':['javascript','json']}}

      NeoBundle 'terryma/vim-expand-region'

      NeoBundle 'justinmk/vim-sneak' "{{{
        let g:sneak#streak = 0
      "}}}

      " NeoBundle 'nathanaelkane/vim-indent-guides' "{{{
      "   let g:indent_guides_start_level=1
      "   let g:indent_guides_guide_size=1
      "   let g:indent_guides_enable_on_vim_startup=1
      "   let g:indent_guides_color_change_percent=3
      "   if !has('gui_running')
      "     let g:indent_guides_auto_colors=0
      "     function! s:indent_set_console_colors()
      "       hi IndentGuidesOdd ctermbg=235
      "       hi IndentGuidesEven ctermbg=236
      "     endfunction
      "     autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
      "   endif
      "}}}

      NeoBundle 'Yggdroot/indentLine' "{{{
      "}}}

      NeoBundleLazy 'guns/xterm-color-table.vim', {'autoload':{'commands':'XtermColorTable'}}

      NeoBundle 'vim-scripts/multisearch.vim' "{{{
        function! s:initMsearch()
          " Add your Msearch initialization commands here ...
          Msearch highlight add ctermbg=blue
          Msearch highlight add ctermbg=yellow
          Msearch highlight add ctermbg=green
          Msearch highlight add ctermbg=cyan
          Msearch highlight add ctermbg=magenta
          Msearch highlight add ctermbg=lightyellow
          Msearch highlight add ctermbg=lightred
          Msearch highlight add ctermbg=lightgreen
          Msearch highlight add ctermbg=lightcyan
          Msearch highlight add ctermbg=lightmagenta
          Msearch highlight add ctermbg=lightgray
          Msearch highlight add ctermbg=brown
          Msearch highlight add ctermbg=darkgreen
          Msearch highlight add ctermbg=darkmagenta
          Msearch highlight add ctermbg=darkred

          map <leader>m/ :Msearch add 
          map <leader>mn :Msearch next<cr>
          map <leader>mN :Msearch previous<cr>
        endfunction
        autocmd VimEnter * call s:initMsearch()
      "}}}

      nnoremap <leader>nbu :Unite neobundle/update -vertical -no-start-insert<cr>

      NeoBundle 'jrosiek/vim-mark' "{{{
        let g:mwDefaultHighlightingPalette = 'maximum'
      "}}}

      NeoBundle 'zhaocai/GoldenView.Vim' "{{{
        let g:goldenview__enable_at_startup = 0

        " 1. split to tiled windows
        nmap <silent> <C-L>  <Plug>GoldenViewSplit

        " 2. quickly switch current window with the main pane
        " and toggle back
        nmap <silent> <F8>   <Plug>GoldenViewSwitchMain
        nmap <silent> <S-F8> <Plug>GoldenViewSwitchToggle

        " 3. jump to next and previous window
        nmap <silent> <C-N>  <Plug>GoldenViewNext
        nmap <silent> <C-P>  <Plug>GoldenViewPrevious
      "}}}

      NeoBundle 'lyuts/vim-rtags' "{{{
        let g:rtagsUserLocationList = 0
        nnoremap <silent> [unite]rr :<C-u>Unite -buffer-name=rtagsRef rtags/references<cr>
        nnoremap <silent> [unite]rs :<C-u>Unite -buffer-name=rtagsSymbol rtags/symbol<cr>
      "}}}

      NeoBundle 'hewes/unite-gtags' "{{{
        nnoremap <silent> [unite]gc :<C-u>Unite -buffer-name=gtagsContext gtags/context<cr>
        nnoremap <silent> [unite]gr :<C-u>Unite -buffer-name=gtagsRef gtags/ref<cr>
        nnoremap <silent> [unite]gd :<C-u>Unite -buffer-name=gtagsDef gtags/def<cr>
        nnoremap <silent> [unite]gg :<C-u>Unite -buffer-name=gtagsGrep gtags/grep<cr>
        nnoremap <silent> [unite]gp :<C-u>Unite -buffer-name=gtagsPath gtags/path<cr>
      "}}}
    "}}}

    call neobundle#end()
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

  set cscopetag

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

  " Try to use colors that look good on a dark background
  set background=dark

  " Set colorscheme
  colorscheme desert

  " Splitting a window will put the new window right of the current one.
  set splitright

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

  map <leader>s :set spell!<cr>

  " Show invisible characters
  nmap <leader>l :set list!<cr>

  nnoremap <C-w>. :call MoveToNextTab()<CR>
  nnoremap <C-w>, :call MoveToPrevTab()<CR>
"}}}

" python {{{
  if has('nvim')
    let g:python_host_prog  = '/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
  endif
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

    " Close preview window
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    autocmd FileType js,scss,css autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
    autocmd FileType css,scss nnoremap <silent> <leader>S vi{:sort<CR>
    autocmd FileType python setlocal foldmethod=indent tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType markdown setlocal nolist
    autocmd FileType vim setlocal fdm=indent keywordprg=:help
    autocmd FileType cpp set iskeyword-=:

    let autocommands_loaded = 1
  endif "}}}
"}}}
