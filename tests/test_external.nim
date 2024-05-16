import std/unittest
import sugar

from commonFs import FileSystem
import commonFs/tests

suite "commonFs.Tests":
  
  test "should compile external tests":
    check compiles verifyImplementation(() => FileSystem())