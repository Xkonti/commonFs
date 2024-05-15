import std/paths
import errors

type
  FileSystem* = ref object of RootObj
    currentAbsoluteDir: Path = "/".Path

#[
  CURRENT DIRECTORY OPERATIONS
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