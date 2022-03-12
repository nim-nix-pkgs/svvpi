{
  description = ''Wrapper for SystemVerilog VPI headers vpi_user.h and sv_vpi_user.h'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-svvpi-v0_0_5.flake = false;
  inputs.src-svvpi-v0_0_5.owner = "kaushalmodi";
  inputs.src-svvpi-v0_0_5.ref   = "refs/tags/v0.0.5";
  inputs.src-svvpi-v0_0_5.repo  = "nim-svvpi";
  inputs.src-svvpi-v0_0_5.type  = "github";
  
  inputs."nimterop".dir   = "nimpkgs/n/nimterop";
  inputs."nimterop".owner = "riinr";
  inputs."nimterop".ref   = "flake-pinning";
  inputs."nimterop".repo  = "flake-nimble";
  inputs."nimterop".type  = "github";
  inputs."nimterop".inputs.nixpkgs.follows = "nixpkgs";
  inputs."nimterop".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-svvpi-v0_0_5"];
  in lib.mkRefOutput {
    inherit self nixpkgs ;
    src  = deps."src-svvpi-v0_0_5";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  };
}