type
  FileSystemError* = object of CatchableError
    ## Raised if there is something wrong with the file system,
    ## e.g. OS partition is no longer available, SFTP connection
    ## can't be established, etc.
  
  InvalidPathError* = object of CatchableError
    ## Raised if the provided path is invalid, e.g. contains
    ## forbidden characters, is too long, etc.