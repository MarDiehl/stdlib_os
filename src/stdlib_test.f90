program stdlib_test
  use stdlib
  
  print*, commonpath('/a','/a')
  print*, commonpath('/','/')
  print*, commonpath('/a/b','/a/c')
  print*, commonpath('/a/x','/a/x')
  print*, commonpath('/a/x','/a/x/u')
end program stdlib_test
