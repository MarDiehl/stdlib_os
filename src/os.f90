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

  integer, parameter, public :: OS_LINUX   = 1
  integer, parameter, public :: OS_DARWIN  = 2  ! Canonical name for MacOSX
  integer, parameter, public :: OS_CYGWIN  = 2
  integer, parameter, public :: OS_WINDOWS = 3  ! No difference apparently for plain Windows and MinGW

  include "stdlib_os.inc"

  contains

  ! os.access

  subroutine chdir(path, error)

    character(len=*), intent(in)   :: path
    logical, intent(out), optional :: error

    if ( present(error) ) then
      error = .false.
    endif

    if(chdir_c(f_c_string(path)) /= 0_C_INT) then
      if ( present(error) ) then
        error = .true.
      else
        error stop 'chdir: cannot change directory'
      endif
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

    if(stat /= 0) &
      error stop 'getcwd: cannot determine current working directory'

    getcwd = c_f_string(cwd)

  end function getcwd

  !lsdir

  subroutine mkdir(path,mode,error)

    character(len=*), intent(in) :: path
    integer,          intent(in), optional  :: mode
    logical,          intent(out), optional :: error

    integer(C_INT) :: mode_

    if(present(mode)) then
      mode_ = int(mode,C_INT)
    else
      mode_ = int(O'777',C_INT)
    endif

    if ( present(error) ) then
      error = .false.
    endif

    if(mkdir_c(f_c_string(path),mode_) /= 0_C_INT) then
      if ( present(error) ) then
        error = .true.
      else
        error stop 'mkdir: cannot create directory'
      endif
    endif

  end subroutine mkdir


  subroutine rename(src,dst,error)

    character(len=*), intent(in) :: src,dst
    logical,          intent(out), optional :: error

    if ( present(error) ) then
      error = .false.
    endif

    if(rename_c(f_c_string(src),f_c_string(dst)) /= 0_C_INT) then
      if ( present(error) ) then
        error = .true.
      else
        error stop 'rename: cannot rename file/directory'
      endif
    endif

  end subroutine rename


  subroutine rmdir(path,error)

    character(len=*), intent(in) :: path
    logical,          intent(out), optional :: error

    integer(kind=c_int) :: rc

    if ( present(error) ) then
      error = .false.
    endif

    if(rmdir_c(f_c_string(path)) /= 0_C_INT) then
      if ( present(error) ) then
        error = .true.
      else
        error stop 'rmdir: cannot remove directory'
      endif
    endif

  end subroutine rmdir


  subroutine symlink(src,dst,error)

    character(len=*), intent(in) :: src,dst
    logical,          intent(out), optional :: error

    integer(kind=c_int) :: rc, supported


    if ( present(error) ) then
      error = .false.
    endif

    rc = symlink_c(f_c_string(src),f_c_string(dst), supported )

    if ( rc /= 0_C_INT ) then
      if ( supported == 1_C_INT ) then
        if ( present(error) ) then
          error = .true.
        else
          error stop 'symlink: cannot create symbolic link'
        endif
      else
        if ( present(error) ) then
          error = .true.
        endif
      endif
    endif

  end subroutine symlink


  subroutine unlink(path,error)

    character(len=*), intent(in) :: path
    logical,          intent(out), optional :: error

    if(unlink_c(f_c_string(path)) /= 0_C_INT) then
      if ( present(error) ) then
        error = .true.
      else
        error stop 'unlink: cannot unlink (delete) file'
      endif
    endif

  end subroutine unlink

end module os
