cmake ^
    -G "MinGW Makefiles" ^
    -DCMAKE_SH="CMAKE_SH-NOTFOUND" ^
    -DCMAKE_INSTALL_PREFIX=%cd%\inst ^
    .

if errorlevel 1 exit 1

cmake --build . --config Release
if errorlevel 1 exit 1

.\src\stdlib_test
if errorlevel 1 exit 1
