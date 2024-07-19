self: super:

{
  protonmail-desktop = super.protonmail-desktop.overrideAttrs (old: rec {
    name = "protonmail-desktop-runtime-${version}";
    version = "1.0.5";
    src =
      {
        "x86_64-linux" = super.fetchurl {
          url = "https://github.com/ProtonMail/inbox-desktop/releases/download/${version}/proton-mail_${version}_amd64.deb";
          hash = "sha256-En5vkTHYtwN6GMgbtyhzsPqknOPRO9KlTqZfbBFaIFQ=";
        };
      }
      .${super.stdenv.hostPlatform.system};
    });
}
