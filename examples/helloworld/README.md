# helloworld example


See run_client.bat.example.

1. Build grpc_lua.dll
	* Results ../../build/bin/Debug/grpc_lua.dll
1. Copy
	* grpc_lua.dll
	* lua53.exe
	* lua53.dll
	* grpc_cb.dll from [grpc_cb](https://github.com/jinq0123/grpc_cb)
	* luapbintf.dll from [LuaPbIntf](https://github.com/jinq0123/LuaPbIntf)
1. Run client
```
lua53.exe greeter_client.lua
```
