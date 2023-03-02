{
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = {
    treefmt.config = {
      projectRootFile = self;
      programs.alejandra.enable = true;
    };
  };
}
