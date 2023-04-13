{
  description = "Ikea's Trotten motorized";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    mission-control.url = "github:Platonic-Systems/mission-control";
    flake-root.url = "github:srid/flake-root";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      imports = [
        ./shell
        ./formatting
        ./firmware
        ./support
      ];
      systems = ["x86_64-linux" "aarch64-linux"];
    });

  nixConfig.sandbox = "relaxed";
}
