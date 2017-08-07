#include <iostream>

#include "lua.h"

extern "C"
int luaopen_grpc_lua_c(lua_State* L);

int main() {
	void * p = static_cast<void*>(luaopen_grpc_lua_c);
	return 0;
}
