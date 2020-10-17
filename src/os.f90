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

  include "os.name"

  contains

  ! os.access

  subroutine chdir(path, stat)

    character(len=*), intent(in)   :: path
    integer, intent(out), optional :: stat

    integer(C_INT) :: stat_

    stat_ = chdir_c(f_c_string(path))

    if (present(stat)) then
      stat = int(stat_)
    elseif (stat_ /= 0_C_INT) then
      error stop 'chdir: cannot change directory'
    endif

  end subroutine chdir


  function getcwd()

    character(len=:), allocatable :: getcwd

    character(kind=C_CHAR), dimension(:), allocatable :: cwd
    integer(C_INT)                                    :: stat

    allocate(cwd(PATH_MAX()))

    call getcwd_c(cwd,stat)

    ! An error condition for this function seems a very serious problem
    ! No escape possible?
    ! MD: Ipython also crashes completely if the cwd does not exists

    if(stat /= 0_C_INT) &
      error stop 'getcwd: cannot determine current working directory'

    getcwd = c_f_string(cwd)

  end function getcwd

  !lsdir

  subroutine mkdir(path,mode,stat)

    character(len=*), intent(in) :: path
    integer,          intent(in),  optional :: mode
    integer,          intent(out), optional :: stat

    integer(C_INT) :: mode_, stat_

    if(present(mode)) then
      mode_ = int(mode,C_INT)
    else
      mode_ = int(O'777',C_INT)
    endif

    stat_ = mkdir_c(f_c_string(path),mode_)
    
    if (present(stat)) then
      stat = int(stat_)
    elseif (stat_ /= 0_C_INT) then
      error stop 'mkdir: cannot create directory'
    endif

  end subroutine mkdir


  subroutine rename(src,dst,stat)

    character(len=*), intent(in) :: src,dst
    integer,          intent(out), optional :: stat

    integer(C_INT) :: stat_

    stat_ = rename_c(f_c_string(src),f_c_string(dst))

    if (present(stat)) then
      stat = int(stat_)
    elseif (stat_ /= 0_C_INT) then
      error stop 'rename: cannot rename file/directory'
    endif

  end subroutine rename


  subroutine rmdir(path,stat)

    character(len=*), intent(in) :: path
    integer,          intent(out), optional :: stat

    integer(C_INT) :: stat_

    stat_ = rmdir_c(f_c_string(path))
    
    if (present(stat)) then
      stat = int(stat_)
    elseif (stat_ /= 0_C_INT) then
      error stop 'rmdir: cannot remove directory'
    endif

  end subroutine rmdir


  subroutine symlink(src,dst,stat)

    character(len=*), intent(in) :: src,dst
    integer,          intent(out), optional :: stat

    integer(C_INT) :: stat_

    stat_ = symlink_c(f_c_string(src),f_c_string(dst))

    if (present(stat)) then
      stat = int(stat_)
    elseif (stat_ /= 0_C_INT) then
      error stop 'symlink: cannot create symbolic link'
    endif

  end subroutine symlink


  subroutine unlink(path,stat)

    character(len=*), intent(in) :: path
    integer,          intent(out), optional :: stat

    integer(C_INT) :: stat_

    stat_ = unlink_c(f_c_string(path))
    
    if (present(stat)) then
      stat = int(stat_)
    elseif (stat_ /= 0_C_INT) then
      error stop 'unlink: cannot unlink (delete) file'
    endif

  end subroutine unlink

end module os
