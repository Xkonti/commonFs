# Package

version       = "0.1.0"
author        = "Beniamin Dudek aka Xkonti"
description   = "CommonFs is a file system abstraction for Nim that allows implementing interchangeable file system backends. In other words, you should be able to switch between OS file system, in-memory FS, SFTP, etc. without changing your code."
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 2.0.2"

# Tasks

task dev_uninstall, "Uninstall the package locally":
  try: exec r"nimble uninstall -i -y --silent commonFs"
  except: discard

task dev_install, "Reinstall the package locally":
  dev_uninstall_task()
  exec r"nimble install"

task regen_docs, "Regenerate the documentation":
  exec "nim doc --project --index:on --outdir:htmldocs src/commonFs.nim"
  exec "python3 -m http.server 7029 --directory htmldocs"