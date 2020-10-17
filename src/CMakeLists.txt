file(GLOB sources *.f90 *.c ${CMAKE_SYSTEM_NAME}/*.f90)

add_executable(stdlib_test ${sources})
install (TARGETS stdlib_test RUNTIME DESTINATION bin)

include_directories(${CMAKE_BINARY_DIR})

# create a simple include file: identify the operating system
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/stdlib_os.inc.in
  ${CMAKE_BINARY_DIR}/stdlib_os.inc
  )
