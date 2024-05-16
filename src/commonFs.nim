import std/paths
import std/options

#[
  BASE TYPES
]#
include commonFs/private/errors
include commonFs/private/types

#[
  FILESYSTEM OPERATIONS
]#
include commonFs/private/fs_currentDirOps

#[
  DIRECTORY OPERATIONS
]#
include commonFs/private/dir_basicOps

#[
  FILE OPERATIONS
]#

include commonFs/private/file_basicOps
include commonFs/private/file_readStringOps
include commonFs/private/file_readBytesOps
include commonFs/private/file_writeStringOps
include commonFs/private/file_writeBytesOps

#[
  COMMON OPERATIONS
]#
include commonFs/private/common_Ops