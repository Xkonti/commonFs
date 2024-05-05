import std/unittest
import std/paths
import std/dirs
import commonFs

suite "CommonFs.getDirHandle":
  var fs: FileSystem

  setup:
    fs = new FileSystem

  teardown:
    discard

  test "should return a dir handle with correct FS and path given absolute path":
    var path = "/tmp/test".Path
    var handle = fs.getDirHandle(path)
    
    check handle.absolutePath == path
    check handle.fs == fs

  test "should return a dir handle with correct FS and path given relative path":
    var rootPath = "/tmp".Path
    var relativeDirPath = "tests".Path
    var absoluteDirPath = rootPath / relativeDirPath
    fs.currentDir = rootPath
    var handle = fs.getDirHandle(relativeDirPath)
    check handle.absolutePath == fs.getAbsolutePathTo(relativeDirPath)
    check handle.fs == fs

suite "CommonFs.Dir - Path helpers":
  var fs: FileSystem

  setup:
    fs = new FileSystem

  teardown:
    discard
  
  test "name should return the name of the directory":
    var path1 = "/tmp/somewhere/somefile".Path
    var handle1 = fs.getDirHandle(path1)
    check handle1.name == "somefile"

    # A directory can be named like a file
    var path2 = "/home/user/manifesto.pdf".Path
    var handle2 = fs.getDirHandle(path2)
    check handle2.name == "manifesto.pdf"

    # Hidden directories should be listed as well
    var path3 = "/home/user/.gitignore".Path
    var handle3 = fs.getDirHandle(path3)
    check handle3.name == ".gitignore"

    # A trailing slash should be ignored
    var path4 = "/some/other/path/".Path
    var handle4 = fs.getDirHandle(path4)
    check handle4.name == "path"