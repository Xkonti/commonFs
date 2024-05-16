func getDirHandle*(self: FileSystem, path: Path): Dir =
  ## Returns a Dir object for the directory at the specified path, even if such directory does not exist.
  let absolutePath = path.absolutePath(self.currentDir)
  result = Dir(fs: self, absolutePath: absolutePath)


method createDirImpl(self: FileSystem, absolutePath: Path): Dir {.base, raises: [LibraryError, FileSystemError, InvalidPathError].} =
  raise newException(LibraryError, "Method createDir hasn't been implemented!")

proc createDir*(self: FileSystem, path: Path): Dir {.discardable.} =
  ## Creates a directory at the specified path. It does not raise an error if the directory already exists.
  ## If there is a file with the same name, it raises the ???Error.
  ## If succeeeded, it returns a File handle for the created file.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.createDirImpl(absolutePath)

proc create*(self: Dir) =
  ## Creates the directory. It does not raise an error if the directory already exists.
  ## If there is a file with the same name, it raises the ???Error.
  self.fs.createDir(self.absolutePath)


method dirExistsImpl(self: FileSystem, absolutePath: Path): bool {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method dirExists hasn't been implemented!")

proc dirExists*(self: FileSystem, path: Path): bool =
  ## Returns true if the directory at the specified path exists. If the path points to a file, it returns false.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.dirExistsImpl(absolutePath)

proc exists*(self: Dir): bool {.inline.} =
  ## Returns true if the directory exists. If the path points to a file, it returns false.
  return self.fs.dirExists(self.absolutePath)


method removeDirImpl(self: FileSystem, path: Path) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method removeDir hasn't been implemented!")

proc removeDir*(self: FileSystem, path: Path) =
  ## Removes the directory at the specified path. It does not raise an error if the directory does not exist.
  let absolutePath = self.getAbsolutePathTo(path)
  self.removeDirImpl(absolutePath)

proc remove*(self: Dir) {.inline.} =
  ## Removes the directory. It does not raise an error if the directory does not exist.
  self.fs.removeDir(self.absolutePath)