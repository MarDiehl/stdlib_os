  pure function isabs(path)

    logical                      :: isabs
    character(len=*), intent(in) :: path

    if(len(path) == 0) then
      isabs = .false.
    else
      isabs = path(1:1) == sep
      if ( .not. isabs) isabs = path(2:3) == ':/' .or. path(2:3) == ':\' ! MD: this is not safe (need to check len first!)
    endif

  end function isabs


  function relpath(path,start)

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
      start_ = trim_sep(getcwd())
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


      if(start_(2:3) == ':/' .or. start_(2:3) == ':\' ) then ! is this safe?
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


  pure function basename(path)

    character(len=:), allocatable :: basename
    character(len=*), intent(in)  :: path
    integer :: pos

    if(len_trim(path) == 0) then
      basename = ''
    else
      pos = scan(path,allsep,back=.true.)
      if(pos == 0) then
        basename = trim(path)
      elseif(pos == len_trim(path)) then
        basename = ''
      else
        basename = path(pos+1:)
      endif
    endif

  end function basename


  pure function dirname(path)

    character(len=:), allocatable :: dirname
    character(len=*), intent(in)  :: path
    integer :: pos

    if(len_trim(path) == 0) then
      dirname = ''
    elseif(verify(path,allsep) == 0) then
      dirname = trim(path)
    else
      pos = scan(path,allsep,back=.true.)
      if(pos == 0) then
        dirname = ''
      else
        dirname = path(:pos)
        if(verify(dirname,allsep) /= 0) then
          do pos=pos,1,-1
            if(dirname(pos:pos) == sep .or. dirname(pos:pos) == winsep) then
              dirname = dirname(:pos-1)
            else
              exit
            endif
          enddo
        endif
      endif
    endif

  end function dirname
