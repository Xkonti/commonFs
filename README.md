# CommonFs

⚠️ Work in progress - you can follow the progress by watching my live-streams: [YouTube](https://www.youtube.com/watch?v=N803udzR2dg&list=PL5AVzKSngnt-GaJxP04Kfn6cyx8T8hHKd)

CommonFs is a file system abstraction for Nim that allows implementing interchangeable file system backends. In other words, you should be able to switch between OS file system, in-memory FS, SFTP, etc. without changing your code.

# Current status

## File system operations

- [x] `proc currentDir` - get the current directory of the `FileSystem` instance
- [x] `proc currentDir=` - set the current directory of the `FileSystem` instance

## Directory operations

- [x] `proc createDir`
- [x] `proc dirExists`
- [x] `proc removeDir`
- [ ] `iterator walkDir` - iterate over instances of Dir and File
- [ ] `iterator walkDirRec` - iterate over instances of Dir and File recursively

- [ ] `Dir` type
    - [ ] `proc files: seq[File]`
    - [ ] `proc dirs: seq[Dir]`
    - [x] `proc parent: Dir`
    - [x] `proc absolutePath: string`
    - [x] `proc name: string`
    - [x] `proc exists: bool`
    - [x] `proc remove`
    - [ ] `iterator walk`
    - [ ] `iterator walkRec`

## File operations

- [x] `proc getFileHandle: File`
- [x] `proc createFile: File`
- [x] `proc fileExists`
- [x] `proc removeFile`
- [ ] `proc getLastModificaitonTime`
- [ ] `proc getLastAccessTime`
- [ ] `proc getCreationTime`
- [ ] `proc getFileSize`
- [x] `proc readString(path): string` - All file contents as a string
- [x] `proc readString(path, start, length)` - Part of the file as a string
- [x] `proc readStringIt(path, start, length)` - Iterator over buffer length
- [x] `proc readBytes(path): seq[byte]` - All file contents as bytes
- [ ] `proc readBytes(path, var buffer, start, len): int` - Part of the file as bytes
- [ ] `proc readBytesIt(path, var buffer, start, len): int` - Iterator over buffer length
- [x] `proc write` takes a varargs of strings (like `echo`)
- [ ] `proc writeBytes` takes an `openArray[byte]`

- [ ] `File` type
    - [x] `proc parent: Dir`
    - [x] `proc absolutePath: string`
    - [x] `proc name: string`
    - [x] `proc ext: string`
    - [x] `proc filename: string`
    - [x] `proc exists: bool`
    - [x] `proc remove`
    - [ ] `proc size: int`
    - [ ] `proc lastModificationTime: Time`
    - [ ] `proc lastAccessTime: Time`
    - [ ] `proc creationTime: Time`
    - [x] `proc readString(): string` - All file contents as a string
    - [ ] `proc readString(start, length)` - Part of the file as a string
    - [ ] `proc readStringIt(start, length)` - Iterator over buffer length
    - [x] `proc readBytes(): seq[byte]` - All file contents as bytes
    - [ ] `proc readBytes(var buffer, start, len): int` - Part of the file as bytes
    - [ ] `proc readBytesIt(var buffer, start, len): int` - Iterator over buffer length
    - [x] `proc write` takes a varargs of strings (like `echo`)
    - [ ] `proc writeBytes` takes an `openArray[byte]`

## To be implemented a bit later

- [ ] make everything async
- [ ] cursors for reading and writing files
- [ ] `proc moveDir`
- [ ] `proc copyDir`
- [ ] `proc moveFile`
- [ ] `proc copyFile`
- [ ] permissions management for directories and files
    - [ ] `proc getDirPermissions`
    - [ ] `proc setDirPermissions`
    - [ ] `proc getFilePermissions`
    - [ ] `proc setFilePermissions`