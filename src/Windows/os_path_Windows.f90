submodule(os_path) os_path_Windows

  contains

  pure function isabs(path)
  
    logical                      :: isabs
    character(len=*), intent(in) :: path
  
    if(len(path) == 0) then
      isabs = .false.
    else
      isabs = path(1:1) == sep
  
      if ( .not. isabs) isabs = path(2:3) == ':/' .or. path(2:3) == ':\'
    endif
  
  end function isabs

end submodule os_path_Windows
