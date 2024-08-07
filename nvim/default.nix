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
  pets = vimUtils.buildVimPlugin {
    pname = "pets.nvim";
    version = "latest";
    src = fetchFromGitHub {
      owner = "giusgad";
      repo = "pets.nvim";
      rev = "94b4724e031fc3c9b6da19bdef574f44fabcca16";
      sha256 = "sha256-CtBCiTo26cTU+q/67QSrondNeyoAdVuIXMHZnxHMIm4=";
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
        catppuccin-nvim
        onedarkpro-nvim
        vim-code-dark
        rose-pine
        pets
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
        nvim-treesitter-parsers.bash
        nvim-treesitter-parsers.python
        nvim-treesitter-parsers.rust
        nvim-treesitter-parsers.nix
        nvim-treesitter-parsers.terraform
        nvim-treesitter-parsers.go
        nvim-treesitter-parsers.yaml
        nvim-treesitter-parsers.json
        nvim-treesitter-parsers.dockerfile
      ];

      opt = [ ];
    };
  };
}
