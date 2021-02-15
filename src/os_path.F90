module os_path

  use iso_fortran_env, only: int64
  use internal
  use os
  use os_path_c

  implicit none
#ifndef _WIN32
  character, parameter, public  :: sep = '/'
#else
  character, parameter, public  :: sep = '/'
#endif

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
    getctime, &
    getmtime, &
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
    relpath, &
    split, &
    splitext

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

#ifndef _WIN32
  include "os_path_posix.f90.inc"
#else
  include "os_path_windows.f90.inc"
#endif

  function abspath(path)

    character(len=:), allocatable :: abspath
    character(len=*), intent(in)  :: path

    abspath = normpath(join(getcwd(),path))

  end function abspath


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


  function exists(path)

    logical                      :: exists
    character(len=*), intent(in) :: path

    inquire(file=path,exist=exists)

  end function exists


  function expanduser(path)

    character(len=:), allocatable :: expanduser
    character(len=*), intent(in)  :: path

    character(len=:), allocatable :: user
    integer :: stat

    user = "~"//getuser()
    if(index(path,user)==1) then
      expanduser = substitute(path,gethome(),1,len(user))
    elseif(index(path,'~')==1) then
      deallocate(user)
      allocate(character(len=PATH_MAX()-1)::user)
      call get_environment_variable('HOME',user,status=stat)
      if(stat==0) then
        expanduser = substitute(path,trim(user),1,1)
      else
        expanduser = substitute(path,gethome(),1,1)
      endif
    endif

  end function expanduser


  function expandvars(path)

    character(len=:), allocatable :: expandvars
    character(len=*), intent(in)  :: path

    character(len=*), parameter :: valid_chars='ABCDEFGHIJKLMNOPQRSTUVWXYZ'&
                                              &'abcdefghijklmnopqrstuvwxyz'&
                                              &'1234567890'&
                                              &'_'
    character(len=:), allocatable :: val
    integer :: i,j,stat

    allocate(character(len=PATH_MAX()-1)::val)
    expandvars = path

    i=1
    do while(i< len(expandvars))
      start: if(expandvars(i:i)=='$') then
        brackets: if(expandvars(i+1:i+1) == '{') then
          if(len(expandvars(i+1:))>2) then
            j = verify(expandvars(i+2:),valid_chars)
            if(expandvars(i+j+1:i+j+1) == '}') then
              call get_environment_variable(expandvars(i+2:i+j),val,status=stat)
              if(stat == 0) then
                expandvars = substitute(expandvars,trim(val),i,i+j+1)
                i = i+len_trim(val)
              else
                i = i+1
              endif
            else
              i = i+1
            endif
          else
            i = i+1
          endif
        else brackets
          j = verify(expandvars(i+1:)//'#',valid_chars)
          if(j /= 0) then
            call get_environment_variable(expandvars(i+1:i+j-1),val,status=stat)
            if(stat == 0) then
              expandvars = substitute(expandvars,trim(val),i,i+j-1)
              i = i+len_trim(val)
            else
              i = i+1
            endif
          else
            i = i+1
          endif
        endif brackets
      else start
        i = i+1
      endif start
    enddo

  end function expandvars


  function getatime(path)

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


  function getctime(path)

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


  function getmtime(path)

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


  integer(int64) function getsize(path)

    character(len=*), intent(in) :: path
    integer                      :: ierr
    integer                      :: lun

    !
    ! Note 1: work around a problem witn Intel Fortran -
    !         a plain "INQUIRE" causes the program to stop
    !
    ! Note 2: a similar problem occurs with inquiring if the
    !         file is already open. So do not check for this :(
    !
    open( newunit = lun, file = path, action = 'read', access = 'stream', iostat = ierr )

    if ( ierr /= 0 ) then
      getsize = -1
    else
      inquire( unit = lun, size = getsize, iostat = ierr )
      close( lun )

      if ( ierr /= 0 ) then
        getsize = -1
      endif
    endif

  end function getsize


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

  function samefile(path1,path2)

    logical                      :: samefile
    character(len=*), intent(in) :: path1, path2
    integer(C_INT)               :: return_value

    return_value = samefile_c(f_c_string(path1),f_c_string(path2))

    !if(return_value == -1) &
    !  error stop 'samefile: cannot access file(s)'
    samefile = return_value > 0

  end function samefile


  ! splitdrive

  function splitext(path)

    character(len=*), intent(in)  :: path
    character(len=:), allocatable :: root,tail
    character(len=:), allocatable, dimension(:) :: splitext
    integer :: s

    s = scan(path,'.',back=.True.)

    if(s>1) then
      root = path(:s-1)
      tail = path(s:)
    else
      root = path
      tail = ''
    endif

    allocate(character(len=max(len(root),len(tail)))::splitext(2))
    splitext(1) = root
    splitext(2) = tail

  end function splitext


!--------------------------------------------------------------------------------------------------
  pure function clean(p) result(p_)

    character(len=:), allocatable :: p_
    character(len=*), intent(in)  :: p

    p_ = clean_trail(clean_lead(remove_sep(remove_curdir(p))))

  end function clean


  pure function substitute(parent,substituent,low,high)

    character(len=:), allocatable :: substitute
    character(len=*), intent(in)  :: parent,substituent
    integer,          intent(in)  :: low,high

    if(low>high .or. max(low,high)>len(parent) .or. low<1) &
      error stop 'substitute: invalid limits (low/high)'

    substitute = parent(:low-1)//substituent
    if(high<len(parent)) substitute = substitute//parent(high+1:)

  end function substitute

end module os_path
