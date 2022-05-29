{ pkgs ? import <nixpkgs> { } }:

let
  neomux = pkgs.vimUtils.buildVimPlugin {
    name = "neomux";
    src = pkgs.fetchFromGitHub {
      owner = "nikvdp";
      repo = "neomux";
      rev = "7fa6754f3c781ca99fd533217443b1e4f86611d4";
      sha256 = "sha256-6Gr6/soyN5r+NRpDrFs9aT/assuQF9ydR3TfZnPlygI=";
    };
  };
  vim-devicons = pkgs.vimUtils.buildVimPlugin {
    name = "vim-devicons";
    src = pkgs.fetchFromGitHub {
      owner = "ryanoasis";
      repo = "vim-devicons";
      rev = "a2258658661e42dd4cdba4958805dbad1fe29ef4";
      sha256 = "sha256-bS1vUKzdzUZ1RYDbYWujF2z8EOd9o01/0VqMYUaNihA=";
      #sha256 = "0000000000000000000000000000000000000000000000000000";
    };
  };
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "d5f1f8641b24c0fd5b10a299824362a2a1b20ae0";
      sha256 = "sha256-AuJvZAQiHQjNIdgtc1Jb+sDrA1gFt+2D9IFcvbxs0ac=";
    };
  };
  coc-ansible = pkgs.vimUtils.buildVimPlugin {
    name = "coc-ansible";
    src = pkgs.fetchFromGitHub {
      owner = "yaegassy";
      repo = "coc-ansible";
      rev = "15fdc8503925427c6810a2da0b4c0c780a0d2c75";
      sha256 = "sha256-K7XtihHksv01x9j/faKRNzWn9nI9iomFYTFyYMO5QLc=";
    };
  };
in
pkgs.neovim.override {
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
        " set background=light " for the light version
        colorscheme one
        
        " Trigger NERDTree at startup if no file + map open shortcut
        nnoremap <silent> <C-k><C-B> :NERDTreeToggle<CR>
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
          \ 'coc-tsserver',
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
        set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
        set updatetime=300
        
        " don't give |ins-completion-menu| messages.
        set shortmess+=c
        
        " always show signcolumns
        set signcolumn=yes
        
        " Use tab for trigger completion with characters ahead and navigate.
        " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
        inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<TAB>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
        
        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction
        
        " Use <c-space> to trigger completion.
        inoremap <silent><expr> <c-space> coc#refresh()
        
        " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
        " Coc only does snippet and additional edit on confirm.
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        " Or use `complete_info` if your vim support it, like:
        " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
        
        " Use `[g` and `]g` to navigate diagnostics
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)
        
        " Remap keys for gotos
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
        
        " Use K to show documentation in preview window
        nnoremap <silent> K :call <SID>show_documentation()<CR>
        
        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          else
            call CocAction('doHover')
          endif
        endfunction
        
        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')
        
        " Remap for rename current word
        nmap <F2> <Plug>(coc-rename)
        
        " Remap for format selected region
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)
        
        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end
        
        " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)
        
        " Remap for do codeAction of current line
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Fix autofix problem of current line
        nmap <leader>qf  <Plug>(coc-fix-current)
        
        " Create mappings for function text object, requires document symbols feature of languageserver.
        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)
        
        " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
        nmap <silent> <C-d> <Plug>(coc-range-select)
        xmap <silent> <C-d> <Plug>(coc-range-select)
        
        " Use `:Format` to format current buffer
        command! -nargs=0 Format :call CocAction('format')
        
        " Use `:Fold` to fold current buffer
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)
        
        " use `:OR` for organize import of current buffer
        command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
        
        " Add status line support, for integration with other plugin, checkout `:h coc-status`
        
        " Using CocList
        " Show all diagnostics
        nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions
        nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
        " Show commands
        nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document
        nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols
        nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list
        nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

      '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      # see examples below how to use custom packages
      start = [ vim-one vim-nix nerdtree coc-nvim fzf vim-airline vim-airline-themes vim-nerdtree-syntax-highlight nerdtree-git-plugin fugitive vim-devicons salt-vim vim-terraform neomux rust-vim salt-vim vim-devicons coc-ansible ansible-vim ];
      opt = [ ];
    };
  };
}
