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
    - [ ] `proc parent: Dir`
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

- [ ] `proc readAll: string`
- [ ] `proc readBytes: int` takes an `openArray[byte]`
- [ ] `proc write` takes a varargs of strings (like `echo`)
- [ ] `proc writeBytes` takes an `openArray[byte]`

- [ ] `File` type
    - [ ] `proc parent: Dir`
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
    - [ ] `proc readAll: string`
    - [ ] `proc readBytes: int` takes an `openArray[byte]`
    - [ ] `proc write` takes a varargs of strings (like `echo`)
    - [ ] `proc writeBytes` takes an `openArray[byte]`

## To be implemented a bit later

- [ ] `proc moveDir`
- [ ] `proc copyDir`
- [ ] `proc moveFile`
- [ ] `proc copyFile`
- [ ] permissions management for directories and files
    - [ ] `proc getDirPermissions`
    - [ ] `proc setDirPermissions`
    - [ ] `proc getFilePermissions`
    - [ ] `proc setFilePermissions`