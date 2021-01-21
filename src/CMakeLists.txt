file(GLOB SOURCES *.f90 *.c)

include_directories(${CMAKE_BINARY_DIR})

# https://gitlab.kitware.com/cmake/community/-/wikis/doc/tutorials/How-To-Write-Platform-Checks
if     (${MINGW})
  set(OS_SYSTEM_NAME "MINGW")
  set(OS_SYSTEM_TYPE "MINGW")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/os_posixpath.f90")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/test_posixpath.f90")
elseif (${MSYS})
  set(OS_SYSTEM_NAME "MSYS")
  set(OS_SYSTEM_TYPE "MSYS")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/os_posixpath.f90")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/test_posixpath.f90")
elseif (${UNIX})
  set(OS_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})
  set(OS_SYSTEM_TYPE "Posix")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/os_ntpath.f90")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/test_ntpath.f90")
elseif (${WIN32})
  set(OS_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})
  set(OS_SYSTEM_TYPE "WINDOWS")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/os_posixpath.f90")
  list(REMOVE_ITEM SOURCES "${CMAKE_SOURCE_DIR}/src/test_posixpath.f90")
else  (${MINGW})
  message(FATAL_ERROR "Unknown system")
endif (${MINGW})

add_executable(stdlib_test ${SOURCES})
install (TARGETS stdlib_test RUNTIME DESTINATION bin)

# create a simple include file: identify the operating system
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/os.name.in
  ${CMAKE_BINARY_DIR}/os.name
  )
