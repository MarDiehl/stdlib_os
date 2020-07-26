########################################################################################
cmake_minimum_required (VERSION 3.10.0 FATAL_ERROR)

project (stdlib Fortran C)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

if (CMAKE_BUILD_TYPE STREQUAL "")
  set (CMAKE_BUILD_TYPE "RELEASE")
endif ()

# Predefined sets for OPTIMIZATION/OPENMP based on BUILD_TYPE
if (CMAKE_BUILD_TYPE STREQUAL "DEBUG" OR CMAKE_BUILD_TYPE STREQUAL "SYNTAXONLY")
    set (DEBUG_FLAGS "${DEBUG_FLAGS} -DDEBUG")
    set (PARALLEL "OFF")
    set (OPTI "OFF")
elseif (CMAKE_BUILD_TYPE STREQUAL "RELEASE")
    set (PARALLEL "ON")
    set (OPTI "DEFENSIVE")
elseif (CMAKE_BUILD_TYPE STREQUAL "PERFORMANCE")
    set (PARALLEL "ON")
    set (OPTI "AGGRESSIVE")
endif ()

# $OPTIMIZATION takes precedence over $BUILD_TYPE defaults
if (OPTIMIZATION STREQUAL "" OR NOT DEFINED OPTIMIZATION)
    set (OPTIMIZATION "${OPTI}")
else ()
    set (OPTIMIZATION "${OPTIMIZATION}")
endif ()

# $OPENMP takes precedence over $BUILD_TYPE defaults
if (OPENMP STREQUAL "" OR NOT DEFINED OPENMP)
    set (OPENMP "${PARALLEL}")
else ()
    set(OPENMP "${OPENMP}")
endif ()

if (CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
  include(Compiler-Intel)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  include(Compiler-GNU)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "PGI")
  include(Compiler-PGI)
else ()
  message (FATAL_ERROR "Compiler type (CMAKE_Fortran_COMPILER_ID) not recognized")
endif ()


set (CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE} "${BUILDCMD_PRE} ${OPENMP_FLAGS} ${STANDARD_CHECK} ${OPTIMIZATION_FLAGS} ${COMPILE_FLAGS} ${PRECISION_FLAGS}")
set (CMAKE_Fortran_LINK_EXECUTABLE           "${BUILDCMD_PRE} ${CMAKE_Fortran_COMPILER} ${OPENMP_FLAGS}   ${OPTIMIZATION_FLAGS} ${LINKER_FLAGS}")

if (CMAKE_BUILD_TYPE STREQUAL "DEBUG")
  set (CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE} "${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}} ${DEBUG_FLAGS}")
  set (CMAKE_Fortran_LINK_EXECUTABLE           "${CMAKE_Fortran_LINK_EXECUTABLE} ${DEBUG_FLAGS}")
endif ()

set (CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}   "${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}} ${BUILDCMD_POST}")
set (CMAKE_Fortran_LINK_EXECUTABLE             "${CMAKE_Fortran_LINK_EXECUTABLE} <OBJECTS> -o <TARGET> <LINK_LIBRARIES> ${BUILDCMD_POST}")

message ("Fortran Compiler Flags:\n${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}}\n")
message ("C Compiler Flags:\n${CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE}}\n")
message ("Fortran Linker Command:\n${CMAKE_Fortran_LINK_EXECUTABLE}\n")

# location of code
add_subdirectory (src)
