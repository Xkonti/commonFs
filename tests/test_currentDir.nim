# MIT Licence
# Copyright (c) 2024 by Beniamin Dudek aka Xkonti

import std/unittest
import std/paths

import commonFs

suite "CommonFs.currentDir":
  var fs: FileSystem

  setup:
    fs = new(FileSystem)

  test "should be an absolute path by default":
    check(fs.currentDir.isAbsolute)

  test "should be an absolute path after changing via relative path":
    fs.currentDir = "test/here".Path
    check(fs.currentDir.isAbsolute)
    check(fs.currentDir == "/test/here".Path)
    fs.currentDir = "../test/here".Path
    check(fs.currentDir.isAbsolute)
    check(fs.currentDir == "/test/test/here".Path)

  test "should be an absolute path after changing via absolute path":
    fs.currentDir = "/test/here".Path
    check(fs.currentDir.isAbsolute)
    check(fs.currentDir == "/test/here".Path)

suite "CommonFs.getAbsolutePathTo":
  var fs: FileSystem

  setup:
    fs = new(FileSystem)
    fs.currentDir = "/test".Path

  test "should return current dir if path is empty":
    let path = fs.getAbsolutePathTo("".Path)
    check(path.isAbsolute)
    check(path == fs.currentDir)

  test "should return current dir if path is '.'":
    let path = fs.getAbsolutePathTo(".".Path)
    check(path.isAbsolute)
    check(path == fs.currentDir)

  test "should return current dir if path is './'":
    let path = fs.getAbsolutePathTo("./".Path)
    check(path.isAbsolute)
    check(path == fs.currentDir)

  test "should return current dir if path is './.'":
    let path = fs.getAbsolutePathTo("./.".Path)
    check(path.isAbsolute)
    check(path == fs.currentDir)

  test "should return current dir if path is '././'":
    let path = fs.getAbsolutePathTo("././".Path)
    check(path.isAbsolute)
    check(path == fs.currentDir)

  test "should return absolute path if path is relative":
    var path = fs.getAbsolutePathTo("test/here".Path)
    check(path.isAbsolute)
    check(path == "/test/test/here".Path)

  test "should return absolute path if path is absolute":
    let path = fs.getAbsolutePathTo("/hello/there".Path)
    check(path.isAbsolute)
    check(path == "/hello/there".Path)

  test "should not modify fs current dir":
    discard fs.getAbsolutePathTo("test/here".Path)
    check(fs.currentDir == "/test".Path)