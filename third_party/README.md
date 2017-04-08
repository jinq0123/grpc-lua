# Init third_party dir

1. Copy [grpc_cb](https://github.com/jinq0123/grpc_cb)/include/grpc_cb/ as include/grpc_cb/
1. Copy [grpc](https://github.com/grpc/grpc)/include/grpc as include/grpc/
1. Clone [lua-intf](https://github.com/SteveKChiu/lua-intf)
1. Copy libs to third_party/lib
	* lua
	* gprc_cb
	* grpc
	* gpr
	* zlib
	* ssleay32
	* libeay32

By default, it expects the Lua library to build under C++.
If you really want to use Lua library compiled under C,
you can define `LUAINTF_LINK_LUA_COMPILED_IN_CXX` to 0 in
 [build/premake5.lua](../build/premake5.lua).
<br>See: https://github.com/SteveKChiu/lua-intf

```
defines { "LUAINTF_LINK_LUA_COMPILED_IN_CXX=0" }
```
