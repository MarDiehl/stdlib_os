module os_c

  implicit none

  public

  interface

    function chdir_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: chdir_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function chdir_c

    subroutine getcwd_c(path, stat) bind(C)
      use, intrinsic :: ISO_C_Binding
      character(kind=C_CHAR), dimension(*), intent(out) :: path
      integer(C_INT),                       intent(out) :: stat
    end subroutine getcwd_c

    function mkdir_c(path,mode) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: mkdir_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
      integer(C_INT),                       intent(in) :: mode
    end function mkdir_c

    function rename_c(src,dst) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: rename_c
      character(kind=C_CHAR), dimension(*), intent(in) :: src,dst
    end function rename_c

    function rmdir_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: rmdir_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function rmdir_c

    function symlink_c(src,dst) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: symlink_c
      character(kind=C_CHAR), dimension(*), intent(in)  :: src,dst
    end function symlink_c

    function unlink_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: unlink_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function unlink_c

  end interface

end module os_c
