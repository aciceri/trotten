{inputs, ...}: {
  imports = [
    inputs.mission-control.flakeModule
    inputs.flake-root.flakeModule
  ];
  perSystem = {
    pkgs,
    config,
    self',
    ...
  }: {
    mission-control = {
      banner = with config.mission-control; ''
        ${pkgs.toilet}/bin/toilet --gay Trotten
        ${config.mission-control.wrapper}/bin/${config.mission-control.wrapperName}
        echo
        echo "(Run '${wrapperName}' to display this menu again)"
      '';
      scripts = {
        fmt = {
          description = "Format everything using treefmt";
          exec = "${self'.formatter}/bin/treefmt";
        };
        build-firmware = {
          description = "Build the firmware";
          exec = ''nix build .#firmware && echo "Built: $(readlink ./result)"'';
        };
      };
    };
    devShells.default = let
      shell = pkgs.mkShell {
        name = "trotten-dev-shell";
        buildInputs = with pkgs; [
          platformio
          curl
          openscad
        ];
      };
    in
      config.mission-control.installToDevShell shell;
    checks = {
      hello = pkgs.runCommand "test-${pkgs.system}" {} ''
        echo "ciao" > $out
      '';
    };
  };
}
