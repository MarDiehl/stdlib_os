cmake -DCMAKE_INSTALL_PREFIX=%cd%\inst .
cmake --build . --config Release
.\src\stdlib_test
