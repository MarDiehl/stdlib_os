program stdlib_test
  use stdlib
  
  implicit none

  character(len=:), allocatable :: cwd
  
  ! start in defined situation
  cwd = stdlib_os_getcwd()
  call stdlib_os_chdir('/home')
  if(.not. stdlib_os_path_isdir('/bin')) &
    error stop "'/bin' does not exist"

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
