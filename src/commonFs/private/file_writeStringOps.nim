method writeImpl(self: FileSystem, absolutePath: Path, content: varargs[string, `$`]) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method write hasn't been implemented!")

proc write*(self: FileSystem, path: Path, content: varargs[string, `$`]) =
  ## Writes the provided content to the file at the specified path.
  ## If the file does not exist, it will be created.
  let absolutePath = self.getAbsolutePathTo(path)
  self.writeImpl(absolutePath, content)

proc write*(self: File, content: varargs[string, `$`]) =
  ## Writes the provided content to the file.
  ## If the file does not exist, it will be created.
  self.fs.write(self.absolutePath, content)