{ nixpkgs, declInput }:

let pkgs = import <nixpkgs> {};
in {
  jobsets =
    let mkHydraSpec = platform: {
          name = platform;
          value = {
            enabled = 1;
            hidden = false;
            description = "";
            nixexprinput = "src";
            nixexprpath = "hydra/${platform}.nix";
            checkinterval = 300;
            schedulingshares = 100;
            enableemail = true;
            emailoverride = "";
            keepnr = 3;
            inputs = {
              nixpkgs = { type = "git"; value = "git://github.com/kitecomputing/nixpkgs.git kite"; emailresponsible = true; };
              src = { type = "git"; value = "git://github.com/kitecomputing/kite-system.git"; emailresponsible = true; };
            };
          };
        };

        hydraSpec = platforms: builtins.listToAttrs (map mkHydraSpec platforms);
        spec = hydraSpec [ "odroid-hc2" "qemu-x86_64" ];

    in pkgs.writeText "spec.json"
         (builtins.toJSON spec);
}
