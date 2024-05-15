import std/unittest
import std/paths
import std/dirs
import sugar
import commonFs

proc verifyReadStringImpl*(fsConstructor: () -> FileSystem) =
  suite "impl.readString (all)":
    let testDirPath = getCurrentDir() / "./temp/testDirs/readStringAllTests".Path
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

      check fs.readString(pathAbsolute) == text
      let file = fs.getFileHandle pathAbsolute
      check file.readString() == text

    test "should read full contents of a file via relative path":
      let pathRelative = "textFile2.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let text = "Hello, there!"
      writeFile(pathAbsolute.string, text)

      fs.currentDir = testDirPath
      check fs.readString(pathRelative) == text
      let file = fs.getFileHandle pathRelative
      check file.readString() == text

    test "should return empty string for empty file":
      let pathRelative = "textFile3.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let file = fs.createFile pathAbsolute

      check fs.readString(pathAbsolute) == ""
      check file.readString() == ""

    test "should throw error if file does not exist":
      let pathRelative = "textFile4.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      check not fs.fileExists pathAbsolute

      expect CatchableError:
        discard fs.readString(pathAbsolute)

      let file = fs.getFileHandle pathRelative
      expect CatchableError:
        discard file.readString()

    test "should throw error if path points to a directory":
      let pathRelative = "someDir".Path
      let pathAbsolute = testDirPath / pathRelative
      let dir = fs.createDir pathAbsolute
      check dir.exists

      expect CatchableError:
        discard fs.readString(pathAbsolute)

      let file = fs.getFileHandle pathRelative
      expect CatchableError:
        discard file.readString()


  suite "impl.readString (buffer)":
    let testDirPath = getCurrentDir() / "./temp/testDirs/readStringBufferTests".Path
    var fs: FileSystem

    setup:
      createDir(testDirPath)
      fs = fsConstructor()

    teardown:
      removeDir(testDirPath, false)

    test "should fill entire buffer from start position 0":
      let path = testDirPath / "fullStart0.txt".Path
      let text = "Hello, World! This is a test."
      writeFile(path.string, text)
      const bufferLength = 10
      var buffer: string = newStringOfCap(bufferLength)
      let read = fs.readString(path, buffer, 0, bufferLength)
      check buffer == "Hello, Wor"
      check read == bufferLength

    test "should fill entire buffer from start position 15":
      let path = testDirPath / "fullStart15.txt".Path
      let text = "Hello, World! This is a test."
      writeFile(path.string, text)
      const bufferLength = 12
      var buffer: string = newStringOfCap(bufferLength)
      let read = fs.readString(path, buffer, 15, bufferLength)
      check buffer == "his is a tes"
      check read == bufferLength

    test "should partially fill buffer from start position 0":
      let path = testDirPath / "partialStart0.txt".Path
      let text = "Short data"
      writeFile(path.string, text)
      const bufferLegth = 20
      var buffer: string = newStringOfCap(bufferLegth)
      let read = fs.readString(path, buffer, 0, bufferLegth)
      check buffer == text
      check read == text.len

    test "should partially fill buffer from start position 15":
      let path = testDirPath / "partialStart15.txt".Path
      let text = "Hello, World! This is short."
      writeFile(path.string, text)
      const bufferLegth = 20
      var buffer: string = newStringOfCap(bufferLegth)
      let read = fs.readString(path, buffer, 15, bufferLegth)
      check buffer == "his is short."
      check read == 13

    test "should make buffer empty when reading empty file":
      let path = testDirPath / "emptyFile.txt".Path
      writeFile(path.string, "")
      const bufferLegth = 4096
      var buffer: string = newStringOfCap(bufferLegth)
      let read = fs.readString(path, buffer, 0, bufferLegth)
      check buffer == ""
      check read == 0

    test "should make buffer empty when no data left in file from start 10":
      let path = testDirPath / "datalessStart10.txt".Path
      let text = "Short data"
      writeFile(path.string, text)
      const bufferLegth = 1024
      var buffer: string = newStringOfCap(bufferLegth)
      let read = fs.readString(path, buffer, 10, bufferLegth)
      check buffer == ""
      check read == 0

    test "should make buffer empty when reading start is past file end":
      let path = testDirPath / "readingPashEnd.txt".Path
      let text = "Some data"
      writeFile(path.string, text)
      const bufferLegth = 512
      var buffer: string = newStringOfCap(bufferLegth)
      let read = fs.readString(path, buffer, 1000, bufferLegth)
      check buffer == ""
      check read == 0

    test "should throw error if file does not exist":
      let pathRelative = "bufferTextFile4.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      check not fs.fileExists(pathAbsolute)
      const bufferLength = 20
      var buffer: string = newString(bufferLength)
      expect CatchableError:
        discard fs.readString(pathAbsolute, buffer, 0, bufferLength)

    test "should throw error if path points to a directory":
      let pathRelative = "bufferSomeDir".Path
      let pathAbsolute = testDirPath / pathRelative
      let dir = fs.createDir(pathAbsolute)
      check dir.exists()
      const bufferLength = 20
      var buffer: string = newString(bufferLength)
      expect CatchableError:
        discard fs.readString(pathAbsolute, buffer, 0, bufferLength)


  suite "impl.readStringBuffered (iterator)":
    let testDirPath = getCurrentDir() / "./temp/testDirs/readStringIteratorTests".Path
    var fs: FileSystem

    setup:
      createDir(testDirPath)
      fs = fsConstructor()

    teardown:
      removeDir(testDirPath, false)

    test "should read full contents of a file when starting at 0":
      let path = testDirPath / "fullStart0.txt".Path
      let text = "Hello, World! This is a test. Hello, World! This is a test. Hello, World! This is a test!!"
      writeFile(path.string, text)
      var buffer: string
      var endResult = ""
      for charactersRead in fs.readStringBuffered(path, buffer, 0, 10):
        check charactersRead == 10
        check buffer.len == 10
        endResult.add(buffer)
      check endResult == text