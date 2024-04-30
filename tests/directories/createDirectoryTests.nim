# MIT Licence

# Copyright (c) 2024 by Beniamin Dudek aka Xkonti

# MIT Licence

# Copyright (c) 2024 by Beniamin Dudek aka Xkonti

import std/unittest
import std/paths
import std/dirs
from ../../commonFs/commonFs import FileSystem, createDir, setCurrentDir, dirExists
from ../../osFs/osFs import newOsFs

suite "OsFs.createDir":
  let testDirPath = getCurrentDir() / "./temp/testDirs/currentDirTests".Path
  var fs: FileSystem

  setup:
    createDir(testDirPath)
    fs = newOsFs()

  teardown:
    removeDir(testDirPath, false)

  test "should create a directory using an absolute path":
    let dirRelative = "testDir1".Path
    let dirAbsolute = testDirPath / dirRelative
    fs.createDir(dirAbsolute)
    check(fs.dirExists(dirAbsolute))

  test "should create a directory using a relative path":
    let dirRelative = "testDir2".Path
    let dirAbsolute = testDirPath / dirRelative
    fs.setCurrentDir(testDirPath)
    fs.createDir(dirRelative)
    check(fs.dirExists(dirAbsolute))

  test "should create a directory using an absolute path when the current directory is set":
    let dirRelative = "testDir3".Path
    let dirAbsolute = testDirPath / dirRelative
    fs.createDir(dirAbsolute)
    check(fs.dirExists(dirAbsolute))

  test "should throw an exception when creating a directory with the same name as an existing file":
    let dirRelative = "testDir4".Path
    let dirAbsolute = testDirPath / dirRelative
    open(dirAbsolute.string, fmWrite).close() # Create a file with the same name as the directory
    expect CatchableError:
      fs.createDir(dirAbsolute)

  test "should not throw an exception when creating a directory that already exists":
    let dirRelative = "testDir5".Path
    let dirAbsolute = testDirPath / dirRelative
    fs.createDir(dirAbsolute)
    fs.createDir(dirAbsolute)