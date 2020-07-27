module os

  use internal
  use os_c

  implicit none
  character, parameter, public :: pathsep = ':'
  
  private
  public :: &
    chdir, &
    getcwd, &
    mkdir, &
    rename, &
    rmdir, &
    unlink
  
  contains

  ! os.access
  
  subroutine chdir(path)
    
    character(len=*), intent(in) :: path
    
    if(chdir_c(f_to_c_path(path)) /= 0_C_INT) &
      error stop 'chdir: cannot change directory'

  end subroutine chdir
  

  function getcwd()
    
    character(len=:), allocatable :: getcwd
    
    character(kind=C_CHAR), dimension(maxPathLen_c) :: cwd
    integer(C_INT)                                  :: stat

    call getcwd_c(cwd,stat)
    if(stat /= 0) &
      error stop 'getcwd: cannot determine current working directory'

    getcwd = c_to_f_path(cwd)

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
 
    if(mkdir_c(f_to_c_path(path),mode_) /= 0_C_INT) &
      error stop 'mkdir: cannot create directory'
    
  end subroutine mkdir
  
 
  subroutine rename(src,dst)
    
    character(len=*), intent(in) :: src,dst
    
    if(rename_c(f_to_c_path(src),f_to_c_path(dst)) /= 0_C_INT) &
      error stop 'rename: cannot rename file/directory'
    
  end subroutine rename
  
  
  subroutine rmdir(path)
    
    character(len=*), intent(in) :: path
    
    if(rmdir_c(f_to_c_path(path)) /= 0_C_INT) &
      error stop 'rmdir: cannot remove directory'
    
  end subroutine rmdir
  
  ! os.symlink
 
  subroutine unlink(path)
    
    character(len=*), intent(in) :: path
    
    if(unlink_c(f_to_c_path(path)) /= 0_C_INT) &
      error stop 'unlink: cannot unlink (delete) file'
    
  end subroutine unlink

end module os
