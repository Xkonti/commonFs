import std/unittest
import std/paths
import std/dirs
import sugar
import commonFs

proc verifyReadAllImpl*(fsConstructor: () -> FileSystem) =
  suite "impl.readAll":
    let testDirPath = getCurrentDir() / "./temp/testDirs/readAllTests".Path
    var fs: FileSystem

    setup:
      createDir(testDirPath)
      fs = fsConstructor()

    teardown:
      removeDir(testDirPath, false)

    test "should read full contents of a file via absolute path":
      let pathRelative = "textFile1.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let text = "Hello, World!"
      writeFile(pathAbsolute.string, text)

      check fs.readAll(pathAbsolute) == text
      let file = fs.getFileHandle pathAbsolute
      check file.readAll() == text

    test "should read full contents of a file via relative path":
      let pathRelative = "textFile2.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let text = "Hello, there!"
      writeFile(pathAbsolute.string, text)

      fs.currentDir = testDirPath
      check fs.readAll(pathRelative) == text
      let file = fs.getFileHandle pathRelative
      check file.readAll() == text

    test "should return empty string for empty file":
      let pathRelative = "textFile3.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let file = fs.createFile pathAbsolute

      check fs.readAll(pathAbsolute) == ""
      check file.readAll() == ""

    test "should throw error if file does not exist":
      let pathRelative = "textFile4.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      check not fs.fileExists pathAbsolute

      expect CatchableError:
        discard fs.readAll(pathAbsolute)

      let file = fs.getFileHandle pathRelative
      expect CatchableError:
        discard file.readAll()

    test "should throw error if path points to a directory":
      let pathRelative = "someDir".Path
      let pathAbsolute = testDirPath / pathRelative
      let dir = fs.createDir pathAbsolute
      check dir.exists

      expect CatchableError:
        discard fs.readAll(pathAbsolute)

      let file = fs.getFileHandle pathRelative
      expect CatchableError:
        discard file.readAll()