# Known limitations

The following issues need to be resolved, as of 27 september 2020:

 * Expanding environment variables does not work if the value is too long. The maximum value is fixed to the value returned by the `path_max()` function
 * The function `path_max()` should (probably) be replaced by a parameter taken directly from the C header files. This requires some CMake magic.
 * The backslash (\) is not properly supported on Windows, making the forward slash the only (and most robust) directory separator character
 * Several functions use ERROR STOP if something goes wrong. This should be changed, but it either requires the function to be non-pure or to use some specific
   value for flaggin the error. The subroutines all have an optional argument to capture errors.
 * Currently, the MinGW-w64/MSYS2 platform (the full name of "MinGW") is not distinguished from plain Windows.


## Platform-dependent issues
On plain Windows links are not supported in the same way as under Linux or Cygwin. Therefore the subroutine `symlink`

# Extensions

Missing facilities:

 * Currently a facility is missing to return the names of files and directories present in a given directory.
