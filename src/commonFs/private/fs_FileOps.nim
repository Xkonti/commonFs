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


method fileExistsImpl(self: FileSystem, absolutePath: Path): bool {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method fileExists hasn't been implemented!")

proc fileExists*(self: FileSystem, path: Path): bool =
  ## Returns true if the file at the specified path exists. If the path points to a directory, it returns false.
  let absolutePath = self.getAbsolutePathTo(path)
  return self.fileExistsImpl(absolutePath)


method removeFileImpl(self: FileSystem, absolutePath: Path) {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method removeFile hasn't been implemented!")

proc removeFile*(self: FileSystem, path: Path) =
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


method readStringBufferImpl(self: FileSystem, absolutePath: Path, buffer: var string, start: int64, length: int64): int {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readStringBuffer hasn't been implemented!")

proc readString*(self: FileSystem, path: Path, buffer: var string, start: int64, length: int64): int =
  ## Reads the content of the file into the specified byte buffer starting at the specified index.
  ## Returns the number of characters read.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readStringBufferImpl(absolutePath, buffer, start, length)


type StringBufferedIterator* = iterator(buffer: var string): int

method getStringBufferedIteratorImpl(self: FileSystem, absolutePath: Path, buffer: var string, start: int64, length: int64): StringBufferedIterator {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method getStringBufferedIteratorImpl hasn't been implemented!")

iterator readStringBuffered*(self: FileSystem,  path: Path, buffer: var string, start: int64, length: int64): int =
  ## Iterator that reads the content of the file buffer-by-buffer
  ## Returns the number of characters read while the data is available in the buffer.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  let iter = self.getStringBufferedIteratorImpl(absolutePath, buffer, start, length)
  for i in iter(buffer):
    yield i


method readBytesImpl(self: FileSystem, absolutePath: Path): seq[byte] {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readBytes hasn't been implemented!")

proc readBytes*(self: FileSystem, path: Path): seq[byte] =
  ## Reads the content of the file at the specified path and returns it as a sequence of bytes.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readBytesImpl(absolutePath)


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