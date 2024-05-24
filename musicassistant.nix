{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "server";
  version = "2.0.4";
  format = "other";

  propagatedBuildInputs = with python3.pkgs; [
    brotli
    aiodns
    aiofiles
    aiohttp
    aiorun
    aioslimproto
    aiosqlite
    async-upnp-client
    asyncio-throttle
    certifi
    colorlog
    cryptography
    deezer-python-async
    defusedxml
    faust-cchardet
    hass-client
    ifaddr
    jellyfin_apiclient_python
    mashumaro
    memory-tempfile
    music-assistant-frontend
    orjson
    pillow
    plexapi
    py-opensonic
    PyChromecast
    pycryptodome
    python-fullykiosk
    python-slugify
    radios
    shortuuid
    snapcast
    soco
    sonos-websocket
    soundcloudpy
    tidalapi
    unidecode
    xmltodict
    ytmusicapi
    zeroconf
  ];

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "";
  };


  meta  = with lib; {
    description = " Music Assistant is a free, opensource Media library manager that connects to your streaming services and a wide range of connected speakers. The server is the beating heart, the core of Music Assistant and must run on an always-on device like a Raspberry Pi, a NAS or an Intel NUC or alike. ";
    homepage = "https://github.com/music-assistant/server";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tcheronneau ];
  };
}

