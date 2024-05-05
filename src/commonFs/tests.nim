import sugar
import commonFs

import private/test_dirExists
import private/test_fileExists
import private/test_createDir
import private/test_createFile
import private/test_removeDir
import private/test_removeFile

proc verifyImplementation*(fsConstructor: () -> FileSystem) =
  verifyDirExistsImpl(fsConstructor)
  verifyFileExistsImpl(fsConstructor)
  verifyCreateDirImpl(fsConstructor)
  verifyCreateFileImpl(fsConstructor)
  verifyRemoveDirImpl(fsConstructor)
  verifyRemoveFileImpl(fsConstructor)
