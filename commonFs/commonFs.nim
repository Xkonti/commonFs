import std/paths

type
  FileSystem* = ref object of RootObj
    currentAbsoluteDir: Path = "/".Path
  
  File* = ref object of RootObj
    fs: FileSystem
    absolutePath: Path

  FileSystemError* = object of CatchableError ## \
    ## Raised if there is something wrong with the file system,
    ## e.g. OS partition is no longer available, SFTP connection
    ## can't be established, etc.
  
  InvalidPathError* = object of CatchableError ## \
    ## Raised if the provided path is invalid, e.g. contains
    ## forbidden characters, is too long, etc.

#[
  FILESYSTEM: CURRENT DIRECTORY OPERATIONS
]#

func currentDir*(self: FileSystem): Path = ## \
  ## Returns the current "working" directory. The working directory is always an absolute path.
  return self.currentAbsoluteDir

proc `currentDir=`*(self: FileSystem, path: Path) = ## \
  ## Sets the current "working" directory. If provided path is relative, it is resolved against the current directory.
  try:
    self.currentAbsoluteDir = path.absolutePath(self.currentAbsoluteDir)
  except ValueError as e:
      raise newException(InvalidPathError, e.msg, e)

func getAbsolutePathTo*(self: FileSystem, path: Path): Path {.raises: [InvalidPathError].} = ## \
  ## Returns the absolute path to the provided path. If the provided path is already absolute, it is returned as is.
  try:
    return path.absolutePath(self.currentDir)
  except ValueError as e:
      raise newException(InvalidPathError, e.msg, e)

#[
  FILESYSTEM: DIRECTORY OPERATIONS
]#

method createDirImpl(self: FileSystem, absolutePath: Path) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method createDir hasn't been implemented!")

proc createDir*(self: FileSystem, path: Path) = ## \
  ## Creates a directory at the specified path. It does not raise an error if the directory already exists.
  let absolutePath = self.getAbsolutePathTo(path)
  self.createDirImpl(absolutePath)

method dirExistsImpl(self: FileSystem, absolutePath: Path): bool {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method dirExists hasn't been implemented!")

proc dirExists*(self: FileSystem, path: Path): bool = ## \
  ## Returns true if the directory at the specified path exists. If the path points to a file, it returns false.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.dirExistsImpl(absolutePath)

method removeDirImpl(self: FileSystem, path: Path) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method removeDir hasn't been implemented!")

proc removeDir*(self: FileSystem, path: Path) = ## \
  ## Removes the directory at the specified path. It does not raise an error if the directory does not exist.
  let absolutePath = self.getAbsolutePathTo(path)
  self.removeDirImpl(absolutePath)

#[
  FILESYSTEM: FILE OPERATIONS
]#

func getFileHandle*(self: FileSystem, path: Path): File = ## \
  ## Returns a File object for the file at the specified path, even if such file does not exist.
  let absolutePath = path.absolutePath(self.currentDir)
  result = File(fs: self, absolutePath: absolutePath)

method createFileImpl(self: FileSystem, absolutePath: Path): File {.base, raises: [LibraryError, FileSystemError, InvalidPathError].} =
  raise newException(LibraryError, "Method createFile hasn't been implemented!")

proc createFile*(self: FileSystem, path: Path): File {.discardable.} = ## \
  ## Creates an empty file at the specified path. It does not raise an error if the file already exists.
  ## If the directory in which the file should be created does not exist, it raises the FileSystemError.
  ## If succeeeded, it returns a File object for the created file.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.createFileImpl(absolutePath)

method fileExistsImpl(self: FileSystem, absolutePath: Path): bool {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method fileExists hasn't been implemented!")

proc fileExists*(self: FileSystem, path: Path): bool = ## \
  ## Returns true if the file at the specified path exists. If the path points to a directory, it returns false.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.fileExistsImpl(absolutePath)

method removeFileImpl(self: FileSystem, absolutePath: Path) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method removeFile hasn't been implemented!")

proc removeFile*(self: FileSystem, path: Path) = ## \
  ## Removes the file at the specified path. It does not raise an error if the file does not exist.
  let absolutePath = self.getAbsolutePathTo(path)
  self.removeFileImpl(absolutePath)






#[
  FILE: OPERATIONS
]#

proc exists*(self: File): bool = ## \
  ## Returns true if the file exists. If the path points to a directory, it returns false.
  return self.fs.fileExists(self.absolutePath)

proc remove*(self: File) = ## \
  ## Removes the file. It does not raise an error if the file does not exist.
  self.fs.removeFile(self.absolutePath)