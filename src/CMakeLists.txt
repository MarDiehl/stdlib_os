file(GLOB sources *.f90 *.c ${CMAKE_SYSTEM_NAME}/*.f90)

add_executable(stdlib_test ${sources})
install (TARGETS stdlib_test RUNTIME DESTINATION bin)

include_directories(${CMAKE_BINARY_DIR})

if (${MINGW})
  set(OS_SYSTEM_NAME "MINGW")
elseif (${MSYS})
  set(OS_SYSTEM_NAME "MSYS")
else (${MINGW})
  set(OS_SYSTEM_NAME ${CMAKE_SYSTEM_NAME})
endif (${MINGW})

# create a simple include file: identify the operating system
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/os.name.in
  ${CMAKE_BINARY_DIR}/os.name
  )
