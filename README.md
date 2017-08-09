# gRPC-Lua
The Lua [gRPC](http://www.grpc.io/) binding.

NOT READY!

## Dependings

gRPC-Lua depends on

* [grpc_cb](https://github.com/jinq0123/grpc_cb)
* [lua-intf](https://github.com/SteveKChiu/lua-intf)
* [LuaPbIntf](https://github.com/jinq0123/LuaPbIntf)
* [lua](https://www.lua.org/)

## Build
Need to install [conan](http://docs.conan.io/en/latest/installation.html).

### Quick Build
1. `conan remote add remote_bintray_jinq0123 https://api.bintray.com/conan/jinq0123/test`
1. `conan create user/channel --build missing`
    * The result grpc-lua.dll/grpc-lua.so is in `~/.conan/data/grpc-lua/0.1/user/channel/package/`
    * Change build settings using -s (--settings) like:
        `conan create user/channel --build missing -s arch=x86`

### Create VS solution
Use premake5 to generate VS solution.

1. conan_install.bat
2. 

See [premake5.bat](build/premake5.bat).

Vs2015 sln example are provided but it is not usable because it contains absolute pathes.

### Run example
See:
* [examples/helloworld/README.md](examples/helloworld/README.md)
* [examples/route_guide/README.md](examples/route_guide/README.md)
