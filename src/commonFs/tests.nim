import sugar
import commonFs

import private/tests/test_dirExists
import private/tests/test_fileExists
import private/tests/test_createDir
import private/tests/test_createFile
import private/tests/test_removeDir
import private/tests/test_removeFile
import private/tests/test_readString
import private/tests/test_readBytes
import private/tests/test_write

proc verifyImplementation*(fsConstructor: () -> FileSystem) =
  verifyDirExistsImpl(fsConstructor)
  verifyFileExistsImpl(fsConstructor)
  verifyCreateDirImpl(fsConstructor)
  verifyCreateFileImpl(fsConstructor)
  verifyRemoveDirImpl(fsConstructor)
  verifyRemoveFileImpl(fsConstructor)
  verifyReadStringImpl(fsConstructor)
  verifyReadBytesImpl(fsConstructor)
  verifyWriteImpl(fsConstructor)
