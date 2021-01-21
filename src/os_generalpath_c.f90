module os_generalpath_c

  implicit none

  public

  interface

    function getatime_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      real(C_DOUBLE) :: getatime_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function getatime_c

    function getctime_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      real(C_DOUBLE) :: getctime_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function getctime_c

    function getmtime_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      real(C_DOUBLE) :: getmtime_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function getmtime_c

    function getsize_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_LONG) :: getsize_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function getsize_c

    function isfile_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: isfile_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function isfile_c

    function isdir_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: isdir_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function isdir_c

    function islink_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: islink_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function islink_c

    function ismount_c(path) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: ismount_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path
    end function ismount_c

    function samefile_c(path1,path2) bind(C)
      use, intrinsic :: ISO_C_Binding
      integer(C_INT) :: samefile_c
      character(kind=C_CHAR), dimension(*), intent(in) :: path1, path2
    end function samefile_c

  end interface

end module os_generalpath_c
