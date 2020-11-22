file(GLOB sources *.f90 *.c ${CMAKE_SYSTEM_NAME}/*.f90)

add_executable(stdlib_test ${sources})
install (TARGETS stdlib_test RUNTIME DESTINATION bin)

include_directories(${CMAKE_BINARY_DIR})

# https://gitlab.kitware.com/cmake/community/-/wikis/doc/tutorials/How-To-Write-Platform-Checks
if     (${MINGW})
  set(OS_SYSTEM_NAME "MINGW")
  set(OS_SYSTEM_TYPE "MINGW")
elseif (${MSYS})
  set(OS_SYSTEM_NAME "MSYS")
  set(OS_SYSTEM_TYPE "MSYS")
elseif (${UNIX})
  set(OS_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})
  set(OS_SYSTEM_TYPE "Posix")
elseif (${WIN32})
  set(OS_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})
  set(OS_SYSTEM_TYPE "WINDOWS")
else  (${MINGW})
  message(FATAL_ERROR "Unknown system")
endif (${MINGW})

# create a simple include file: identify the operating system
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/os.name.in
  ${CMAKE_BINARY_DIR}/os.name
  )
