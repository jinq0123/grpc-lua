# gRPC-Lua
The Lua [gRPC](http://www.grpc.io/) binding.

NOT READY!

## Dependings
gRPC-Lua depends on
* [grpc_cb](https://github.com/jinq0123/grpc_cb)
* [lua-intf](https://github.com/SteveKChiu/lua-intf)
* [lua](https://www.lua.org/)

All these libraries will installed by [conan](https://www.conan.io/)
C/C++ package manager.

## Build

### Quick Build
1. Install [conan](http://docs.conan.io/en/latest/installation.html).
1. `conan remote add remote_bintray_jinq0123 https://api.bintray.com/conan/jinq0123/test`
1. `conan create user/channel --build missing`
    * The result grpc-lua.dll/grpc-lua.so is in `~/.conan/data/grpc-lua/0.1/user/channel/package/`
    * Change build settings using -s (--settings) like:
        `conan create user/channel --build missing -s arch=x86`

### VS solution
See [premake/README.md](premake/README.md) to use premake5 to generate VS solution.

## Usage
TODO

### Examples
Need [LuaPbIntf](https://github.com/jinq0123/LuaPbIntf).
* [examples/helloworld/README.md](examples/helloworld/README.md)
* [examples/route_guide/README.md](examples/route_guide/README.md)
