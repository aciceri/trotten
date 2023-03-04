{
  config.perSystem = {pkgs, ...}: {
    packages = {
      support = pkgs.runCommand "support.stl" {} ''
        ${pkgs.openscad}/bin/openscad ${./support.scad} -o $out
      '';
    };
  };
}
