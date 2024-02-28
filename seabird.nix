{ 
  buildGoModule, 
  fetchFromGitHub, 
  lib, 
  glib, 
  libxml2, 
  pkg-config, 
  libadwaita, 
  libglibutil, 
  vte-gtk4, 
  gtk4, 
  gtksourceview5, 
  gobject-introspection,
  pango,
  cairo,
  gdk-pixbuf,
  wrapGAppsHook,
}:

buildGoModule rec {
  pname = "seabird";
  version = "v0.1.0";
  src = fetchFromGitHub {
    owner = "getseabird";
    repo = "seabird";
    rev = "${version}";
    hash = "sha256-HHUqpt3DrwKovxa/lEOMqvZMABLFKNq9h90XdKQ7s3s=";
  };

  preBuild = ''
    go generate ./...
  '';
  vendorHash = "sha256-YKel/JmEbL3E9xA/V+pMEv2Hb1wAPU4FfYd9zPiBm+I=";
  checkPhase = "";
  buildInputs = [ 
    glib 
    libxml2 
    pkg-config 
    glib 
    libxml2 
    pkg-config 
    libadwaita 
    libglibutil 
    vte-gtk4 
    gtk4 
    gtksourceview5
    gobject-introspection 
    pango
    cairo
    gdk-pixbuf
  ];
  nativeBuildInputs = [ 
    glib 
    libxml2 
    pkg-config 
    glib 
    libxml2 
    pkg-config 
    libadwaita 
    libglibutil 
    vte-gtk4 
    gtk4 
    gtksourceview5
    gobject-introspection 
    pango
    cairo
    gdk-pixbuf
    wrapGAppsHook
  ];


  meta = with lib; {
    homepage = "https://getseabird.github.io/";
    changelog = "https://github.com/getseabird/seabird/blob/${src.rev}/CHANGELOG.md";
    description = "Native Kubernetes desktop client.";
    platforms = platforms.linux; 
    license = licenses.bsd2;
    maintainers = with maintainers; [ "tcheronneau" ];
  };
}
