module internal
  
  use, intrinsic :: ISO_C_Binding
  
  implicit none
  public
  
  integer, parameter :: maxPathLen = 4096
  integer, parameter :: maxPathLen_c = maxPathLen + 1 ! NULL terminated
  
  contains

  pure function c_f_string(c_string) result(f_string)
  
    character(kind=C_CHAR), dimension(:), intent(in) :: c_string
    character(len=:),       allocatable              :: f_string
    integer :: i
  
    allocate(character(len=size(c_string))::f_string)
    arrayToString: do i=1,len(f_string)
      if (c_string(i) /= C_NULL_CHAR) then
        f_string(i:i)=c_string(i)
      else
        f_string = f_string(:i-1)
        exit
      endif
    enddo arrayToString
  
  end function c_f_string

 
  pure function f_c_string(f_string) result(c_string)
  
    character(len=*), intent(in)                       :: f_string
    character(kind=C_CHAR), dimension(len(f_string)+1) :: c_string
    integer :: i

    do i=1,len(f_string)
      c_string(i)=f_string(i:i)
    enddo
    c_string(i) = C_NULL_CHAR
  
  end function f_c_string


end module internal
