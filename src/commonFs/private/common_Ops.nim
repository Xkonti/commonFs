proc fs*(self: Dir | File): FileSystem {.inline.} =
  ## Returns the FileSystem object the handle belongs to.
  return self.fs

proc absolutePath*(self: Dir | File): Path {.inline.} =
  ## Returns the absolute path the provided handle points to.
  return self.absolutePath

proc parent*(self: Dir | File): Option[Dir] =
  ## Returns the parent directory of the directory or file.
  ## If the provided path is the root directory, it returns none.
  let path = self.absolutePath
  if path.isRootDir:
    return none Dir
  return some self.fs.getDirHandle path.parentDir