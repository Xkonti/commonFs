proc name*(self: Dir): string {.inline.} =
  ## Returns the name of the directory.
  let path = self.absolutePath
  if path.isRootDir:
    return "/"
  return path.lastPathPart.string

proc exists*(self: Dir): bool {.inline.} =
  ## Returns true if the directory exists. If the path points to a file, it returns false.
  return self.fs.dirExists(self.absolutePath)

proc remove*(self: Dir) {.inline.} =
  ## Removes the directory. It does not raise an error if the directory does not exist.
  self.fs.removeDir(self.absolutePath)