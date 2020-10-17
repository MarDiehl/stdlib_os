module internal_c
  implicit none

  public

  interface

    subroutine getuser_c(user, stat) bind(C)
      use, intrinsic :: ISO_C_Binding
      character(kind=C_CHAR), dimension(*), intent(out) :: user
      integer(C_INT),                       intent(out) :: stat
    end subroutine getuser_c

    subroutine gethome_c(home, stat) bind(C)
      use, intrinsic :: ISO_C_Binding
      character(kind=C_CHAR), dimension(*), intent(out) :: home
      integer(C_INT),                       intent(out) :: stat
    end subroutine gethome_c

  end interface

end module internal_c
