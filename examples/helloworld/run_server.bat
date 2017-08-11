pushd ..
call conan_install.bat
popd

lua-cpp.exe greeter_server.lua

pause
