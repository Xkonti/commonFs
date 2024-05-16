proc name*(self: File): string {.inline.} =
  ## Returns the name of the file excluding the extension.
  let (_, name, _) = self.absolutePath.splitFile()
  return name.string

proc ext*(self: File): string {.inline.} =
  ## Returns the extension of the file (withouth dot).
  let (_, _, ext) = self.absolutePath.splitFile()
  return ext

proc filename*(self: File): string {.inline.} =
  ## Returns the name of the file including the extension.
  
  let (_, name, ext) = self.absolutePath.splitFile()
  return name.string & ext

proc exists*(self: File): bool {.inline.} =
  ## Returns true if the file exists. If the path points to a directory, it returns false.
  return self.fs.fileExists(self.absolutePath)

proc remove*(self: File) {.inline.} =
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

proc write*(self: File, content: varargs[string, `$`]) =
  ## Writes the provided content to the file .
  ## If the file does not exist, it will be created.
  self.fs.write(self.absolutePath, content)