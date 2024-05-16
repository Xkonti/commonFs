method writeImpl(self: FileSystem, path: Path, bytes: openArray[byte]) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method write hasn't been implemented!")

proc write*(self: FileSystem, path: Path, bytes: openArray[byte]) =
  ## Writes the provided array of bytes to the file at the specified path.
  ## If the file does not exist, it will be created.
  let absolutePath = self.getAbsolutePathTo(path)
  self.writeImpl(absolutePath, bytes)

# TODO: TEST
proc write*(self: File, content: openArray[byte]) =
  ## Writes the provided content to the file.
  ## If the file does not exist, it will be created.
  self.fs.write(self.absolutePath, content)