import std/paths

import dir
import fsDirOps

proc name*(self: Dir): string {.inline.} =
  ## Returns the name of the directory.
  let path = self.priv_absolutePath
  if path.isRootDir:
    return "/"
  return path.lastPathPart.string

proc exists*(self: Dir): bool {.inline.} =
  ## Returns true if the directory exists. If the path points to a file, it returns false.
  return self.priv_fs.dirExists(self.priv_absolutePath)

proc remove*(self: Dir) {.inline.} =
  ## Removes the directory. It does not raise an error if the directory does not exist.
  self.priv_fs.removeDir(self.priv_absolutePath)