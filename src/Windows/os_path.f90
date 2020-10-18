submodule(os_path) os_path_windows

  contains

  pure module function isabs(path)

    logical                      :: isabs
    character(len=*), intent(in) :: path

    if(len(path) == 0) then
      isabs = .false.
    else
      isabs = path(1:1) == sep

      if ( .not. isabs) isabs = path(2:3) == ':/' .or. path(2:3) == ':\'
    endif

  end function isabs


  module function relpath(path,start)

    character(len=*), intent(in)           :: path
    character(len=*), intent(in), optional :: start
    character(len=:), allocatable          :: relpath

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
      relpath = ''
    else
      if(common_ == sep) then
        relpath = path_(l_common+1:)
      else
        relpath = path_(l_common+2:)
      endif
    endif

    if(start_ /= common_) then
      j = 0
      l_common = max(1,l_common)


      if(start_(2:3) == ':/' .or. start_(2:3) == ':\' ) then
        j = 1
        l_common = 4
      endif

      do i = l_common, len(start_(l_common:))
        if(start_(i:i) == sep) j = j+1
      enddo
      relpath = repeat(curdir//curdir//sep,j)//relpath
    endif

    relpath = normpath(relpath)

  end function relpath

end submodule os_path_windows
