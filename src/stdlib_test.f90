program stdlib_test
  use stdlib
  
  print*, ismount('/')
  print*, ismount('//')
  print*, ismount('////d')
  print*, ismount('/home')
  print*, ismount('/home/m')
end program stdlib_test
