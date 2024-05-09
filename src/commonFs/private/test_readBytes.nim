import std/unittest
import std/paths
import std/dirs
import sugar
import commonFs

proc toBytes(test: string): seq[byte] =
  for character in test:
    result.add character.ord.byte

proc verifyReadBytesImpl*(fsConstructor: () -> FileSystem) =
  suite "impl.readBytes":
    let testDirPath = getCurrentDir() / "./temp/testDirs/readBytesTests".Path
    var fs: FileSystem

    setup:
      createDir(testDirPath)
      fs = fsConstructor()

    teardown:
      removeDir(testDirPath, false)

    test "should read full string contents of a file via absolute path":
      let pathRelative = "textFile1.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let text = "Hello, World!".toBytes

      writeFile(pathAbsolute.string, text)

      check fs.readBytes(pathAbsolute) == text
      let file = fs.getFileHandle pathAbsolute
      check file.readBytes() == text

    test "should read full string contents of a file via relative path":
      let pathRelative = "textFile2.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let text = "Whatever. This doesn't matter!".toBytes

      writeFile(pathAbsolute.string, text)

      fs.currentDir = testDirPath
      check fs.readBytes(pathRelative) == text
      let file = fs.getFileHandle pathRelative
      check file.readBytes() == text

    test "should read full binary contents of a file":
      let pathRelative = "binaryFile1.bin".Path
      let pathAbsolute = testDirPath / pathRelative
      var binary: seq[byte] = @[]
      for i in 0..255:
        binary.add i.byte
      binary.add binary

      writeFile(pathAbsolute.string, binary)

      let readBytes = fs.readBytes(pathAbsolute)
      check readBytes.len == binary.len
      check readBytes == binary
      let file = fs.getFileHandle pathAbsolute
      check file.readBytes() == binary

    test "should return empty sequence for empty file":
      let pathRelative = "textFile3.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let emptyBytes: seq[byte] = @[]

      let file = fs.createFile pathAbsolute

      check fs.readBytes(pathAbsolute) == emptyBytes
      check file.readBytes() == emptyBytes

    test "should throw error if file does not exist":
      let pathRelative = "textFile4.txt".Path
      let pathAbsolute = testDirPath / pathRelative

      expect CatchableError:
        discard fs.readBytes pathAbsolute

      let file = fs.getFileHandle pathAbsolute
      expect CatchableError:
        discard file.readBytes()

    test "should throw error if file is a directory":
      let pathRelative = "someDir".Path
      let pathAbsolute = testDirPath / pathRelative
      let dir = fs.createDir pathAbsolute
      check dir.exists

      expect CatchableError:
        discard fs.readBytes pathAbsolute

      let file = fs.getFileHandle pathRelative
      expect CatchableError:
        discard file.readBytes()