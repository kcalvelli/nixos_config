{ lib
, stdenv
, makeWrapper
, imagemagick
, swaybg
}:

stdenv.mkDerivation {
  pname = "set-wallpaper-blur";
  version = "0.1.0";

  src = ./set-wallpaper-blur.sh;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/set-wallpaper-blur
    chmod +x $out/bin/set-wallpaper-blur

    wrapProgram $out/bin/set-wallpaper-blur \
      --prefix PATH : ${lib.makeBinPath [ imagemagick swaybg ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Script to set a blurred wallpaper for niri overview mode";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "set-wallpaper-blur";
  };
}
