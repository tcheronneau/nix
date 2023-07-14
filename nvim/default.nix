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
      sha256 = "sha256-nFwaDcWB5zkdb9MZLdKRh7dQS5vxdQ0W7muKfPcKvwc=";
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
  vimrc = builtins.readFile ./vimrc;
in
neovim.override {
  configure = {
    customRC = vimrc; 
    packages.myVimPackage = with vimPlugins; {
      # see examples below how to use custom packages
      start = [ 
        blamer-nvim
        vim-one 
        fugitive 
        vim-devicons 
        salt-vim 
        vim-terraform 
        neomux 
        rust-vim 
        vim-devicons 
        ansible-vim 
        vim-go 
        syntastic 
        fzf-vim 
        bufferline-nvim 
        vim-nix 
        vim-nixhash 
        nvim-web-devicons 
        nvim-tree-lua 
        rust-tools-nvim 
        telescope-nvim 
        nvim-lspconfig 
        nvim-treesitter 
        nvim-cmp 
        cmp_luasnip
        cmp-nvim-lsp 
        luasnip 
        cmp-buffer 
        cmp-path
        neodev-nvim 
        vim-sleuth
        lualine-nvim
        gitsigns-nvim
        friendly-snippets
        barbar-nvim
        nvchad
      ];

      opt = [ ];
    };
  };
}
