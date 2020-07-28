program stdlib_test
  use stdlib

  implicit none
  integer :: unit

  print*, 'current working directory: ',stdlib_os_getcwd()
  print*, 'home directory: ',stdlib_os_path_expanduser('~')
  print*, '$SHELL: ', stdlib_os_path_expandvars('$SHELL')
  print*, "ismount('/home'): ", stdlib_os_path_ismount('/home') 
  print*, ''

  open(newunit=unit, file='test.txt', action='write')
  write(unit,*) 'test'
  close(unit)
  print*, "exists('test.txt'): ",   stdlib_os_path_exists('test.txt') 
  print*, "isdir('test.txt'): ",    stdlib_os_path_isdir('test.txt') 
  print*, "isfile('test.txt'): ",   stdlib_os_path_isfile('test.txt') 
  print*, "islink('test.txt'): ",   stdlib_os_path_islink('test.txt') 
  print*, "ismount('test.txt'): ",  stdlib_os_path_ismount('test.txt') 
  print*, "getsize('test.txt'): ",  stdlib_os_path_getsize('test.txt') 
  print*, ''
  
  call stdlib_os_symlink('test.txt','test.lnk')
  print*, "exists('test.lnk'): ",   stdlib_os_path_exists('test.lnk') 
  print*, "isdir('test.lnk'): ",    stdlib_os_path_isdir('test.lnk') 
  print*, "isfile('test.lnk'): ",   stdlib_os_path_isfile('test.lnk') 
  print*, "islink('test.lnk'): ",   stdlib_os_path_islink('test.lnk') 
  print*, "ismount('test.lnk'): ",  stdlib_os_path_ismount('test.lnk') 
  print*, "getsize('test.lnk'): ",  stdlib_os_path_getsize('test.lnk') 
  print*, ''

  call stdlib_os_mkdir('test_sym')
  print*, "exists('test_sym'): ",   stdlib_os_path_exists('test_sym') 
  print*, "isdir('test_sym'): ",    stdlib_os_path_isdir('test_sym') 
  print*, "isfile('test_sym'): ",   stdlib_os_path_isfile('test_sym') 
  print*, "islink('test_sym'): ",   stdlib_os_path_islink('test_sym') 
  print*, "ismount('test_sym'): ",  stdlib_os_path_ismount('test_sym') 
  print*, "getsize('test_sym'): ",  stdlib_os_path_getsize('test_sym') 
  print*, ''

  call stdlib_os_symlink('test_sym','test2_sym')
  print*, "exists('test2_sym'): ",  stdlib_os_path_exists('test2_sym') 
  print*, "isdir('test2_sym'): ",   stdlib_os_path_isdir('test2_sym') 
  print*, "isfile('test2_sym'): ",  stdlib_os_path_isfile('test2_sym') 
  print*, "islink('test2_sym'): ",  stdlib_os_path_islink('test2_sym') 
  print*, "ismount('test2_sym'): ", stdlib_os_path_ismount('test2_sym') 
  print*, "getsize('test2_sym'): ", stdlib_os_path_getsize('test2_sym') 
  print*, ''

  ! start in defined situation
  call stdlib_os_chdir('/home')
  if(.not. stdlib_os_path_isdir('/bin')) &
    error stop "'/bin' does not exist"


  ! basename
  if(stdlib_os_path_basename('/../') /= '') &
    error stop "basename('/../') /= ''"

  if(stdlib_os_path_basename('/aa/bb/') /= '') &
    error stop "basename('/aa/bb/') /= ''"

  if(stdlib_os_path_basename('/aa/bb/c') /= 'c') &
    error stop "basename('/aa/bb/c') /= 'c'"


  ! dirname
  if(stdlib_os_path_dirname('xxx') /= '') &
    error stop "dirname('xxx') /= ''"

  if(stdlib_os_path_dirname('/xxx') /= '/') &
    error stop "dirname('/xxx') /= '/'"

  if(stdlib_os_path_dirname('/') /= '/') &
    error stop "dirname('/') /= '/'"

  if(stdlib_os_path_dirname('//') /= '//') &
    error stop "dirname('//') /= '//'"

  if(stdlib_os_path_dirname('/../') /= '/..') &
    error stop "dirname('/../') /= '/..'"


  ! getcwd
  if(stdlib_os_getcwd() /= '/home') &
    error stop "getcwd() /= '/home'"


  ! commonpath
  if(stdlib_os_path_commonpath('yy','xxx/yyy') /= '') &
    error stop "commonpath('yy','xxx/yyy') /= ''"

  if(stdlib_os_path_commonpath('yyy/.','yyy') /= 'yyy') &
    error stop "commonpath('yyy/.','yyy') /= 'yyy'"

  if(stdlib_os_path_commonpath('yyy/','yyy') /= 'yyy') &
    error stop "commonpath('yyy/','yyy') /= 'yyy'"

  if(stdlib_os_path_commonpath('yyy','yyy') /= 'yyy') &
    error stop "commonpath('yyy','yyy') /= 'yyy'"

  if(stdlib_os_path_commonpath('yyy.','yyy') /= '') &
    error stop "commonpath('yyy/.','yyy') /= ''"

  if(stdlib_os_path_commonpath('../../src','../../src') /= '../../src') &
    error stop "commonpath('../../src','../../src') /= '../../src'"

  if(stdlib_os_path_commonpath('../src/..','../src/..') /= '../src/..') &
    error stop "commonpath('../src/..','../src/..') /= '../src/..'"

  if(stdlib_os_path_commonpath('/./yyy/./.','/./yyy/./.') /= '/yyy') &
    error stop "commonpath('/./yyy/./.','/./yyy/./.') /= '/yyy'"

  if(stdlib_os_path_commonpath('/bin','/') /= '/') &
    error stop "commonpath('/bin','/') /= '/'"


  ! normpath
  if(stdlib_os_path_normpath('../../aa') /= '../../aa') &
    error stop "normpath('../../aa') /= '../../aa'"

  if(stdlib_os_path_normpath('aa/../../bbb') /= '../bbb') &
    error stop "normpath('aa/../../bbb') /= '../bbb'"

  if(stdlib_os_path_normpath('/..') /= '/') &
    error stop "normpath('/..') /= '/'"

  if(stdlib_os_path_normpath('aa/../') /= '.') &
    error stop "normpath('aa/../') /= '.'"

  if(stdlib_os_path_normpath('..') /= '..') &
    error stop "path_normpath('..') /= '..'"

  if(stdlib_os_path_normpath('') /= '.') &
    error stop "path_normpath('') /= '.'"

  if(stdlib_os_path_normpath('/aa/bb/../../../') /= '/') &
    error stop "normpath('/aa/bb/../../../') /= '/'"

  if(stdlib_os_path_normpath('/aa/bb/../../../xx/') /= '/xx') &
    error stop "normpath('/aa/bb/../../../xx/') /= '/xx'"

  if(stdlib_os_path_normpath('/aa/bb/../../../xx') /= '/xx') &
    error stop "normpath('/aa/bb/../../../xx/') /= '/xx'"

  if(stdlib_os_path_normpath('.') /= '.') &
    error stop "normpath('.') /= '.'"

  if(stdlib_os_path_normpath('../..') /= '../..') &
    error stop "normpath('../..') /= '../..'"

  if(stdlib_os_path_normpath('/../..') /= '/') &
    error stop "normpath('../..') /= '/'"

  if(stdlib_os_path_normpath('/aaa/bbb/ccc/ddd/../uuu') /= '/aaa/bbb/ccc/uuu') &
    error stop "norpath('/aaa/bbb/ccc/ddd/../uuu') /= '/aaa/bbb/ccc/uuu'"


  ! relpath
  if(stdlib_os_path_relpath('/home','/home') /= '.') &
    error stop "relpath('/home','/home') /= '.'"

  if(stdlib_os_path_relpath('.') /= '.') &
    error stop "relpath('.') /= '.'"

  if(stdlib_os_path_relpath('aaa/bbb') /= 'aaa/bbb') &
    error stop "relpath('aaa/bbb') /= 'aaa/bbb'"

  if(stdlib_os_path_relpath('/bin') /= '../bin') &
    error stop "relpath('/bin') /= '../bin'"

  if(stdlib_os_path_relpath('/bin','/') /= 'bin') &
    error stop "relpath('/bin','/') /= 'bin'"


end program stdlib_test
