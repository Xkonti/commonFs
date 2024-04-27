import std/paths
import commonFs/commonFs
import osFs/osFs
# import inMemoryFs/inMemoryFs

let dirPath = "/home/xkonti/test-directory".Path

var fs = newOsFs()
# var fs = newInMemoryFS()

if fs.dirExists(dirPath):
  echo "Directory already exists: deleting..."
  fs.removeDir(dirPath)
  echo "Directory deleted"
else:
  fs.createDir(dirPath)
  echo "Directory created"

let filePath = "/home/xkonti/test-directory/test-file.txt".Path

if fs.fileExists(filePath):
  echo "File exists"
  fs.removeFile(filePath)
  echo "File deleted"
else:
  let file = fs.createFile(filePath)
  echo "File created"
  echo "The created file exists: ", file.exists