method readStringAllImpl(self: FileSystem, absolutePath: Path): string {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readStringAll hasn't been implemented!")

proc readString*(self: FileSystem, path: Path): string =
  ## Reads the content of the file at the specified path and returns it as a string.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readStringAllImpl(absolutePath)

proc readString*(self: File): string =
  ## Reads the content of the file and returns it as a string.
  ## If the file does not exist, it raises the FileSystemError.
  self.fs.readString(self.absolutePath)


method readStringBufferImpl(self: FileSystem, absolutePath: Path, buffer: var string, start: int64, length: int64): int {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readStringBuffer hasn't been implemented!")

proc readString*(self: FileSystem, path: Path, buffer: var string, start: int64, length: int64): int =
  ## Reads the content of the file into the specified byte buffer starting at the specified index.
  ## Returns the number of characters read.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readStringBufferImpl(absolutePath, buffer, start, length)

proc readString*(self: File, buffer: var string, start: int64, length: int64): int =
  ## Reads the content of the file into the specified byte buffer starting at the specified index.
  ## Returns the number of characters read.
  ## If the file does not exist, it raises the FileSystemError.
  self.fs.readString(self.absolutePath, buffer, start, length)


type StringBufferedIterator* = iterator(buffer: var string): int

method getStringBufferedIteratorImpl(self: FileSystem, absolutePath: Path, buffer: var string, start: int64, length: int64): StringBufferedIterator {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method getStringBufferedIteratorImpl hasn't been implemented!")

iterator readStringBuffered*(self: FileSystem, path: Path, buffer: var string, start: int64, length: int64): int =
  ## Iterator that reads the content of the file buffer-by-buffer
  ## Returns the number of characters read while the data is available in the buffer.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  let iter = self.getStringBufferedIteratorImpl(absolutePath, buffer, start, length)
  for i in iter(buffer):
    yield i

iterator readStringBuffered*(self: File, buffer: var string, start: int64, length: int64): int =
  ## Iterator that reads the content of the file buffer-by-buffer
  ## Returns the number of characters read while the data is available in the buffer.
  ## If the file does not exist, it raises the FileSystemError.
  for i in self.fs.readStringBuffered(self.absolutePath, buffer, start, length):
    yield i