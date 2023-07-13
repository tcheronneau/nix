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
  vimrc = builtins.readFile ./vimrc;
in
neovim.override {
  configure = {
    customRC = vimrc; 
    packages.myVimPackage = with vimPlugins; {
      start = [ blamer-nvim vim-one vim-airline vim-airline-themes fugitive vim-devicons salt-vim vim-terraform neomux rust-vim salt-vim vim-devicons vim-nix ansible-vim vim-go syntastic fzf-vim bufferline-nvim vim-nix vim-nixhash nvim-web-devicons nvim-tree-lua rust-tools-nvim telescope-nvim mason-nvim nvim-lspconfig mason-lspconfig-nvim cmp-nvim-lsp nvim-treesitter nvim-cmp luasnip cmp-buffer neodev-nvim lualine-nvim gitsigns-nvim ];
      opt = [ ];
    };
  };
}
