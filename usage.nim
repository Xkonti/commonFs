import std/paths
import commonFs/commonFs
import osFs/osFs
# import inMemoryFs/inMemoryFs

let path = "/home/xkonti/test-directory".Path

var fs = new(OsFs)
# var fs = newInMemoryFS()

if fs.dirExists(path):
  echo "Directory already exists: deleting..."
  fs.removeDir(path)
  echo "Directory deleted"
else:
  fs.createDir(path)
  echo "Directory created"
