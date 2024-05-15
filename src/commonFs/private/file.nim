import std/paths
import fs

type
  File* = ref object of RootObj
    fs: FileSystem
    absolutePath: Path

# Procs just for internal use
# Don't reexport those
proc priv_newFile*(fs: FileSystem; absolutePath: Path): File {.noinit.} =
  return File(fs: fs, absolutePath: absolutePath)
proc priv_fs*(file: File): FileSystem = file.fs
proc priv_absolutePath*(file: File): Path = file.absolutePath
proc `priv_absolutePath=`*(file: File; path: Path) = file.absolutePath = path