# helloworld example

1. Generate descriptor set file from helloworld.proto
	* See (generate.bat.example)[generate.bat.example]
	* Output file is descriptors.pb
	* Ignore *.h/cc output files
1. Build grpc_lua.dll
	* Results ../../build/bin/Debug/grpc_lua.dll
1. Copy lua53.dll, grpc_cb.dll
1. Build pbc and copy protobuf.dll and protobuf.lua
1. Run client
```
lua53.exe greeter_client.lua
```