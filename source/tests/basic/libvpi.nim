import svvpi

vpiDefine task hello:
  ## This says "Hello!"
  calltf:
    vpiEcho("Hello!")

vpiDefine task bye:
  ## This says "Bye!"
  calltf:
    vpiEcho("Bye!")

vpiDefine function do_nothing:
  ## This doesn't do anything, really.
  compiletf: discard
  calltf: discard
  sizetf: 1
  userdata: "foo"

# Register the tasks.
setVlogStartupRoutines(hello, bye, do_nothing)
