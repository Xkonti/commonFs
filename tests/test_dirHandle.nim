import std/unittest
import std/paths
import std/dirs
import commonFs
import std/options

suite "CommonFs.getDirHandle":
  var fs: FileSystem

  setup:
    fs = new FileSystem

  teardown:
    discard

  test "should return a dir handle with correct FS and path given absolute path":
    var path = "/tmp/test".Path
    var handle = fs.getDirHandle path
    
    check handle.absolutePath == path
    check handle.fs == fs

  test "should return a dir handle with correct FS and path given relative path":
    var rootPath = "/tmp".Path
    var relativeDirPath = "tests".Path
    var absoluteDirPath = rootPath / relativeDirPath
    fs.currentDir = rootPath
    var handle = fs.getDirHandle relativeDirPath
    check handle.absolutePath == fs.getAbsolutePathTo relativeDirPath
    check handle.fs == fs

suite "CommonFs.Dir - Path helpers":
  var fs: FileSystem

  setup:
    fs = new FileSystem

  teardown:
    discard
  
  test "name should return the name of the directory":
    const testCases = [
      ("/tmp/somewhere/there", "there"),
      ("/home/user/manifesto.pdf", "manifesto.pdf"),
      ("/dev/projects/secret/.gitignore", ".gitignore"),
      ("/some/other/path/", "path")
    ]

    for testCase in testCases:
      let path = testCase[0].Path
      let name = testCase[1]
      let handle = fs.getDirHandle path
      check handle.name == name

  test "parent should return the parent directory":
    const testCases = [
      ("/tmp/somewhere/there", "/tmp/somewhere"),
      ("/home/user/manifesto.pdf", "/home/user"),
      ("/dev/projects/secret/.gitignore", "/dev/projects/secret"),
      ("/some/other/path/", "/some/other"),
      ("/bin", "/")
    ]

    for testCase in testCases:
      let path = testCase[0].Path
      let parentPath = testCase[1].Path
      let handle = fs.getDirHandle path
      let parentOpt = handle.parent
      check parentOpt.isSome
      check parentOpt.get.absolutePath == parentPath

  test "parent should return None for root directory":
    let path = "/".Path
    let handle = fs.getDirHandle path
    let parentOpt = handle.parent
    check parentOpt.isNone