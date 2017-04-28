# Init third_party dir

1. Copy [grpc_cb](https://github.com/jinq0123/grpc_cb)/include/grpc_cb/ as include/grpc_cb/
	* Check include/grpc_cb/grpc_cb.h
1. Copy [grpc](https://github.com/grpc/grpc)/include/grpc as include/grpc/
	* Check include/grpc/grpc.h
	* grpc++ is not needed
1. Download lua-5.3 and extract as lua/
	* Check lua/src/lua.h
1. Copy [lua-intf](https://github.com/SteveKChiu/lua-intf) as lua-intf/
	* Check lua-intf/LuaIntf/LuaIntf.h
1. Copy libs to third_party/lib
	* lua
	* gprc_cb
	* grpc
	* gpr
	* zlib
	* ssleay32
	* libeay32
	* grpc_plugin_support
	* libprotoc

By default, it expects the Lua library to build under C++.
If you really want to use Lua library compiled under C,
you can define `LUAINTF_LINK_LUA_COMPILED_IN_CXX` to 0 in
 [build/premake5.lua](../build/premake5.lua).
<br>See: https://github.com/SteveKChiu/lua-intf

```
defines { "LUAINTF_LINK_LUA_COMPILED_IN_CXX=0" }
```
