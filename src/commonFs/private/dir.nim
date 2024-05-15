import std/paths
import fs

type
  Dir* = ref object of RootObj
    fs: FileSystem
    absolutePath: Path

# Procs just for internal use
# Don't reexport those
proc priv_newDir*(fs: FileSystem, absolutePath: Path): Dir {.noinit.} =
  return Dir(fs: fs, absolutePath: absolutePath)
proc priv_fs*(dir: Dir): FileSystem = dir.fs
proc priv_absolutePath*(dir: Dir): Path = dir.absolutePath
proc `priv_absolutePath=`*(dir: Dir; path: Path) = dir.absolutePath = path