module os_path

  use internal
  use os
  use os_path_c

  implicit none
  character(len=*), parameter, public :: sep = '/'

  private
  public :: &
    abspath, &
    basename, &
    commonpath, &
    commonprefix, &
    dirname, &
    exists, &
    expanduser, &
    expandvars, &
    getatime, &
    getmtime, &
    getctime, &
    getsize, &
    isabs, &
    isdir, &
    isfile, &
    islink, &
    ismount, &
    join, &
    normcase, &
    normpath, &
    samefile, &
    relpath

  public :: &
    commonpath1, &
    commonpath2, &
    commonpath3, &
    commonpath4, &
    commonpath5, &
    join1, &
    join2, &
    join3, &
    join4, &
    join5

  interface commonpath
    module procedure commonpath1
    module procedure commonpath2
    module procedure commonpath3
    module procedure commonpath4
    module procedure commonpath5
  end interface commonpath

  interface join
    module procedure join1
    module procedure join2
    module procedure join3
    module procedure join4
    module procedure join5
  end interface join

  contains

  function abspath(path)

    character(len=:), allocatable :: abspath
    character(len=*), intent(in)  :: path

    abspath = normpath(join(getcwd(),path))

  end function abspath


  pure function basename(path)

    character(len=:), allocatable :: basename
    character(len=*), intent(in)  :: path
    integer :: pos

    if(len_trim(path) == 0) then
      basename = ''
    else
      pos = scan(path,sep,back=.true.)
      if(pos == 0) then
        basename = trim(path)
      elseif(pos == len_trim(path)) then
        basename = ''
      else
        basename = path(pos+1:)
      endif
    endif

  end function basename


  pure function commonpath1(path1) result(commonpath)

    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1

    commonpath = trim(path1)

  end function commonpath1

  pure function commonpath2(path1,path2) result(commonpath)

    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2

    character(len=:), allocatable :: path1_clean, path2_clean
    integer :: i,j

    if(isabs(path1) .neqv. isabs(path2)) &
      error stop 'commonpath: cannot mix absolute and relative paths'

    path1_clean = clean(path1)//sep
    path2_clean = clean(path2)//sep
    if(path1_clean == path2_clean) then
      commonpath = clean(path1_clean)
    else
      j = 0
      do i=1,min(len_trim(path1_clean),len_trim(path2_clean))
        if(path1_clean(i:i) /= path2_clean(i:i)) exit
        if(path1_clean(i:i) == sep) j = i
      enddo
      commonpath = clean_trail(path1_clean(:j))
    endif

  end function commonpath2

  pure function commonpath3(path1,path2,path3) result(commonpath)

    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2,path3

    commonpath = commonpath2(commonpath2(path1,path2),path3)

  end function commonpath3

  pure function commonpath4(path1,path2,path3,path4) result(commonpath)

    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2,path3,path4

    commonpath = commonpath3(commonpath2(path1,path2),path3,path4)

  end function commonpath4

  pure function commonpath5(path1,path2,path3,path4,path5) result(commonpath)

    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2,path3,path4,path5

    commonpath = commonpath4(commonpath2(path1,path2),path3,path4,path5)

  end function commonpath5


  function commonprefix(path1,path2)

    character(len=:), allocatable :: commonprefix
    character(len=*), intent(in)  :: path1, path2

    integer :: i

    do i=1,min(len_trim(path1),len_trim(path2))
      if(path1(i:i) /= path2(i:i)) exit
    enddo
    commonprefix = path1(:i-1)

  end function commonprefix


  pure function dirname(path)

    character(len=:), allocatable :: dirname
    character(len=*), intent(in)  :: path
    integer :: pos

    if(len_trim(path) == 0) then
      dirname = ''
    elseif(verify(path,sep) == 0) then
      dirname = trim(path)
    else
      pos = scan(path,sep,back=.true.)
      if(pos == 0) then
        dirname = ''
      else
        dirname = path(:pos)
        if(verify(dirname,sep) /= 0) then
          do pos=pos,1,-1
            if(dirname(pos:pos) == sep) then
              dirname = dirname(:pos-1)
            else
              exit
            endif
          enddo
        endif
      endif
    endif

  end function dirname


  function exists(path)

    logical                      :: exists
    character(len=*), intent(in) :: path

    inquire(file=path,exist=exists)

  end function exists


  pure function expanduser(path)

    character(len=:), allocatable :: expanduser
    character(len=*), intent(in)  :: path

  end function expanduser


  function expandvars(path)
    ! ToDo: get working and write for arbitrary length
    character(len=:), allocatable :: expandvars
    character(len=*), intent(in)  :: path

    character(len=*), parameter :: valid_chars='ABCDEFGHIJKLMNOPQRSTUVWXYZ'&
                                              &'abcdefghijklmnopqrstuvwxyz'&
                                              &'1234567890'&
                                              &'{}'&
                                              &'_'
    character(len=4096)         :: path_new, var_value
    character(len=:), allocatable :: var_name
    integer :: i,j,s,e

    i = 1
    j = 1
    do while(i<len_trim(path))
      if(path(i:i) == '$') then
        if(len_trim(path) == i) then
          path_new(j:j) = path(i:i)
          i = i + 1
        else
          s = i + 1
          e = s + verify(path(i+1:),valid_chars)
          if(e==s) e = len_trim(path)
          var_name = path(e:s)
          if(var_name(1:1) == '{' .and. var_name(len_trim(var_name):len_trim(var_name)) == '}') &
            var_name = var_name(2:len_trim(var_name)-1)

          call get_environment_variable(var_name,var_value)

          i = e + 1
        endif
      else
        path_new(j:j) = path(i:i)
        i = i + 1
        j = j + 1
      endif
    enddo

  end function expandvars


  function getatime(path)

    real(C_DOUBLE)               :: getatime
    character(len=*), intent(in) :: path

    getatime = getatime_c(f_c_string(path))
    if(getatime < 0.0) &
      error stop 'getatime: could not determine file access time'

  end function getatime


  function getctime(path)

    real(C_DOUBLE)               :: getctime
    character(len=*), intent(in) :: path

    getctime = getctime_c(f_c_string(path))
    if(getctime < 0.0) &
      error stop 'getctime: could not determine file creation time'

  end function getctime


  function getmtime(path)

    real(C_DOUBLE)               :: getmtime
    character(len=*), intent(in) :: path

    getmtime = getmtime_c(f_c_string(path))
    if(getmtime < 0.0) &
      error stop 'getmtime: could not determine file modification time'

  end function getmtime


  function getsize(path)

    integer(C_LONG)              :: getsize
    character(len=*), intent(in) :: path

    getsize = getsize_c(f_c_string(path))
    if(getsize < 0) &
      error stop 'getsize: could not determine file size'

  end function getsize


  pure function isabs(path)

    logical                      :: isabs
    character(len=*), intent(in) :: path

    if(len(path) == 0) then
      isabs = .false.
    else
      isabs = path(1:1) == sep
    endif

  end function isabs


  function isfile(path)

    logical                      :: isfile
    character(len=*), intent(in) :: path

    isfile = isfile_c(f_c_string(path)) > 0

  end function isfile


  function isdir(path)

    logical                      :: isdir
    character(len=*), intent(in) :: path

    isdir = isdir_c(f_c_string(path)) > 0

  end function isdir


  function islink(path)

    logical                      :: islink
    character(len=*), intent(in) :: path

    islink = islink_c(f_c_string(path)) > 0

  end function islink


  function ismount(path)

    logical                      :: ismount
    character(len=*), intent(in) :: path

    ismount = ismount_c(f_c_string(path)) > 0

  end function ismount


  pure function join1(path1) result(join)

    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1

    join = trim(path1)

  end function join1

  pure function join2(path1,path2) result(join)

    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2

    if(isabs(path2)) then
      join = trim(path2)
    else
      join = trim(path1)//sep//trim(path2)
    endif

  end function join2

  pure function join3(path1,path2,path3) result(join)

    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2, path3

    join = join2(join2(path1,path2),path3)

  end function join3

  pure function join4(path1,path2,path3,path4) result(join)

    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2, path3, path4

    join = join3(join2(path1,path2),path3,path4)

  end function join4

  pure function join5(path1,path2,path3,path4,path5) result(join)

    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2, path3, path4, path5

    join = join4(join2(path1,path2),path3,path4,path5)

  end function join5


  pure function normcase(path)

    character(len=:), allocatable :: normcase
    character(len=*), intent(in)  :: path

    normcase = trim(path)

  end function normcase


  ! Note: Two leading slashes theoretically require special treatment
  pure function normpath(path)

    character(len=*), intent(in)  :: path
    character(len=:), allocatable :: normpath

    integer :: i

    if(len_trim(path) == 0) then
      normpath = curdir
    else
      normpath = clean(path)
      do
        normpath = clean(normpath)
        i = index(normpath,sep//curdir//curdir)
        if(i==0 .or. verify(normpath(:i-1),sep//curdir)==0) exit
        normpath = normpath(:index(normpath(:i-1),sep,back=.true.))//normpath(min(i+4,len(normpath)):)
      enddo
    endif

  end function normpath

  ! realpath

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
      do i = l_common, len(start_(l_common:))
        if(start_(i:i) == sep) j = j+1
      enddo
      relpath = repeat(curdir//curdir//sep,j)//relpath
    endif

    relpath = normpath(relpath)

  end function relpath


  function samefile(path1,path2)

    logical                      :: samefile
    character(len=*), intent(in) :: path1, path2
    integer(C_INT)               :: return_value

    return_value = samefile_c(f_c_string(path1),f_c_string(path2))

    if(return_value == -1) &
      error stop 'samefile: cannot access file(s)'
    samefile = return_value > 0

  end function samefile

  ! split

  ! splitdrive

  ! splitext


!--------------------------------------------------------------------------------------------------
  pure function clean(p) result(p_)

    character(len=:), allocatable :: p_
    character(len=*), intent(in)  :: p

    p_ = clean_trail(clean_lead(remove_sep(remove_curdir(p))))

  end function clean


  pure function clean_lead(p) result(p_)

    character(len=:), allocatable :: p_
    character(len=*), intent(in)  :: p

    p_ = trim(p)
    do while (index(p_,sep//curdir//curdir) == 1)
       if(len(p_)>3) then
         p_ = p_(4:)
       else
         p_ = sep
       endif
    enddo

  end function clean_lead

  pure function clean_trail(p) result(p_)

    character(len=:), allocatable :: p_
    character(len=*), intent(in)  :: p

    p_ = trim(p)
    if(len_trim(p_)>1) then
      if(p_(len_trim(p_):len_trim(p_)) == curdir .and. p_(len_trim(p_)-1:len_trim(p_)-1) == sep) &
        p_ = p_(:len_trim(p_)-1)
    endif

    if(len_trim(p_)>1) then
      if(p_(len_trim(p_):len_trim(p_)) == sep) p_ = p_(:len_trim(p_)-1)
    endif

  end function clean_trail


  pure function remove_curdir(p) result(p_)

    character(len=:), allocatable :: p_
    character(len=*), intent(in)  :: p

    integer :: i

    p_ = trim(p)
    do i = len(p_),3,-1
      if (p_(i-2:i) == sep//curdir//sep) p_(i-1:) = p_(i+1:)//'  '
    enddo
    p_ = trim(p_)

  end function remove_curdir

  pure function remove_sep(p) result(p_)

    character(len=:), allocatable :: p_
    character(len=*), intent(in)  :: p

    integer :: i

    p_ = trim(p)
    do i = len(p_),2,-1
      if (p_(i-1:i) == sep//sep) p_(i-1:) = p_(i:)//' '
    enddo
    p_ = trim(p_)

  end function remove_sep


end module os_path
