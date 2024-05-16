type
  FileSystem* = ref object of RootObj
    currentAbsoluteDir: Path = "/".Path
  
  Dir* = ref object of RootObj
    fs: FileSystem
    absolutePath: Path

  File* = ref object of RootObj
    fs: FileSystem
    absolutePath: Path