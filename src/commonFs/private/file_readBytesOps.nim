method readBytesImpl(self: FileSystem, absolutePath: Path): seq[byte] {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readBytes hasn't been implemented!")

proc readBytes*(self: FileSystem, path: Path): seq[byte] =
  ## Reads the content of the file at the specified path and returns it as a sequence of bytes.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readBytesImpl(absolutePath)

proc readBytes*(self: File): seq[byte] =
  ## Reads the content of the file and returns it as a sequence of bytes.
  ## If the file does not exist, it raises the FileSystemError.
  self.fs.readBytes(self.absolutePath)


method readBytesImpl(self: FileSystem, absolutePath: Path, buffer: var openArray[byte], start: int64, length: int64): int64 {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method readBytes hasn't been implemented!")

# TODO: TEST
proc readBytes*(self: FileSystem, path: Path, buffer: var openArray[byte], start: int64, length: int64): int64 =
  ## Reads the content of the file into the specified byte buffer starting at the specified index.
  ## Returns the number of bytes read.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  self.readBytesImpl(absolutePath, buffer, start, length)

# TODO: TEST
proc readBytes*(self: File, buffer: var openArray[byte], start: int64, length: int64): int64 =
  ## Reads the content of the file into the specified byte buffer starting at the specified index.
  ## Returns the number of bytes read.
  ## If the file does not exist, it raises the FileSystemError.
  self.fs.readBytes(self.absolutePath, buffer, start, length)


type BytesBufferedIterator* = iterator(buffer: var openArray[byte]): int

method getBytesBufferedIteratorImpl(self: FileSystem, absolutePath: Path, buffer: var openArray[byte], start: int64, length: int64): BytesBufferedIterator {.base, raises: [LibraryError, FileSystemError].} =
  raise newException(LibraryError, "Method getBytesBufferedIterator hasn't been implemented!")

# TODO: TEST
iterator readBytesBuffered*(self: FileSystem, path: Path, buffer: var openArray[byte], start: int64, length: int64): int =
  ## Iterator that reads the content of the file buffer-by-buffer
  ## Returns the number of bytes read while the data is available in the buffer.
  ## If the file does not exist, it raises the FileSystemError.
  let absolutePath = self.getAbsolutePathTo(path)
  let iter = self.getBytesBufferedIteratorImpl(absolutePath, buffer, start, length)
  for i in iter(buffer):
    yield i

# TODO: TEST
iterator readBytesBuffered*(self: File, buffer: var openArray[byte], start: int64, length: int64): int =
  ## Iterator that reads the content of the file buffer-by-buffer
  ## Returns the number of bytes read while the data is available in the buffer.
  ## If the file does not exist, it raises the FileSystemError.
  for i in self.fs.readBytesBuffered(self.absolutePath, buffer, start, length):
    yield i