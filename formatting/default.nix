{
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = {pkgs, ...}: {
    treefmt.config = {
      projectRootFile = ".git/config";
      programs.alejandra.enable = true;
      settings.formatter.clang-format = {
        command = "${pkgs.clang-tools}/bin/clang-format";
        includes = ["*.cpp"];
      };
    };
  };
}
