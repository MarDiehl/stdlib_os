program stdlib_test
  use stdlib
  
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
  
end program stdlib_test
