program stdlib_test
  use stdlib
  
  print*, stdlib_os_path_getatime('/home/m/t')
  print*, stdlib_os_path_getctime('/home/m/t')
end program stdlib_test
