import std/paths

type
  FileSystem* = ref object of RootObj

  FileSystemError* = object of CatchableError ## \
    ## Raised if there is something wrong with the file system,
    ## e.g. OS partition is no longer available, SFTP connection
    ## can't be established, etc.

method createDir*(self: FileSystem, path: Path) {.base, raises: [LibraryError, FileSystemError].} = ## \
  ## Creates a directory at the specified path. It does not raise an error if the directory already exists.
  raise newException(LibraryError, "Method createDir hasn't been implemented!")

method dirExists*(self: FileSystem, path: Path): bool {.base, raises: [LibraryError, FileSystemError].} = ## \
  ## Returns true if the directory at the specified path exists. If the path points to a file, it returns false.
  raise newException(LibraryError, "Method dirExists hasn't been implemented!")

method removeDir*(self: FileSystem, path: Path) {.base, raises: [LibraryError, FileSystemError].} = ## \
  ## Removes the directory at the specified path. It does not raise an error if the directory does not exist.
  raise newException(LibraryError, "Method removeDir hasn't been implemented!")