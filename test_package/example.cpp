#include <iostream>

#include "lua.h"
#include "lauxlib.h"  
#include "lualib.h"  

extern "C"
int luaopen_grpc_lua_c(lua_State* L);

int main() {
	lua_State *L = luaL_newstate();
	luaopen_grpc_lua_c(L);
	return 0;
}
