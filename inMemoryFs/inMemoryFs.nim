#import std/paths
import ../commonFs/commonFs

type
    InMemoryFS = ref object of FileSystem

proc newInMemoryFS*(): FileSystem =
    return new(InMemoryFS)

