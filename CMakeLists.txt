########################################################################################
cmake_minimum_required (VERSION 3.14.0 FATAL_ERROR)

project(
  "stdlib_os"
  Fortran C
)

# Follow GNU conventions for installing directories
include(GNUInstallDirs)

# location of code
add_subdirectory (src)

enable_testing()
add_subdirectory (test)
