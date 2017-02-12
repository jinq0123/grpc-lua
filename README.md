# gRPC-Lua
The Lua [gRPC](http://www.grpc.io/) binding.

## Dependings

gRPC-Lua depends on

* [grpc_cb](https://github.com/jinq0123/grpc_cb)
* [lua-intf](https://github.com/SteveKChiu/lua-intf)
* [pbc](https://github.com/cloudwu/pbc)
* [lua](https://www.lua.org/)

## Build

### Init third-party
1. Copy [grpc_cb](https://github.com/jinq0123/grpc_cb)/include/grpc_cb as include/grpc_cb
1. Clone [lua-intf](https://github.com/SteveKChiu/lua-intf)
1. Copy libs to third_party/lib

By default, it expects the Lua library to build under C++.
If you really want to use Lua library compiled under C,
you can define LUAINTF_LINK_LUA_COMPILED_IN_CXX to 0 in build/premake5.lua.
<br>See: https://github.com/SteveKChiu/lua-intf

```
defines { "LUAINTF_LINK_LUA_COMPILED_IN_CXX=0" }
```

### Make
Use premake5 to generate VS solution and linux Makefile. See premake5.bat.

Vs2015 sln and Makefile are provided.

