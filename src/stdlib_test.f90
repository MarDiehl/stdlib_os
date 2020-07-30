program stdlib_test

  use os
  use os_path

  implicit none
  integer :: unit

  character(len=:), allocatable, dimension(:) :: split_str

  split_str=split('aaa/bbb/')
  print*, '#'//trim(split_str(1))//'#'
  print*, '#'//trim(split_str(2))//'#'
  split_str=split('aaa/bbb')
  print*, '#'//trim(split_str(1))//'#'
  print*, '#'//trim(split_str(2))//'#'
  split_str=split('/aaa/bbb')
  print*, '#'//trim(split_str(1))//'#'
  print*, '#'//trim(split_str(2))//'#'
  split_str=split('//')
  print*, '#'//trim(split_str(1))//'#'
  print*, '#'//trim(split_str(2))//'#'


  print*, 'current working directory: ',getcwd()
  print*, 'home directory: ',expanduser('~')
  print*, '$SHELL: ', expandvars('$SHELL')
  print*, "ismount('/home'): ", ismount('/home')
  print*, ''

  open(newunit=unit, file='test.py', action='write', status='new')
  write(unit,'(a)') "import time;time.sleep(1);print(' hello Mio')"
  close(unit)
  print*, "getatime('test.py'): ", getatime('test.py')
  print*, "getctime('test.py'): ", getctime('test.py')
  print*, "getmtime('test.py'): ", getmtime('test.py')
  call execute_command_line('python3 test.py')
  open(newunit=unit, file='test.py', action='write', status='old', position='append')
  write(unit,'(a)') "print('hello')"
  close(unit)
  call rename('test.py','test.txt')
  print*, ''

  print*, "exists('test.txt'): ",   exists('test.txt')
  print*, "isdir('test.txt'): ",    isdir('test.txt')
  print*, "isfile('test.txt'): ",   isfile('test.txt')
  print*, "islink('test.txt'): ",   islink('test.txt')
  print*, "ismount('test.txt'): ",  ismount('test.txt')
  print*, "getsize('test.txt'): ",  getsize('test.txt')
  print*, "getatime('test.txt'): ", getatime('test.txt')
  print*, "getctime('test.txt'): ", getctime('test.txt')
  print*, "getmtime('test.txt'): ", getmtime('test.txt')
  call rename('test.txt','test2.txt')
  print*, "exists('test.txt'): ",   exists('test.txt')
  print*, "exists('test2.txt'): ",  exists('test2.txt')
  call rename('test2.txt','test.txt')
  print*, ''

  call symlink('test.txt','test.lnk')
  print*, "exists('test.lnk'): ",   exists('test.lnk')
  print*, "isdir('test.lnk'): ",    isdir('test.lnk')
  print*, "isfile('test.lnk'): ",   isfile('test.lnk')
  print*, "islink('test.lnk'): ",   islink('test.lnk')
  print*, "ismount('test.lnk'): ",  ismount('test.lnk')
  print*, "getsize('test.lnk'): ",  getsize('test.lnk')
  print*, "getatime('test.lnk'): ", getatime('test.lnk')
  print*, "getctime('test.lnk'): ", getctime('test.lnk')
  print*, "getmtime('test.lnk'): ", getmtime('test.lnk')
  call unlink('test.lnk')
  print*, "exists('test.lnk'): ",   exists('test.lnk')
  call unlink('test.txt')
  print*, ''

  call mkdir('test_sym')
  print*, "exists('test_sym'): ",   exists('test_sym')
  print*, "isdir('test_sym'): ",    isdir('test_sym')
  print*, "isfile('test_sym'): ",   isfile('test_sym')
  print*, "islink('test_sym'): ",   islink('test_sym')
  print*, "ismount('test_sym'): ",  ismount('test_sym')
  print*, "getsize('test_sym'): ",  getsize('test_sym')
  print*, ''

  call symlink('test_sym','test2_sym')
  print*, "exists('test2_sym'): ",  exists('test2_sym')
  print*, "isdir('test2_sym'): ",   isdir('test2_sym')
  print*, "isfile('test2_sym'): ",  isfile('test2_sym')
  print*, "islink('test2_sym'): ",  islink('test2_sym')
  print*, "ismount('test2_sym'): ", ismount('test2_sym')
  print*, "getsize('test2_sym'): ", getsize('test2_sym')
  print*, ''

  ! start in defined situation
  call chdir('/home')
  if(.not. isdir('/bin')) &
    error stop "'/bin' does not exist"

  ! basename
  if(basename('/../') /= '') &
    error stop "basename('/../') /= ''"
  if(basename('/aa/bb/') /= '') &
    error stop "basename('/aa/bb/') /= ''"
  if(basename('/aa/bb/c') /= 'c') &
    error stop "basename('/aa/bb/c') /= 'c'"

  ! dirname
  if(dirname('xxx') /= '') &
    error stop "dirname('xxx') /= ''"
  if(dirname('/xxx') /= '/') &
    error stop "dirname('/xxx') /= '/'"
  if(dirname('/') /= '/') &
    error stop "dirname('/') /= '/'"
  if(dirname('//') /= '//') &
    error stop "dirname('//') /= '//'"
  if(dirname('/../') /= '/..') &
    error stop "dirname('/../') /= '/..'"

  ! getcwd
  if(getcwd() /= '/home') &
    error stop "getcwd() /= '/home'"

  ! commonpath
  if(commonpath('yy','xxx/yyy') /= '') &
    error stop "commonpath('yy','xxx/yyy') /= ''"
  if(commonpath('yyy/.','yyy') /= 'yyy') &
    error stop "commonpath('yyy/.','yyy') /= 'yyy'"
  if(commonpath('yyy/','yyy') /= 'yyy') &
    error stop "commonpath('yyy/','yyy') /= 'yyy'"
  if(commonpath('yyy','yyy') /= 'yyy') &
    error stop "commonpath('yyy','yyy') /= 'yyy'"
  if(commonpath('yyy.','yyy') /= '') &
    error stop "commonpath('yyy/.','yyy') /= ''"
  if(commonpath('../../src','../../src') /= '../../src') &
    error stop "commonpath('../../src','../../src') /= '../../src'"
  if(commonpath('../src/..','../src/..') /= '../src/..') &
    error stop "commonpath('../src/..','../src/..') /= '../src/..'"
  if(commonpath('/./yyy/./.','/./yyy/./.') /= '/yyy') &
    error stop "commonpath('/./yyy/./.','/./yyy/./.') /= '/yyy'"
  if(commonpath('/bin','/') /= '/') &
    error stop "commonpath('/bin','/') /= '/'"

  ! normpath
  if(normpath('../../aa') /= '../../aa') &
    error stop "normpath('../../aa') /= '../../aa'"
  if(normpath('aa/../../bbb') /= '../bbb') &
    error stop "normpath('aa/../../bbb') /= '../bbb'"
  if(normpath('/..') /= '/') &
    error stop "normpath('/..') /= '/'"
  if(normpath('aa/../') /= '.') &
    error stop "normpath('aa/../') /= '.'"
  if(normpath('..') /= '..') &
    error stop "path_normpath('..') /= '..'"
  if(normpath('') /= '.') &
    error stop "path_normpath('') /= '.'"
  if(normpath('/aa/bb/../../../') /= '/') &
    error stop "normpath('/aa/bb/../../../') /= '/'"
  if(normpath('/aa/bb/../../../xx/') /= '/xx') &
    error stop "normpath('/aa/bb/../../../xx/') /= '/xx'"
  if(normpath('/aa/bb/../../../xx') /= '/xx') &
    error stop "normpath('/aa/bb/../../../xx/') /= '/xx'"
  if(normpath('.') /= '.') &
    error stop "normpath('.') /= '.'"
  if(normpath('../..') /= '../..') &
    error stop "normpath('../..') /= '../..'"
  if(normpath('/../..') /= '/') &
    error stop "normpath('../..') /= '/'"
  if(normpath('/aaa/bbb/ccc/ddd/../uuu') /= '/aaa/bbb/ccc/uuu') &
    error stop "norpath('/aaa/bbb/ccc/ddd/../uuu') /= '/aaa/bbb/ccc/uuu'"

  ! relpath
  if(relpath('/home','/home') /= '.') &
    error stop "relpath('/home','/home') /= '.'"
  if(relpath('.') /= '.') &
    error stop "relpath('.') /= '.'"
  if(relpath('aaa/bbb') /= 'aaa/bbb') &
    error stop "relpath('aaa/bbb') /= 'aaa/bbb'"
  if(relpath('/bin') /= '../bin') &
    error stop "relpath('/bin') /= '../bin'"
  if(relpath('/bin','/') /= 'bin') &
    error stop "relpath('/bin','/') /= 'bin'"


end program stdlib_test
