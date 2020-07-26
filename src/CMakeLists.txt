file(GLOB sources *.f90 *.c)

add_executable(stdlib_test ${sources})
install (TARGETS stdlib_test RUNTIME DESTINATION bin)
      
