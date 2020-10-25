# Known limitations

The following issues need to be resolved, as of 25 october 2020:

 * Expanding environment variables does not work if the value is too long. The maximum value is fixed to the value returned by the `path_max()` function.
   See https://unix.stackexchange.com/questions/336934
 * The function `path_max()` should (probably) be replaced by a parameter taken directly from the C header files. This requires some CMake magic.
   One solution: use a small C program that will write out the value
 * The backslash (\) is not properly supported on Windows, making the forward slash the only (and most robust) directory separator character
 * Several functions use ERROR STOP if something goes wrong. This should be changed, but it either requires the function to be non-pure or to use some specific
   value for flagging the error. The subroutines all have an optional argument to capture errors.

   Note:
       - The function `getcwd()` will stop the program with `ERROR STOP` if the current directory cannot be retrieved. This seems a very basic requirement, though,
         so the `ERROR STOP` is probably the correct action.
       - The function `commonpath()` fails in a similar way if absolute and relative paths are combined. This seems incorrect - remediation?
       - The function `substitute()` does so if the indices for substitution are incorrect. Corrective action seems easy and more desirable

 * Absolute paths on the four (!) Windows platforms amy start with a drive letter and colon, even for Cygwin and MSYS that are more or less Unix-like.
   For these platforms we accept the forms "c:/xyz" and "c:\xyz" as well.


 * Document the variables (ford?)
 * Problem with chdir('/home') on MinGW:
   This turns out to be a problem of how MinGW interprets the Windows directories in a Linux style. For instance: "cd /home" works, but chdir("/home")
   does not. A small test program using getcwd() shows that this directory is actually "C:\<msys-installation-directory>\home". So, commands like ls and
   cd translate the Linux style directory name to the proper Windows directory name.

   Okay, I had some help with this: there is the MinGW environment and the MSYS environment. The latter is a Unix-like environment where "/home" means something.
   You get different behaviour of the program, because the runtime libraries are different!

   This means we need to distinguish the MinGW and MSYS environments/platforms.


 * Return integer(int64) or a long integer in any case for time
   Code like the following can be used:

! chkkind.f90 --
!     Check that we can automatically select the right kind of integer
!
program chkkind
    implicit none

    integer, parameter :: kint = merge( selected_int_kind(10), selected_int_kind(8), selected_int_kind(10) > 0 )

    write(*,*) kint
end program chkkind

## Platform-dependent issues
On plain Windows links are not supported in the same way as under Linux or Cygwin. Therefore the subroutine `symlink` is a no-op.

# Extensions

Missing facilities:

 * Currently a facility is missing to return the names of files and directories present in a given directory.
