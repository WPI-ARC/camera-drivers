# find flycapture2
#
# exports:
#
#   FLYCAPTURE2_FOUND
#   FLYCAPTURE2_INCLUDE_DIRS
#   FLYCAPTURE2_LIBRARIES
#


INCLUDE(FindPackageHandleStandardArgs)

SET(FlyCapture_IncludeSearchPaths
  /usr/include/flycapture/
)

SET(FlyCapture_LibrarySearchPaths
  /usr/lib/
)

FIND_PATH(FLYCAPTURE2_INCLUDE_DIRS FlyCapture2.h
  PATHS ${FlyCapture_IncludeSearchPaths}
)
FIND_LIBRARY(FLYCAPTURE2_LIBRARIES
  NAMES flycapture
  PATHS ${FlyCapture_LibrarySearchPaths}
)

# Handle the REQUIRED argument and set the <UPPERCASED_NAME>_FOUND variable
FIND_PACKAGE_HANDLE_STANDARD_ARGS(FlyCapture2 "Could NOT find Flycapture2. Only required for testing purposes. Please continue."
  FLYCAPTURE2_LIBRARIES
  FLYCAPTURE2_INCLUDE_DIRS
)

IF(FLYCAPTURE2_FOUND)
  FIND_PACKAGE_MESSAGE(FLYCAPTURE2_FOUND "Found Fly Capture SDK  ${FLYCAPTURE2_LIBRARIES}" "[${FLYCAPTURE2_LIBRARIES}][${FLYCAPTURE2_INCLUDE_DIRS}]")
ENDIF(FLYCAPTURE2_FOUND)

MARK_AS_ADVANCED(
  FLYCAPTURE2_INCLUDE_DIRS
  FLYCAPTURE2_LIBRARIES
)

