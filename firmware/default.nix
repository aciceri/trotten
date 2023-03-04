{
  inputs,
  config,
  lib,
  ...
}: {
  options.firmware = {
    ssid = lib.mkOption {
      type = lib.types.str;
      default = builtins.trace ''
        Using the default WiFi SSID
        Remember to set it with firmware.ssid
      '' "My WiFi network";
    };
    password = lib.mkOption {
      type = lib.types.str;
      default = builtins.trace ''
        Using the default WiFi password
        Remember to set it with firmware.password
      '' "My WiFi password";
    };
  };
  config.perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages = {
      firmware = pkgs.stdenv.mkDerivation {
        __noChroot = true;
        name = "trotten-firmware";
        src = pkgs.runCommand "trotten-firmware-src" {} ''
          mkdir $out
          ln -s ${./main.cpp} $out/main.cpp
          ln -s ${./platformio.ini} $out/platformio.ini
          cat > $out/secrets.h << EOF
          #define SSID "${config.firmware.ssid}"
          #define PASSWORD "{config.firmware.password}"
          EOF
        '';
        nativeBuildInputs = with pkgs; [
          platformio
        ];
        buildPhase = ''PLATFORMIO_BUILD_DIR="$out" pio run'';
        dontInstall = true;
      };
      default = self'.packages.firmware;
      flash = pkgs.writeShellApplication {
        name = "flash-firmware";
        runtimeInputs = with pkgs; [
          platformio
          busybox
        ];
        text = ''
          TMPDIR=$(mktemp -d)
          cp -r ${self'.packages.firmware}/* "$TMPDIR"
          pio run -t nobuild -t upload -d "$TMPDIR"
        '';
      };
    };
  };
}
