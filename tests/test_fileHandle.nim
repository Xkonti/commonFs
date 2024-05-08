import std/unittest
import std/paths
import std/dirs
import commonFs
import std/options

suite "CommonFs.getFileHandle":
  var fs: FileSystem

  setup:
    fs = new FileSystem

  teardown:
    discard

  test "should return a file handle with correct FS and path given absolute path":
    var path = "/tmp/test.txt".Path
    var handle = fs.getFileHandle(path)
    
    check handle.absolutePath == path
    check handle.fs == fs

  test "should return a file handle with correct FS and path given relative path":
    var rootPath = "/tmp".Path
    var relativeFilePath = "test.txt".Path
    var absoluteFilePath = rootPath / relativeFilePath
    fs.currentDir = rootPath
    var handle = fs.getFileHandle(relativeFilePath)
    check handle.absolutePath == fs.getAbsolutePathTo(relativeFilePath)
    check handle.fs == fs

suite "CommonFs.File - Path helpers":
  var fs: FileSystem

  setup:
    fs = new FileSystem

  teardown:
    discard
  
  test "name should return the name of the file":
    var path1 = "/tmp/somewhere/somefile.txt".Path
    var handle1 = fs.getFileHandle(path1)
    check handle1.name == "somefile"

    var path2 = "/home/user/manifesto.pdf".Path
    var handle2 = fs.getFileHandle(path2)
    check handle2.name == "manifesto"

    # Hidden files aren't treated as extensions
    var path3 = "/home/user/.gitignore".Path
    var handle3 = fs.getFileHandle(path3)
    check handle3.name == ".gitignore"

  test "name should be empty string if there is no name in path":
    var path1 = "/tmp/somewhere/".Path
    var handle1 = fs.getFileHandle(path1)
    check handle1.name == ""

    var path2 = "/".Path
    var handle2 = fs.getFileHandle(path2)
    check handle2.name == ""

  test "extension should return the extension of the file":
    var path1 = "/tmp/somewhere/somefile.txt".Path
    var handle1 = fs.getFileHandle(path1)
    check handle1.ext == ".txt"

    var path2 = "/home/user/manifesto.pdf".Path
    var handle2 = fs.getFileHandle(path2)
    check handle2.ext == ".pdf"

  test "extension should be empty string if there is no extension in path":
    var path1 = "/tmp/somewhere/somefile".Path
    var handle1 = fs.getFileHandle(path1)
    check handle1.ext == ""

    var path2 = "/home/user/".Path
    var handle2 = fs.getFileHandle(path2)
    check handle2.ext == ""

    # Hidden files aren't treated as extensions
    var path3 = "/home/user/.gitignore".Path
    var handle3 = fs.getFileHandle(path3)
    check handle3.ext == ""

  test "filename should return the name of the file with extension":
    var path1 = "/tmp/somewhere/somefile.txt".Path
    var handle1 = fs.getFileHandle(path1)
    check handle1.filename == "somefile.txt"

    var path2 = "/home/user/manifesto.pdf".Path
    var handle2 = fs.getFileHandle(path2)
    check handle2.filename == "manifesto.pdf"

  test "filename should be empty string if there is no name in path":
    var path1 = "/tmp/somewhere/".Path
    var handle1 = fs.getFileHandle(path1)
    check handle1.filename == ""

    var path2 = "/".Path
    var handle2 = fs.getFileHandle(path2)
    check handle2.filename == ""

  test "filename should be the name of the file if there is no extension":
    var path1 = "/tmp/somewhere/somefile".Path
    var handle1 = fs.getFileHandle(path1)
    check handle1.filename == "somefile"

    var path2 = "/home/user/.gitkeep".Path
    var handle2 = fs.getFileHandle(path2)
    check handle2.filename == ".gitkeep"

  test "parent should return the parent directory":
    const testCases = [
      ("/tmp/somewhere/there", "/tmp/somewhere"),
      ("/home/user/manifesto.pdf", "/home/user"),
      ("/dev/projects/secret/.gitignore", "/dev/projects/secret"),
      ("/some/other/path/", "/some/other")
    ]

    for testCase in testCases:
      let path = testCase[0].Path
      let parentPath = testCase[1].Path
      let handle = fs.getFileHandle path
      let parentOpt = handle.parent
      check parentOpt.isSome == true
      check parentOpt.get.absolutePath == parentPath

  test "parent should return None for root directory":
    let path = "/".Path
    let handle = fs.getFileHandle path
    let parentOpt = handle.parent
    check parentOpt.isNone