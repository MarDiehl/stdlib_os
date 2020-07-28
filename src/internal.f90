module internal

  use, intrinsic :: ISO_C_Binding

  use internal_c

  implicit none

   public

  integer, parameter :: USER_NAME_MAX = 32


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


  function getuser()

    character(len=:), allocatable :: getuser

    character(kind=C_CHAR), dimension(USER_NAME_MAX+1) :: user
    integer(C_INT)                                     :: stat

    call getuser_c(user,stat)
    if(stat /= 0) &
      error stop 'getuser: cannot determine user name'

    getuser = c_f_string(user)

  end function getuser


  function gethome()

    character(len=:), allocatable :: gethome

    character(kind=C_CHAR), dimension(:), allocatable :: home
    integer(C_INT)                                    :: stat

    allocate(home(PATH_MAX()))
    call gethome_c(home,stat)
    if(stat /= 0) &
      error stop 'gethome: cannot determine home directory'

    gethome = c_f_string(home)

  end function gethome


  ! ToDo: Check whether the header can be used in Fortran (true parameter!)
  function PATH_MAX()

    integer(C_INT) :: PATH_MAX

    PATH_MAX = PATH_MAX_c()

  end function PATH_MAX


end module internal
