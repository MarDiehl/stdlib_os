submodule(os_path) os_path

  contains

  pure function isabs(path)

    logical                      :: isabs
    character(len=*), intent(in) :: path

    if(len(path) == 0) then
      isabs = .false.
    else
      isabs = path(1:1) == sep

      select case (os_id)
        case( OS_LINUX, OS_DARWIN )
          ! No action needed

        case( OS_CYGWIN, OS_MSYS, OS_MINGW )
          if ( .not. isabs) isabs = path(2:3) == ':/' .or. path(2:3) == ':\'

        case default
          ! No action needed
      end select
    endif

  end function isabs


  function relpath(path,start) result(r)

    character(len=*), intent(in)           :: path
    character(len=*), intent(in), optional :: start
    character(len=:), allocatable          :: r

    character(len=:), allocatable :: common_, path_, start_
    integer :: l_common, l_path, i, j

    if(isabs(path)) then
      path_ = normpath(path)
    else
      path_ = normpath(join(getcwd(),path))
    endif
    l_path = len(path_)

    if(.not. present(start)) then
      start_ = getcwd()
    else
      if(isabs(start)) then
        start_ = normpath(start)
      else
        start_ = normpath(join(getcwd(),start))
      endif
    endif

    common_ = commonpath(start_,path_)
    l_common = len(common_)

    if(l_path == l_common) then
      r = ''
    else
      if(common_ == sep) then
        r = path_(l_common+1:)
      else
        r = path_(l_common+2:)
      endif
    endif

    if(start_ /= common_) then
      j = 0
      l_common = max(1,l_common)

      do i = l_common, len(start_(l_common:))
        if(start_(i:i) == sep) j = j+1
      enddo
      r = repeat(curdir//curdir//sep,j)//r
    endif

    r = normpath(r)

  end function relpath

end submodule os_path
