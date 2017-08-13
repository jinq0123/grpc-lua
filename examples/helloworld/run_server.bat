set GRPC_TRACE=api
set GRPC_VERBOSITY=DEBUG
echo %GRPC_TRACE%
lua-cpp.exe greeter_server.lua
pause
