# stdlib-os

Fortran version of python's os module (selected routines only)

## Getting started

```
export FC=gfortran # or ifort or pgfortran
export CC=gcc      # or icc or pgcc
mkdir build
cd build
cmake .. -DCMAKE_Fortran_COMPILER=$FC -DCMAKE_C_COMPILER=$CC
make
./src/stdlib_test
```

## Prerequisites
- Fortran/C compiler
  - GNU, version 8.0 or newer (`gfortran`/`gcc`)
  - Intel, version 18.0 or newer (`ifort`/`icc`)
  - PGI, not tested (`pgfortran`/`pgcc`)
- cmake, version 3.10 or newer
