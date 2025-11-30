# save this as shell.nix
{ pkgs ? import <nixpkgs> {}}:
let
  AlgorithmCombinatorics = pkgs.perlPackages.buildPerlPackage {
    pname = "Algorithm-Combinatorics";
    version = "0.27";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/F/FX/FXN/Algorithm-Combinatorics-0.27.tar.gz";
      hash = "sha256-g3jaOezbN9XMicwTCjsTU/111Wx2kJBWc0c/5MJc0TI=";
    };
    meta = {
      description = "Efficient generation of combinatorial sequences";
    };
  };
  ListPriorityQueue = pkgs.perlPackages.buildPerlModule {
    pname = "List-PriorityQueue";
    version = "0.01";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PENMA/List-PriorityQueue-0.01.tar.gz";
      hash = "sha256-0RvG5Fd68A44TmpRYXXYb7se7KmMgGsvHyuU468g98g=";
    };
    meta = {
      description = "High performance priority list (pure perl)";
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };
  POEXSQueueArray = pkgs.perlPackages.buildPerlPackage {
    pname = "POE-XS-Queue-Array";
    version = "0.006";
    src = pkgs.fetchurl {
      url = "mirror://cpan/authors/id/T/TO/TONYC/POE-XS-Queue-Array-0.006.tar.gz";
      hash = "sha256-cEAFY1r8eb5fzk0WRlLr+ye3nBA0v74J1BbvuAiBlUs=";
    };
    propagatedBuildInputs = [ pkgs.perlPackages.POE ];
    meta = {
      description = "XS version of POE::Queue::Array";
      license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

in
pkgs.mkShell {
  packages = with pkgs; [
    pcre.dev
    gmp.dev
    boost

    nim
    (perl.withPackages (p: [
      p.CarpAlways
      p.DBFile
      p.Graph
      p.HTMLTree
      p.Inline
      p.JSON
      p.ListMoreUtils
      p.LWP
      p.LWPProtocolHttps
      p.MathPrimeUtil
      POEXSQueueArray
      AlgorithmCombinatorics
      ListPriorityQueue
    ]))

    (haskellPackages.ghcWithPackages (pkgs: [ pkgs.criterion ]))

    rakudo

    go_1_25
    gopls

    elixir
    elixir-ls

    crystal
  ];
  shellHook = ''
    PATH=$PATH:$PWD/bin; export PATH
  '';
}
