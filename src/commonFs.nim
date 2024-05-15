import std/paths
import std/options

type
  FileSystem* = ref object of RootObj
    currentAbsoluteDir: Path = "/".Path

  Dir* = ref object of RootObj
    fs: FileSystem
    absolutePath: Path
  
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

func getDirHandle*(self: FileSystem, path: Path): Dir = ## \
  ## Returns a Dir object for the directory at the specified path, even if such directory does not exist.
  let absolutePath = path.absolutePath(self.currentDir)
  result = Dir(fs: self, absolutePath: absolutePath)

method createDirImpl(self: FileSystem, absolutePath: Path): Dir {.base, raises: [LibraryError, FileSystemError, InvalidPathError].} =
  raise newException(LibraryError, "Method createDir hasn't been implemented!")

proc createDir*(self: FileSystem, path: Path): Dir {.discardable.} = ## \
  ## Creates a directory at the specified path. It does not raise an error if the directory already exists.
  ## If there is a file with the same name, it raises the ???Error.
  ## If succeeeded, it returns a File handle for the created file.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.createDirImpl(absolutePath)

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
  ## If succeeeded, it returns a File handle for the created file.
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

method readStringAllImpl(self: FileSystem, absolutePath: Path): string {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readStringAll hasn't been implemented!")

proc readString*(self: FileSystem, path: Path): string =
  ## Reads the content of the file at the specified path and returns it as a string.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readStringAllImpl(absolutePath)

# TODO
method readStringBufferImpl(self: FileSystem, absolutePath: Path, buffer: var string, start: int64, length: int64): int {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readStringBuffer hasn't been implemented!")

proc readString*(self: FileSystem, path: Path, buffer: var string, start: int64, length: int64): int =
  ## Reads the content of the file into the specified byte buffer starting at the specified index.
  ## Returns the number of characters read.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readStringBufferImpl(absolutePath, buffer, start, length)

type StringBufferedIterator* = iterator(self: FileSystem, absolutePath: Path, buffer: var string, start: int64, length: int64): int

method getStringBufferedIteratorImpl(self: FileSystem, absolutePath: Path, buffer: var string, start: int64, length: int64): StringBufferedIterator {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method getStringBufferedIteratorImpl hasn't been implemented!")

iterator readStringBuffered*(self: FileSystem,  path: Path, buffer: var string, start: int64, length: int64): int =
  ## Iterator that reads the content of the file buffer-by-buffer
  ## Returns the number of characters read while the data is available in the buffer.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  let iter = self.getStringBufferedIteratorImpl(absolutePath, buffer, start, length)
  for i in iter(self, absolutePath, buffer, start, length):
    yield i

method readBytesImpl(self: FileSystem, absolutePath: Path): seq[byte] {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readBytes hasn't been implemented!")

proc readBytes*(self: FileSystem, path: Path): seq[byte] =
  ## Reads the content of the file at the specified path and returns it as a sequence of bytes.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readBytesImpl(absolutePath)

# TODO
method readBytesImpl(self: FileSystem, absolutePath: Path, buffer: var openArray[byte], start: int64, length: int64): int64 {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readBytes hasn't been implemented!")

proc readBytes*(self: FileSystem, path: Path, buffer: var openArray[byte], start: int64, length: int64): int64 =
  ## Reads the content of the file into the specified byte buffer starting at the specified index.
  ## Returns the number of bytes read.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readBytesImpl(absolutePath, buffer, start, length)

method writeImpl(self: FileSystem, absolutePath: Path, content: varargs[string, `$`]) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method write hasn't been implemented!")

proc write*(self: FileSystem, path: Path, content: varargs[string, `$`]) =
  ## Writes the provided content to the file at the specified path.
  ## If the file does not exist, it will be created.
  let absolutePath = self.getAbsolutePathTo(path)
  self.writeImpl(absolutePath, content)

method writeImpl(self: FileSystem, path: Path, bytes: openArray[byte]) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method write hasn't been implemented!")

proc write*(self: FileSystem, path: Path, bytes: openArray[byte]) =
  ## Writes the provided array of bytes to the file at the specified path.
  ## If the file does not exist, it will be created.
  let absolutePath = self.getAbsolutePathTo(path)
  self.writeImpl(absolutePath, bytes)

#[
  DIR / FILE: SHARED OPERATIONS
]#

proc fs*(self: Dir | File): FileSystem {.inline.} = ## \
  ## Returns the FileSystem object the handle belongs to.
  return self.fs

proc absolutePath*(self: Dir | File): Path {.inline.} = ## \
  ## Returns the absolute path the provided handle points to.
  return self.absolutePath

proc parent*(self: Dir | File): Option[Dir] =
  ## Returns the parent directory of the directory or file.
  ## If the provided path is the root directory, it returns none.
  let path = self.absolutePath
  if path.isRootDir:
    return none Dir
  return some self.fs.getDirHandle path.parentDir

#[
  DIR: OPERATIONS
]#

proc name*(self: Dir): string {.inline.} = ## \
  ## Returns the name of the directory.
  let path = self.absolutePath
  if path.isRootDir:
    return "/"
  return path.lastPathPart.string

proc exists*(self: Dir): bool {.inline.} = ## \
  ## Returns true if the directory exists. If the path points to a file, it returns false.
  return self.fs.dirExists(self.absolutePath)

proc remove*(self: Dir) {.inline.} = ## \
  ## Removes the directory. It does not raise an error if the directory does not exist.
  self.fs.removeDir(self.absolutePath)

#[
  FILE: OPERATIONS
]#

proc name*(self: File): string {.inline.} = ## \
  ## Returns the name of the file excluding the extension.
  let (_, name, _) = self.absolutePath.splitFile()
  return name.string

proc ext*(self: File): string {.inline.} = ## \
  ## Returns the extension of the file (withouth dot).
  let (_, _, ext) = self.absolutePath.splitFile()
  return ext

proc filename*(self: File): string {.inline.} = ## \
  ## Returns the name of the file including the extension.
  
  let (_, name, ext) = self.absolutePath.splitFile()
  return name.string & ext

proc exists*(self: File): bool {.inline.} = ## \
  ## Returns true if the file exists. If the path points to a directory, it returns false.
  return self.fs.fileExists(self.absolutePath)

proc remove*(self: File) {.inline.} = ## \
  ## Removes the file. It does not raise an error if the file does not exist.
  self.fs.removeFile(self.absolutePath)

proc readString*(self: File): string =
  ## Reads the content of the file and returns it as a string.
  ## If the file does not exist, it raises the FileSystemError.
  self.fs.readString(self.absolutePath)

proc readBytes*(self: File): seq[byte] =
  ## Reads the content of the file and returns it as a sequence of bytes.
  ## If the file does not exist, it raises the FileSystemError.
  self.fs.readBytes(self.absolutePath)

proc write*(self: File, content: varargs[string, `$`]) = ## \
  ## Writes the provided content to the file .
  ## If the file does not exist, it will be created.
  self.fs.write(self.absolutePath, content)