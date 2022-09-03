# Package

version       = "0.0.6"
author        = "Kaushal Modi"
description   = "Wrapper for SystemVerilog VPI headers vpi_user.h and sv_vpi_user.h"
license       = "MIT"
# Wed May 12 22:46:45 EDT 2021 - kmodi
# I cannot put all the code under an src/ directory otherwise I get
# prompts on each "nimble install" -- https://github.com/nim-lang/nimble/issues/582#issuecomment-840248300
# srcDir        = "src"
installFiles  = @["svvpi.nim"]
installDirs   = @["includes", "svvpi", "sv"]

# Dependencies

requires "nim >= 1.4.6", "nimterop >= 0.6.13"
