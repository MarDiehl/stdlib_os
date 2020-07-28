module stdlib

  use os
  use os_path

  implicit none

  private

  character, parameter, public :: os_pathsep = pathsep

  interface stdlib_os_chdir
    module procedure chdir
  end interface stdlib_os_chdir

  interface stdlib_os_getcwd
    module procedure getcwd
  end interface stdlib_os_getcwd

  interface stdlib_os_mkdir
    module procedure mkdir
  end interface stdlib_os_mkdir

  interface stdlib_os_rename
    module procedure rename
  end interface stdlib_os_rename

  interface stdlib_os_rmdir
    module procedure rmdir
  end interface stdlib_os_rmdir

  interface stdlib_os_symlink
    module procedure symlink
  end interface stdlib_os_symlink

  interface stdlib_os_unlink
    module procedure unlink
  end interface stdlib_os_unlink


  interface stdlib_os_path_abspath
    module procedure abspath
  end interface stdlib_os_path_abspath

  interface stdlib_os_path_basename
    module procedure basename
  end interface stdlib_os_path_basename

  interface stdlib_os_path_commonpath
    module procedure commonpath1
    module procedure commonpath2
    module procedure commonpath3
    module procedure commonpath4
    module procedure commonpath5
  end interface stdlib_os_path_commonpath

  interface stdlib_os_path_commonprefix
    module procedure commonprefix
  end interface stdlib_os_path_commonprefix

  interface stdlib_os_path_dirname
    module procedure dirname
  end interface stdlib_os_path_dirname

  interface stdlib_os_path_exists
    module procedure exists
  end interface stdlib_os_path_exists

  interface stdlib_os_path_expanduser
    module procedure expanduser
  end interface stdlib_os_path_expanduser

  interface stdlib_os_path_expandvars
    module procedure expandvars
  end interface stdlib_os_path_expandvars

  interface stdlib_os_path_getatime
    module procedure getatime
  end interface stdlib_os_path_getatime

  interface stdlib_os_path_getctime
    module procedure getctime
  end interface stdlib_os_path_getctime

  interface stdlib_os_path_getmtime
    module procedure getmtime
  end interface stdlib_os_path_getmtime

  interface stdlib_os_path_getsize
    module procedure getsize
  end interface stdlib_os_path_getsize

  interface stdlib_os_path_isabs
    module procedure isabs
  end interface stdlib_os_path_isabs

  interface stdlib_os_path_isdir
    module procedure isdir
  end interface stdlib_os_path_isdir

  interface stdlib_os_path_isfile
    module procedure isfile
  end interface stdlib_os_path_isfile

  interface stdlib_os_path_islink
    module procedure islink
  end interface stdlib_os_path_islink

  interface stdlib_os_path_ismount
    module procedure ismount
  end interface stdlib_os_path_ismount
  
  interface stdlib_os_path_join
    module procedure join1
    module procedure join2
    module procedure join3
    module procedure join4
    module procedure join5
  end interface stdlib_os_path_join
  !  normcase, &
  interface stdlib_os_path_normpath
    module procedure normpath
  end interface stdlib_os_path_normpath

  interface stdlib_os_path_relpath
    module procedure relpath
  end interface stdlib_os_path_relpath

  interface stdlib_os_path_samefile
    module procedure samefile
  end interface stdlib_os_path_samefile

  interface stdlib_os_path_split
    module procedure split
  end interface stdlib_os_path_split

  interface stdlib_os_path_splitext
    module procedure splitext
  end interface stdlib_os_path_splitext


  public :: &
    stdlib_os_chdir, &
    stdlib_os_getcwd, &
    stdlib_os_mkdir, &
    stdlib_os_rename, &
    stdlib_os_rmdir, &
    stdlib_os_symlink, &
    stdlib_os_unlink, &
    stdlib_os_path_abspath, &
    stdlib_os_path_basename, &
    stdlib_os_path_commonpath, &
    stdlib_os_path_commonprefix, &
    stdlib_os_path_dirname, &
    stdlib_os_path_exists, &
    stdlib_os_path_expanduser, &
    stdlib_os_path_expandvars, &
    stdlib_os_path_getatime, &
    stdlib_os_path_getmtime, &
    stdlib_os_path_getctime, &
    stdlib_os_path_getsize, &
    stdlib_os_path_isabs, &
    stdlib_os_path_isdir, &
    stdlib_os_path_isfile, &
    stdlib_os_path_islink, &
    stdlib_os_path_ismount, &
    stdlib_os_path_join, &
    !stdlib_os_path_normcase, &
    stdlib_os_path_normpath, &
    stdlib_os_path_samefile, &
    stdlib_os_path_relpath, &
    stdlib_os_path_split, &
    stdlib_os_path_splitext

end module stdlib
