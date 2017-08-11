# gRPC-Lua
The Lua [gRPC](http://www.grpc.io/) binding.

NOT READY!

## Dependings
gRPC-Lua depends on
* [grpc_cb](https://github.com/jinq0123/grpc_cb)
* [lua-intf](https://github.com/SteveKChiu/lua-intf)
* [lua](https://www.lua.org/)

See [doc/conan-graph.html](http://htmlpreview.github.io/?https://github.com/jinq0123/grpc-lua/master/doc/conan-graph.html)

All these libraries will be installed by [conan](https://www.conan.io/)
C/C++ package manager.

## Build

### Quick Build
1. Install [conan](http://docs.conan.io/en/latest/installation.html).
1. `conan remote add remote_bintray_jinq0123 https://api.bintray.com/conan/jinq0123/test`
1. `conan create user/channel --build missing`
    * The result `grpc_lua.dll`/`grpc_lua.so` is in `~/.conan/data/grpc-lua/0.1/user/channel/package/`...

### VS solution
See [premake/README.md](premake/README.md) to use premake5 to generate VS solution.

## Usage
TODO

### Examples
1. Rename [examples/conan_install.bat.example](examples/conan_install.bat.example) to `conan_install.bat`
1. Change conandata in `conan_install.bat`
1. Run example bat
	* helloworld
		+ [run_client.bat](examples/helloworld/run_client.bat)
		+ [run_server.bat](examples/helloworld/run_client.bat)
	* route_guide
		+ [run_client.bat](examples/route_guide/run_client.bat)
		+ [run_server.bat](examples/route_guide/run_client.bat)

#### Explaination
* example bat
	+ Calls `conan_install.bat`
	+ Start lua script
* `conan_install.bat`
	+ Install dependings using `conan`
		- luapbintf/0.1
		- grpc-lua/0.1
	+ Copy exe and dlls
		- lua_cpp.exe
		- lua_cpp.dll
		- luapbintf.dll
		- grpc_lua.dll
