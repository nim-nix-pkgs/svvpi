task wrap, "Generate Nim wrapper using Nimterop":
  exec("nim c -d:svGenWrapper --verbosity:0 --app:lib svvpi.nim > wrapper/svvpi_wrapper.nim")
  # Remove the actual path to svvpi.h.
  exec(r"sed -ri 's|/[^ ]+/([^/]+\.h)|/path/to/\1|g' wrapper/svvpi_wrapper.nim")
  # Remove the time stamp to reduce commit noise.
  exec(r"sed -ri '/Generated @/d' wrapper/svvpi_wrapper.nim")
  # Remove the "Saved to .." comment.
  exec(r"sed -ri '/^# Saved to/d' wrapper/svvpi_wrapper.nim")
