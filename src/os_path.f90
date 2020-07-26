module os_path

  use internal
  use os
  use os_path_c
  
  implicit none
  character, parameter, public :: sep = '/'

  private
  public :: &
    abspath, &
    basename, &
    commonpath, &
    commonpath1, &
    commonpath2, &
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
    join1, &
    join2, &
    join3, &
    join4, &
    join5, &
    normcase, &
    normpath, &
    samefile
  
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

    call check_path_len(path)

  end function basename


  function commonpath1(path1) result(commonpath)
    
    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1

    commonpath = trim(path1)
  
  end function commonpath1
  
  function commonpath2(path1,path2) result(commonpath)
    
    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2

    integer :: i,j
   
    if(isabs(path1) .neqv. isabs(path2)) error stop

    j = 0
    do i=1,minval([len_trim(path1),len_trim(path2),maxPathLen])
      if(path1(i:i) /= path2(i:i)) exit
      if(path1(i:i) == sep) j = i
    enddo
    if(i-1==minval([len_trim(path1),len_trim(path2),maxPathLen])) j = i-1
    commonpath = path1(:j)
  
  end function commonpath2

  function commonpath3(path1,path2,path3) result(commonpath)
    
    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2,path3

    commonpath = commonpath2(commonpath2(path1,path2),path3)
  
  end function commonpath3
  
  function commonpath4(path1,path2,path3,path4) result(commonpath)
    
    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2,path3,path4

    commonpath = commonpath3(commonpath2(path1,path2),path3,path4)
  
  end function commonpath4
 
  function commonpath5(path1,path2,path3,path4,path5) result(commonpath)
    
    character(len=:), allocatable :: commonpath
    character(len=*), intent(in)  :: path1,path2,path3,path4,path5

    commonpath = commonpath4(commonpath2(path1,path2),path3,path4,path5)
  
  end function commonpath5
 
 

  function commonprefix(path1,path2)
    
    character(len=:), allocatable :: commonprefix
    character(len=*), intent(in)  :: path1, path2

    integer :: i
   
    do i=1,minval([len_trim(path1),len_trim(path2),maxPathLen])
      if(path1(i:i) /= path2(i:i)) exit 
    enddo
    commonprefix = path1(:i-1)
  
  end function commonprefix
  

  function dirname(path)
    
    character(len=:), allocatable :: dirname
    character(len=*), intent(in)  :: path
    integer :: pos

    if(len_trim(path) == 0) then
      dirname = ''
    elseif(verify(path,'/') == 0) then
      dirname = trim(path)
    else
      pos = scan(path,'/',back=.true.)
      if(pos == 0) then
        dirname = ''
      else
        dirname = path(:pos)
        if(verify(dirname,'/') /= 0) then
          do pos=pos,1,-1
            if(dirname(pos:pos) == '/') then
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


  function expanduser(path)
    
    character(len=:), allocatable :: expanduser
    character(len=*), intent(in)  :: path

  end function expanduser
 

  function expandvars(path)
    
    character(len=:), allocatable :: expandvars
    character(len=*), intent(in)  :: path

    character(len=*), parameter :: valid_chars='ABCDEFGHIJKLMNOPQRSTUVWXYZ'&
                                              &'abcdefghijklmnopqrstuvwxyz'&
                                              &'1234567890'&
                                              &'{}'&
                                              &'_'
    character(len=maxPathLen)     :: path_new, var_value
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
    
    getatime = getatime_c(f_to_c_path(path))
    if(getatime < 0.0) error stop

  end function getatime


  function getmtime(path)
   
    real(C_DOUBLE)               :: getmtime
    character(len=*), intent(in) :: path
    
    getmtime = getmtime_c(f_to_c_path(path))
    if(getmtime < 0.0) error stop

  end function getmtime


  function getctime(path)
    
    real(C_DOUBLE)               :: getctime
    character(len=*), intent(in) :: path
    
    getctime = getctime_c(f_to_c_path(path))
    if(getctime < 0.0) error stop

  end function getctime


  function getsize(path)
    
    integer(C_LONG)              :: getsize
    character(len=*), intent(in) :: path
    
    getsize = getsize_c(f_to_c_path(path))
    if(getsize < 0) error stop

  end function getsize
  

  function isabs(path)
    
    logical                      :: isabs
    character(len=*), intent(in) :: path
     
    if(len(path) == 0) then
      isabs = .false.
    else
      isabs = path(1:1) == '/'
    endif

  end function isabs
  

  function isfile(path)
    
    logical                      :: isfile
    character(len=*), intent(in) :: path
    
    isfile = isfile_c(f_to_c_path(path)) > 0

  end function isfile


  function isdir(path)
    
    logical                      :: isdir
    character(len=*), intent(in) :: path
    
    isdir = isdir_c(f_to_c_path(path)) > 0

  end function isdir


  function islink(path)
    
    logical                      :: islink
    character(len=*), intent(in) :: path
    
    islink = islink_c(f_to_c_path(path)) > 0

  end function islink

  
  function ismount(path)
    
    logical                      :: ismount
    character(len=*), intent(in) :: path
    

  end function ismount


  function join1(path1) result(join)
    
    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1
  
    join = trim(path1)

    call check_path_len(join)

  end function join1
  
  function join2(path1,path2) result(join)
    
    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2

    if(isabs(path2)) then
      join = join1(trim(path2))
    else
      join = join1(trim(path1)//'/'//trim(path2))
    endif
    
  end function join2
  
  function join3(path1,path2,path3) result(join)
    
    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2, path3

    join = join2(join2(path1,path2),path3)
  
  end function join3
  
  function join4(path1,path2,path3,path4) result(join)
    
    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2, path3, path4

    join = join3(join2(path1,path2),path3,path4)
  
  end function join4
  
  function join5(path1,path2,path3,path4,path5) result(join)
    
    character(len=:), allocatable :: join
    character(len=*), intent(in)  :: path1, path2, path3, path4, path5

    join = join4(join2(path1,path2),path3,path4,path5)
  
  end function join5

  
  function normcase(path)
    
    character(len=:), allocatable :: normcase
    character(len=*), intent(in)  :: path
    
    normcase = trim(path)

  end function normcase
  

  function normpath(path)
  
    character(len=*), intent(in)  :: path
    character(len=:), allocatable :: normpath
    integer :: i,j,k,l
  
    ! remove /./ from path
    normpath = trim(path)
    l = len_trim(normpath)
    do i = l,3,-1
      if (normpath(i-2:i) == '/./') normpath(i-1:l) = normpath(i+1:l)//'  '
    enddo
  
    ! remove // from path
    l = len_trim(normpath)
    do i = l,2,-1
      if (normpath(i-1:i) == '//') normpath(i-1:l) = normpath(i:l)//' '
    enddo
  
    ! remove ../ and corresponding directory from rectifyPath
    l = len_trim(normpath)
    i = index(normpath(i:l),'../')
    j = 0
    do while (i > j)
       j = scan(normpath(1:i-2),'/',back=.true.)
       normpath(j+1:l) = normpath(i+3:l)//repeat(' ',2+i-j)
       if (normpath(j+1:j+1) == '/') then                                                           !search for '//' that appear in case of XXX/../../XXX
         k = len_trim(normpath)
         normpath(j+1:k-1) = normpath(j+2:k)
         normpath(k:k) = ' '
       endif
       i = j+index(normpath(j+1:l),'../')
    enddo
    if(len_trim(normpath) == 0) normpath = '/'
  
    normpath = trim(normpath)

    call check_path_len(normpath)
  
  end function normpath


  function samefile(path1,path2)
    
    logical                      :: samefile
    character(len=*), intent(in) :: path1, path2
    integer(C_INT)               :: return_value
    
    return_value = samefile_c(f_to_c_path(path1),f_to_c_path(path2))

    if(return_value == -1) error stop
    samefile = return_value > 0

  end function samefile

end module os_path
