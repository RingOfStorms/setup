# nixos-rebuild switch --flake /etc/nixos#gpdPocket3
# Flake docs: https://nixos.wiki/wiki/Flakes
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11-small";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.gpdPocket3 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
