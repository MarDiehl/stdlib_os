module os

  use internal
  use os_c

  implicit none
  character(len=*), parameter, public :: &
    pathsep = ':', &
    curdir = '.'

  private
  public :: &
    chdir, &
    getcwd, &
    mkdir, &
    rename, &
    rmdir, &
    symlink, &
    unlink

  contains

  ! os.access

  subroutine chdir(path)

    character(len=*), intent(in) :: path

    if(chdir_c(f_c_string(path)) /= 0_C_INT) &
      error stop 'chdir: cannot change directory'

  end subroutine chdir


  function getcwd()

    character(len=:), allocatable :: getcwd

    character(kind=C_CHAR), dimension(:), allocatable :: cwd
    integer(C_INT)                                    :: stat

    allocate(cwd(PATH_MAX()))

    call getcwd_c(cwd,stat)
    if(stat /= 0) &
      error stop 'getcwd: cannot determine current working directory'

    getcwd = c_f_string(cwd)

  end function getcwd


  subroutine mkdir(path,mode)

    character(len=*), intent(in) :: path
    integer,          intent(in), optional :: mode

    integer(C_INT) :: mode_

    if(present(mode)) then
      mode_ = int(mode,C_INT)
    else
      mode_ = int(O'777',C_INT)
    endif

    if(mkdir_c(f_c_string(path),mode_) /= 0_C_INT) &
      error stop 'mkdir: cannot create directory'

  end subroutine mkdir


  subroutine rename(src,dst)

    character(len=*), intent(in) :: src,dst

    if(rename_c(f_c_string(src),f_c_string(dst)) /= 0_C_INT) &
      error stop 'rename: cannot rename file/directory'

  end subroutine rename


  subroutine rmdir(path)

    character(len=*), intent(in) :: path

    if(rmdir_c(f_c_string(path)) /= 0_C_INT) &
      error stop 'rmdir: cannot remove directory'

  end subroutine rmdir

  
  subroutine symlink(src,dst)

    character(len=*), intent(in) :: src,dst

    if(symlink_c(f_c_string(src),f_c_string(dst)) /= 0_C_INT) &
      error stop 'symlink: cannot create symbolic link'

  end subroutine symlink


  subroutine unlink(path)

    character(len=*), intent(in) :: path

    if(unlink_c(f_c_string(path)) /= 0_C_INT) &
      error stop 'unlink: cannot unlink (delete) file'

  end subroutine unlink

end module os
