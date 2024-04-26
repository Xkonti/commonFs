import std/paths
from std/dirs import createDir, dirExists, removeDir
import ../commonFs/commonFs

type
  OsFs* {.final.} = ref object of FileSystem

proc new*(_: typedesc[OsFs]): FileSystem =
  result = system.new(OsFs)

method createDir*(self: OsFs, path: Path) =
  try:
    createDir(path)
  except OSError:
    raise newException(FileSystemError, "Cannot create directory")
  except IOError:
    raise newException(FileSystemError, "Cannot create directory")

method dirExists*(self: OsFs, path: Path): bool =
  return dirExists(path)

method removeDir*(self: OsFs, path: Path) =
  try:
    removeDir(path)
  except OSError:
    raise newException(FileSystemError, "Cannot delete directory")
  