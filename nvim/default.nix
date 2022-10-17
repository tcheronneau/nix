{ fetchFromGitHub, vimUtils, neovim, vimPlugins }:

let
  neomux = vimUtils.buildVimPlugin {
    pname = "neomux";
    version = "test";
    src = fetchFromGitHub {
      owner = "nikvdp";
      repo = "neomux";
      rev = "7fa6754f3c781ca99fd533217443b1e4f86611d4";
      sha256 = "sha256-6Gr6/soyN5r+NRpDrFs9aT/assuQF9ydR3TfZnPlygI=";
    };
  };
  coc-ansible = vimUtils.buildVimPlugin {
    pname = "coc-ansible";
    version = "test";
    src = fetchFromGitHub {
      owner = "yaegassy";
      repo = "coc-ansible";
      rev = "507cde4d172e1732266b4d50d2a98dfde3dc6ab9";
      sha256 = "sha256-K7XtihHksv01x9j/faKRNzWn9nI9iomFYTFyYMO5QLc=";
    };
  };
  blamer = vimUtils.buildVimPlugin {
    pname = "blamer";
    version = "test";
    src = fetchFromGitHub {
      owner = "APZelos";
      repo = "blamer.nvim";
      rev = "f4eb22a9013642c411725fdda945ae45f8d93181";
      sha256 = "sha256-etLCmzOMi7xjYc43ZBqjPnj2gqrrSbmtcKdw6eZT8rM=";
    };
  };
