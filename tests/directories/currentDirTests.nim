# MIT Licence

# Copyright (c) 2024 by Beniamin Dudek aka Xkonti

import std/paths
import std/dirs
from ../../commonFs/commonFs import createDir, setCurrentDir, dirExists
from ../../osFs/osFs import newOsFs

# Setup

# Create a new directory where test directories will be placed
let testDirPath = getCurrentDir() / "./temp/testDirs/currentDirTests".Path
createDir(testDirPath)

# Act

let fs = newOsFs()

# Creating using absolute path
let dir1relative = "testDir1".Path
let dir1absolute = testDirPath / dir1relative
fs.createDir(dir1absolute)
assert fs.dirExists(dir1absolute), "Directory was not created when using absolute path"

# Creating using relative path
let dir2relative = "testDir2".Path
let dir2absolute = testDirPath / dir2relative
fs.setCurrentDir(testDirPath)
fs.createDir(dir2relative)
assert fs.dirExists(dir2absolute), "Directory was not created when using relative path"

# Creating using absolute path when current directory is set
let dir3relative = "testDir3".Path
let dir3absolute = testDirPath / dir3relative
fs.createDir(dir3absolute)
assert fs.dirExists(dir3absolute), "Directory was not created when using absolute path"

# Creating a directory when a file with the same name already exists [Exception]
let dir4relative = "testDir4".Path
let dir4absolute = testDirPath / dir4relative
open(dir4absolute.string, fmWrite).close() # Create a file with the same name as the directory
try:
    fs.createDir(dir4absolute)
    assert false, "Exception was not thrown when creating a directory with the same name as a file"
except:
    assert fs.dirExists(dir4absolute) == false, "Directory was not created when a file with the same name already exists"

# Creating a directory when a directory with the same name already exists
try:
    fs.createDir(dir1absolute)
except:
    assert false, "Exception was thrown when creating a directory that already exists"

# Cleanup

# Remove the test directory and all it's contents
removeDir(testDirPath, false)