import std/unittest
import std/paths
import std/dirs
import sugar
import commonFs

proc verifyCreateFileImpl*(fsConstructor: () -> FileSystem) =
  suite "impl.createFile":
    let testDirPath = getCurrentDir() / "./temp/testDirs/createFileTests".Path
    var fs: FileSystem

    setup:
      createDir(testDirPath)
      fs = fsConstructor()

    teardown:
      removeDir(testDirPath, false)


    test "should create a file with the given absolute path":
      var pathRelative = "testFile1.txt".Path
      var pathAbsolute = testDirPath / pathRelative
      var file = fs.createFile pathAbsolute
      check fs.fileExists pathAbsolute
      check file.absolutePath == pathAbsolute
      check file.exists

      pathRelative = "testFile1B.txt".Path
      pathAbsolute = testDirPath / pathRelative
      file = fs.getFileHandle pathAbsolute
      file.create()
      check file.exists


    test "should create a file with the given relative path":
      var pathRelative = "testFile2.txt".Path
      var pathAbsolute = testDirPath / pathRelative
      fs.currentDir = testDirPath
      var file = fs.createFile pathRelative
      check fs.fileExists pathAbsolute
      check file.absolutePath == pathAbsolute
      check file.exists

      pathRelative = "testFile2B.txt".Path
      pathAbsolute = testDirPath / pathRelative
      fs.currentDir = testDirPath
      file = fs.getFileHandle pathRelative
      file.create()
      check file.exists


    test "should throw an error if a directory with the same name exists":
      let pathRelative = "testFile3".Path
      let pathAbsolute = testDirPath / pathRelative
      createDir(pathAbsolute)
      expect CatchableError:
        fs.createFile(pathAbsolute)
      
      let file = fs.getFileHandle pathAbsolute
      expect CatchableError:
        file.create()


    test "should not throw an error if a file with the same name exists":
      let pathRelative = "testFile4.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      open(pathAbsolute.string, fmWrite).close()
      var file = fs.createFile(pathAbsolute)
      check fs.fileExists(pathAbsolute)
      check file.absolutePath == pathAbsolute

      file = fs.getFileHandle pathAbsolute
      file.create()
      check file.exists


    test "should throw an error if parent directory does not exist":
      let pathRelative = "/missin/testFile5.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      expect CatchableError:
        fs.createFile(pathAbsolute)
      
      let file = fs.getFileHandle pathAbsolute
      expect CatchableError:
        file.create()