in
neovim.override {
  configure = {
    customRC = ''
        syn on
        set tabstop=2
        set shiftwidth=2
        set sts=2
        set smarttab
        set expandtab
        set autoindent
        set hls
        set ruler
        set splitbelow
        set splitright
        set number
        " AIRLINE
        let g:airline_powerline_fonts = 1
        set t_Co=256
        let g:airline#extensions#branch#enabled=1
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'
        let g:blamer_enabled = 1
        
        "" RUST
        syntax enable
        filetype plugin indent on
        
        "Credit joshdick
        "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
        "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
        "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
        if (empty($TMUX))
          if (has("nvim"))
            "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
            let $NVIM_TUI_ENABLE_TRUE_COLOR=1
          endif
          "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
          "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
          " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
          if (has("termguicolors"))
            set termguicolors
          endif
        endif
        
        
        set background=dark " for the dark version
        "set background=light " for the light version
        colorscheme one
        
        " Trigger NERDTree at startup if no file + map open shortcut
        nnoremap <silent> <C-k><C-B> :NERDTreeToggle<CR>
        let NERDTreeShowHidden=1
        " https://gist.github.com/avesus/1954d9384d86cc1e39cb2b2eff7017b7
        autocmd FileType nerdtree noremap <buffer> <Tab> <nop>
        function! StartUp()                                                                                                                                                                                         
            if 0 == argc()
                NERDTree
            end
        endfunction
        
        " Term mode escape
        tnoremap <Esc> <C-\><C-n>
        " save session
        "nnoremap <silent> <C-k><C-s> :mks!<CR>
        "nnoremap <silent> <C-k><C-r> :source Session.vim<CR>
        nnoremap <C-n> :set nu!<CR>

        " Move accross buffer
        nnoremap <C-w><C-l> :bn<CR>
        nnoremap <C-w><C-k> :bp<CR>

        
        " Some FZF update for search
        nnoremap <C-f> :Files<CR>
        let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-s': 'split',
          \ 'ctrl-v': 'vsplit'
          \}
        
        nnoremap <silent> <C-w><C-t> :sp<CR>:resize 10<CR>:Neomux<CR>
        
        autocmd VimEnter * call StartUp()
        let g:chromatica#libclang_path='/usr/lib/llvm-11/lib/'
        let g:chromatica#enable_at_startup=1
        " Grep not opening file
        let g:EasyGrepOpenWindowOnMatch=0
        
        set clipboard+=unnamedplus
        "let g:clipboard = {
        "          \   'name': 'win32yank-wsl',
        "          \   'copy': {
        "          \      '+': 'win32yank.exe -i --crlf',
        "          \      '*': 'win32yank.exe -i --crlf',
        "          \    },
        "          \   'paste': {
        "          \      '+': 'win32yank.exe -o --lf',
        "          \      '*': 'win32yank.exe -o --lf',
        "          \   },
        "          \   'cache_enabled': 0,
        "          \ }
        """" COC
        " vim-prettier
        "let g:prettier#quickfix_enabled = 0
        "let g:prettier#quickfix_auto_focus = 0
        " prettier command for coc
        command! -nargs=0 Prettier :CocCommand prettier.formatFile
        " run prettier on save
        "let g:prettier#autoformat = 0
        "autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
        
        
        " ctrlp
        let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
        
        " j/k will move virtual lines (lines that wrap)
        "noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
        "noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
        
        "set relativenumber
        
        "set smarttab
        "set cindent
        "set tabstop=2
        "set shiftwidth=2
        "" always uses spaces instead of tab characters
        "set expandtab
        "colorscheme gruvbox
        
        " sync open file with NERDTree
        " " Check if NERDTree is open or active
        function! IsNERDTreeOpen()        
          return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
        endfunction
        
        " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
        " file, and we're not in vimdiff
        function! SyncTree()
          if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
            NERDTreeFind
            wincmd p
          endif
        endfunction
        
        " Highlight currently open buffer in NERDTree
        " autocmd BufEnter * call SyncTree()
        
        " coc config
        let g:coc_global_extensions = [
          \ 'coc-snippets',
          \ 'coc-pairs',
          \ 'coc-eslint', 
          \ 'coc-prettier', 
          \ 'coc-json', 
          \ 'coc-pyright',
          \ ]
        let g:coc_filetype_map = {
          \ 'yaml.ansible': 'ansible',
          \ }
        " from readme
        " if hidden is not set, TextEdit might fail.
        " Some servers have issues with backup files, see #649.
        set nobackup
        set nowritebackup
        
        " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
        " delays and poor user experience.
        set updatetime=300
        
        " Always show the signcolumn, otherwise it would shift the text each time
        " diagnostics appear/become resolved.
        set signcolumn=yes
        
        " Use tab for trigger completion with characters ahead and navigate.
        " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
        " other plugin before putting this into your config.
        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1):
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
        
        " Make <CR> to accept selected completion item or notify coc.nvim to format
        " <C-g>u breaks current undo, please make your own choice.
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
        
        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction
        
        " Use <c-space> to trigger completion.
        if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
        else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif
        
        " Use `[g` and `]g` to navigate diagnostics
        " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)
        
        " GoTo code navigation.
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
        
        " Use K to show documentation in preview window.
        nnoremap <silent> K :call ShowDocumentation()<CR>
        
        function! ShowDocumentation()
          if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
          else
            call feedkeys('K', 'in')
          endif
        endfunction
        
        " Highlight the symbol and its references when holding the cursor.
        autocmd CursorHold * silent call CocActionAsync('highlight')
        
        " Symbol renaming.
        nmap <leader>rn <Plug>(coc-rename)
        
        " Formatting selected code.
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)
        
        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder.
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end
        
        " Applying codeAction to the selected region.
        " Example: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)
        
        " Remap keys for applying codeAction to the current buffer.
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Apply AutoFix to problem on the current line.
        nmap <leader>qf  <Plug>(coc-fix-current)
        
        " Run the Code Lens action on the current line.
        nmap <leader>cl  <Plug>(coc-codelens-action)
        
        " Map function and class text objects
        " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)
        
        " Remap <C-f> and <C-b> for scroll float windows/popups.
        if has('nvim-0.4.0') || has('patch-8.2.0750')
          "nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif
        
        " Use CTRL-S for selections ranges.
        " Requires 'textDocument/selectionRange' support of language server.
        nmap <silent> <C-s> <Plug>(coc-range-select)
        xmap <silent> <C-s> <Plug>(coc-range-select)
        
        " Add `:Format` command to format current buffer.
        command! -nargs=0 Format :call CocActionAsync('format')
        
        " Add `:Fold` command to fold current buffer.
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)
        
        " Add `:OR` command for organize imports of the current buffer.
        command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
        
        " Add (Neo)Vim's native statusline support.
        " NOTE: Please see `:h coc-status` for integrations with external plugins that
        " provide custom statusline: lightline.vim, vim-airline.
        set statusline^=%{coc#status()}%{get(b:,'coc_current_function',\'\')}
        
        " Mappings for CoCList
        " Show all diagnostics.
        nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions.
        nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
        " Show commands.
        nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document.
        nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols.
        nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list.
        nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
        let g:airline#extensions#tabline#enabled = 0

        set termguicolors
        lua << EOF
        require("bufferline").setup{
          options= {
            mode = "buffers",
            indicator = { style = "icon", icon="▎"},
            buffer_close_icon = '',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            diagnostics = "coc",
            diagnostics_update_in_insert = false,
            separator_style = "slant"
          }
        }
        EOF

      '';
    packages.myVimPackage = with vimPlugins; {
      # see examples below how to use custom packages
      start = [ blamer vim-one coc-nvim vim-airline vim-airline-themes vim-nerdtree-syntax-highlight nerdtree-git-plugin fugitive vim-devicons salt-vim vim-terraform neomux rust-vim salt-vim vim-devicons coc-ansible vim-nix ansible-vim vim-go nerdtree syntastic fzf-vim bufferline-nvim vim-nix vim-nixhash ];
      opt = [ ];
    };
  };
}
