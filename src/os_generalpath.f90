submodule(os_path) os_generalpath

  use os_general_path_c

  module function getatime(path)

    real(C_DOUBLE)               :: getatime
    character(len=*), intent(in) :: path

    if ( exists(path) ) then
      getatime = getatime_c(f_c_string(path))
      if ( getatime < 0.0 ) then
        getatime = -2.0
      endif
    else
      getatime = -1.0
    endif

  end function getatime


  module function getctime(path)

    real(C_DOUBLE)               :: getctime
    character(len=*), intent(in) :: path

    if ( exists(path) ) then
      getctime = getctime_c(f_c_string(path))
      if(getctime < 0.0) then
         getctime = -2.0
      endif
    else
      getctime = -1.0
    endif

  end function getctime


  module function getmtime(path)

    real(C_DOUBLE)               :: getmtime
    character(len=*), intent(in) :: path

    if ( exists(path) ) then
      getmtime = getmtime_c(f_c_string(path))
      if(getmtime < 0.0) then
        getmtime = -2.0
      endif
    else
      getmtime = -1.0
    endif

  end function getmtime


  module function isfile(path)

    logical                      :: isfile
    character(len=*), intent(in) :: path

    isfile = isfile_c(f_c_string(path)) > 0

  end function isfile


  module function isdir(path)

    logical                      :: isdir
    character(len=*), intent(in) :: path

    isdir = isdir_c(f_c_string(path)) > 0

  end function isdir


  module function islink(path)

    logical                      :: islink
    character(len=*), intent(in) :: path

    islink = islink_c(f_c_string(path)) > 0

  end function islink


  module function ismount(path)

    logical                      :: ismount
    character(len=*), intent(in) :: path

    ismount = ismount_c(f_c_string(path)) > 0

  end function ismount

end submodule os_generalpath
