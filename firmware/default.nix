{inputs, ...}: {
  imports = [
  ];
  perSystem = {
    pkgs,
    ...
  }: {
    packages.default = pkgs.hello;
  };
}

