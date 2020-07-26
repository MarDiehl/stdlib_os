module internal
  
  use, intrinsic :: ISO_C_Binding
  
  implicit none
  public
  
  integer, parameter :: maxPathLen = 4096
  integer, parameter :: pathLen_c  = maxPathLen + 1 ! NULL terminated
  
  contains

  pure function c_to_f_path(c_path) result(f_path)
  
    character(kind=C_CHAR), dimension(pathLen_c), intent(in) :: c_path
    character(len=:),       allocatable                      :: f_path
    integer :: i
  
    allocate(character(len=maxPathLen)::f_path)
    arrayToString: do i=1,len(f_path)
      if (c_path(i) /= C_NULL_CHAR) then
        f_path(i:i)=c_path(i)
      else
        f_path = f_path(:i-1)
        exit
      endif
    enddo arrayToString
  
  end function c_to_f_path

 
  pure function f_to_c_path(f_path) result(c_path)
  
    character(len=*), intent(in) :: f_path
    character(kind=C_CHAR), dimension(pathLen_c) :: c_path
    integer :: i

    call check_path_len(f_path)
  
    c_path = repeat(C_NULL_CHAR,len(c_path))
    do i=1,len(f_path)
      c_path(i)=f_path(i:i)
    enddo
  
  end function f_to_c_path
  
  
  pure subroutine check_path_len(path)
  
    character(len=*), intent(in) :: path
    
    if(len_trim(path) > maxPathLen) error stop

  end subroutine check_path_len


end module internal
