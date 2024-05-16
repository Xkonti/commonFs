func getFileHandle*(self: FileSystem, path: Path): File =
  ## Returns a File object for the file at the specified path, even if such file does not exist.
  let absolutePath = path.absolutePath(self.currentDir)
  result = File(fs: self, absolutePath: absolutePath)


method createFileImpl(self: FileSystem, absolutePath: Path): File {.base, raises: [LibraryError, FileSystemError, InvalidPathError].} =
  raise newException(LibraryError, "Method createFile hasn't been implemented!")

proc createFile*(self: FileSystem, path: Path): File {.discardable.} =
  ## Creates an empty file at the specified path. It does not raise an error if the file already exists.
  ## If the directory in which the file should be created does not exist, it raises the FileSystemError.
  ## If succeeeded, it returns a File handle for the created file.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.createFileImpl(absolutePath)

proc create*(self: File) =
  ## Creates an empty file at the path of the file handle. It does not raise an error if the file already exists.
  ## If the directory in which the file should be created does not exist, it raises the FileSystemError.
  self.fs.createFile(self.absolutePath)


method fileExistsImpl(self: FileSystem, absolutePath: Path): bool {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method fileExists hasn't been implemented!")

proc fileExists*(self: FileSystem, path: Path): bool =
  ## Returns true if the file at the specified path exists. If the path points to a directory, it returns false.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.fileExistsImpl(absolutePath)

proc exists*(self: File): bool {.inline.} =
  ## Returns true if the file exists. If the path points to a directory, it returns false.
  return self.fs.fileExists(self.absolutePath)


method removeFileImpl(self: FileSystem, absolutePath: Path) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method removeFile hasn't been implemented!")

proc removeFile*(self: FileSystem, path: Path) =
  ## Removes the file at the specified path. It does not raise an error if the file does not exist.
  let absolutePath = self.getAbsolutePathTo(path)
  self.removeFileImpl(absolutePath)

proc remove*(self: File) {.inline.} =
  ## Removes the file. It does not raise an error if the file does not exist.
  self.fs.removeFile(self.absolutePath)