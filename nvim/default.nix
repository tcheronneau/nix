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
in
neovim.override {
  configure = {
    customRC = ./vimrc;
    packages.myVimPackage = with vimPlugins; {
      # see examples below how to use custom packages
      start = [ blamer vim-one coc-nvim vim-airline vim-airline-themes fugitive vim-devicons salt-vim vim-terraform neomux rust-vim salt-vim vim-devicons coc-ansible vim-nix ansible-vim vim-go syntastic fzf-vim bufferline-nvim vim-nix vim-nixhash nvim-web-devicons nvim-tree-lua ];
      opt = [ ];
    };
  };
}
