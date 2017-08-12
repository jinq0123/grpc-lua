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

### Example codes
* [greeter_client.lua](examples/helloworld/greeter_client.lua)
* [greeter_server.lua](examples/helloworld/greeter_server.lua)
* [route_guide_client.lua](examples/route_guide/route_guide_client.lua)
* [route_guide_server.lua](examples/route_guide/route_guide_server.lua)

### How to run examples
1. Copy required exe and dll. 
   Rename [examples/conan_install.bat.example](examples/conan_install.bat.example)
   to `conan_install.bat`, and change `conandata` variable in it. Then run it.
   `conan_install.bat` will:
     + Install dependings using `conan` into `~/.conan/data`
     + Copy exe and dlls from `~/.conan/data`
		- lua-cpp.exe
		- lua-cpp.dll
		- luapbintf.dll
		- grpc_lua.dll
   
1. Start lua script
	* helloworld
		+ `lua-cpp.exe greeter_server.lua`
		+ `lua-cpp.exe greeter_client.lua`
	* route_guide
		+ `lua-cpp.exe route_guide_server.lua`
		+ `lua-cpp.exe route_guide_client.lua`

### API doc
See [doc/ldoc/html/index.html](http://htmlpreview.github.io/?https://github.com/jinq0123/grpc-lua/master/doc/ldoc/html/index.html)
