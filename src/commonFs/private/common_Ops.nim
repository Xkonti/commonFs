#[
  FILE SYSTEM
]#

proc fs*(self: Dir | File): FileSystem {.inline.} =
  ## Returns the FileSystem object the handle belongs to.
  return self.fs

#[
  PATHS
]#

proc absolutePath*(self: Dir | File): Path {.inline.} =
  ## Returns the absolute path the provided handle points to.
  return self.absolutePath

#[
  NAMES, etc.
]#

proc name*(self: Dir): string {.inline.} =
  ## Returns the name of the directory.
  let path = self.absolutePath
  if path.isRootDir:
    return "/"
  return path.lastPathPart.string


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


#[
  PARENT
]#

proc parent*(self: Dir | File): Option[Dir] =
  ## Returns the parent directory of the directory or file.
  ## If the provided path is the root directory, it returns none.
  let path = self.absolutePath
  if path.isRootDir:
    return none Dir
  return some self.fs.getDirHandle path.parentDir