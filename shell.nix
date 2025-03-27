let
  pkgs = import <nixpkgs> {};
in

pkgs.mkShell {
  packages = with pkgs; [
    opam
    ];

  shellHook = ''
    opam init --bare -n 1>/dev/null 2>&1
    eval $(opam env)
  '';

  COLORTERM = "truecolor";
}
