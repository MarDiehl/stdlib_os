file(GLOB sources *.f90 *.F90 *.c)
list(FILTER sources EXCLUDE REGEX ".*posix.*")
list(FILTER sources EXCLUDE REGEX ".*windows.*")

add_library(
  "${PROJECT_NAME}_lib"
  "${sources}"
)
set_target_properties(
  "${PROJECT_NAME}_lib"
  PROPERTIES
  OUTPUT_NAME "${PROJECT_NAME}"
  Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include"
)
target_include_directories(
  "${PROJECT_NAME}_lib"
  INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
  $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
install(
  TARGETS "${PROJECT_NAME}_lib"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

# https://gitlab.kitware.com/cmake/community/-/wikis/doc/tutorials/How-To-Write-Platform-Checks
if     (${MINGW})
  set(OS_SYSTEM_NAME "MINGW")
  set(OS_SYSTEM_TYPE "windows")
elseif (${MSYS})
  set(OS_SYSTEM_NAME "MSYS")
  set(OS_SYSTEM_TYPE "windows")
elseif (${UNIX})
  set(OS_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})
  set(OS_SYSTEM_TYPE "posix")
elseif (${WIN32})
  set(OS_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})
  set(OS_SYSTEM_TYPE "windows")
else  (${MINGW})
  message(FATAL_ERROR "Unknown system")
endif (${MINGW})

add_compile_definitions(OS_SYSTEM_NAME=${OS_SYSTEM_NAME})
add_compile_definitions(OS_SYSTEM_ID=OS_${OS_SYSTEM_NAME})
add_compile_definitions(OS_SYSTEM_TYPE=${OS_SYSTEM_TYPE})
