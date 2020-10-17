submodule(os_path) os_path

  contains
  
  pure function isabs(path)
  
    logical                      :: isabs
    character(len=*), intent(in) :: path
  
    if(len(path) == 0) then
      isabs = .false.
    else
      isabs = path(1:1) == sep
    endif
  
  end function isabs

end submodule os_path
