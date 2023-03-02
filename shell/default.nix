{inputs, ...}: {
  imports = [
    inputs.mission-control.flakeModule
    inputs.flake-root.flakeModule
  ];
  perSystem = {
    pkgs,
    config,
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
        hello = {
          description = "Say hello";
          exec = "${pkgs.hello}/bin/hello";
        };
      };
    };
    devShells.default = let
      shell = pkgs.mkShell {
        name = "trotten-dev-shell";
        buildInputs = with pkgs; [
          platformio
        ];
      };
    in
      config.mission-control.installToDevShell shell;
  };
}
