import std/unittest
import std/paths
import std/dirs
import sugar
import commonFs

proc verifyWriteImpl*(fsConstructor: () -> FileSystem) =
  suite "impl.write":
    let testDirPath = getCurrentDir() / "./temp/testDirs/writeTests".Path
    var fs: FileSystem

    setup:
      createDir(testDirPath)
      fs = fsConstructor()

    teardown:
      removeDir(testDirPath, false)

    test "should write to an existing file via absolute path":
      let pathRelative1 = "textFile1a.txt".Path
      let pathAbsolute1 = testDirPath / pathRelative1
      let content = "Test string #1"
      
      let file1 = fs.createFile(pathAbsolute1)
      check file1.exists
      fs.write(pathAbsolute1, content)
      check file1.readString == content

      let pathRelative2 = "textFile1b.txt".Path
      let pathAbsolute2 = testDirPath / pathRelative2
      let file2 = fs.createFile(pathAbsolute2)
      check file2.exists
      file2.write(content)
      check file2.readString == content

    test "should write to an existing file via relative path":
      let pathRelative1 = "textFile2a.txt".Path
      let pathAbsolute1 = testDirPath / pathRelative1
      let content = "Test string #2"
      
      let file1 = fs.createFile(pathAbsolute1)
      check file1.exists
      fs.currentDir = testDirPath
      fs.write(pathRelative1, content)
      check file1.readString == content

      let pathRelative2 = "textFile2b.txt".Path
      let file2 = fs.createFile(pathRelative2)
      check file2.exists
      file2.write(content)
      check file2.readString == content

    test "should write to a new file":
      let pathRelative1 = "textFile3a.txt".Path
      let pathAbsolute1 = testDirPath / pathRelative1
      let content = "Test string #3"
      check not fs.fileExists pathAbsolute1
      fs.write(pathAbsolute1, content)
      check fs.fileExists pathAbsolute1
      check fs.readString(pathAbsolute1) == content

      let pathRelative2 = "textFile3b.txt".Path
      let pathAbsolute2 = testDirPath / pathRelative2
      let file = fs.getFileHandle(pathAbsolute2)
      check not file.exists
      file.write(content)
      check file.exists
      check file.readString == content

    test "should allow writing mulitple elements":
      let pathRelative1 = "textFile4a.txt".Path
      let pathAbsolute1 = testDirPath / pathRelative1
      let content1 = "Test part 1"
      let content2 = 3
      let content3 = "Test part 3"
      let content4 = [1.5, 2.4, -23.8]
      let content = "Test part 13Test part 3[1.5, 2.4, -23.8]"
      
      let file1 = fs.createFile(pathAbsolute1)
      check file1.exists
      fs.currentDir = testDirPath
      fs.write(pathRelative1, content1, content2, content3, content4)
      check file1.readString == content

      let pathRelative2 = "textFile4b.txt".Path
      let file2 = fs.createFile(pathRelative2)
      check file2.exists
      file2.write(content1, content2, content3, content4)
      check file2.readString == content

    test "should throw an error when writing to a directory":
      let pathRelative = "textFile5.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      let content = "Nothing matters here"
      
      let dir = fs.createDir(pathAbsolute)
      check dir.exists
      expect CatchableError:
        fs.write(pathAbsolute, content)
      let file = fs.getFileHandle(pathAbsolute)
      expect CatchableError:
        file.write(content)

    test "should create empty file when writing empty content":
      let pathRelative1 = "textFile6a.txt".Path
      let pathAbsolute1 = testDirPath / pathRelative1
      check not fs.fileExists pathAbsolute1
      fs.write(pathAbsolute1, "")
      check fs.fileExists pathAbsolute1
      check fs.readString(pathAbsolute1) == ""

      let pathRelative2 = "textFile6b.txt".Path
      let pathAbsolute2 = testDirPath / pathRelative2
      let file = fs.getFileHandle(pathAbsolute2)
      check not file.exists
      file.write("", "", "", "")
      check file.exists
      check file.readString == ""

    test "should overwrite instead of appending":
      let pathRelative = "textFile7.txt".Path
      let pathAbsolute = testDirPath / pathRelative
      
      fs.write(pathAbsolute, "Hello ", "there!")
      check fs.readString(pathAbsolute) == "Hello there!"
      let file = fs.getFileHandle(pathAbsolute)
      file.write("Goodbye ", "now!")
      check file.readString == "Goodbye now!"
      file.write("Wololo")
      check file.readString == "Wololo"