import std/paths

import file
import fsFileOps

proc name*(self: file.File): string {.inline.} = ## \
  ## Returns the name of the file excluding the extension.
  let (_, name, _) = self.priv_absolutePath.splitFile()
  return name.string

proc ext*(self: file.File): string {.inline.} = ## \
  ## Returns the extension of the file (withouth dot).
  let (_, _, ext) = self.priv_absolutePath.splitFile()
  return ext

proc filename*(self: file.File): string {.inline.} = ## \
  ## Returns the name of the file including the extension.
  
  let (_, name, ext) = self.priv_absolutePath.splitFile()
  return name.string & ext

proc exists*(self: file.File): bool {.inline.} = ## \
  ## Returns true if the file exists. If the path points to a directory, it returns false.
  return self.priv_fs.fileExists(self.priv_absolutePath)

proc remove*(self: file.File) {.inline.} = ## \
  ## Removes the file. It does not raise an error if the file does not exist.
  self.priv_fs.removeFile(self.priv_absolutePath)

proc readString*(self: file.File): string =
  ## Reads the content of the file and returns it as a string.
  ## If the file does not exist, it raises the FileSystemError.
  self.priv_fs.readString(self.priv_absolutePath)

proc readBytes*(self: file.File): seq[byte] =
  ## Reads the content of the file and returns it as a sequence of bytes.
  ## If the file does not exist, it raises the FileSystemError.
  self.priv_fs.readBytes(self.priv_absolutePath)

proc write*(self: file.File, content: varargs[string, `$`]) = ## \
  ## Writes the provided content to the file .
  ## If the file does not exist, it will be created.
  self.priv_fs.write(self.priv_absolutePath, content)