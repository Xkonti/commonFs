import std/paths
import fs
import dir
import file
import std/options


proc fs*(self: Dir | file.File): FileSystem {.inline.} = ## \
  ## Returns the FileSystem object the handle belongs to.
  return self.priv_fs

proc absolutePath*(self: Dir | file.File): Path {.inline.} = ## \
  ## Returns the absolute path the provided handle points to.
  return self.priv_absolutePath

proc parent*(self: Dir | file.File): Option[Dir] =
  ## Returns the parent directory of the directory or file.
  ## If the provided path is the root directory, it returns none.
  let path = self.priv_absolutePath
  if path.isRootDir:
    return none Dir
  return some self.priv_fs.getDirHandle path.parentDir