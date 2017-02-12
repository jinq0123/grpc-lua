#include <LuaIntf/LuaIntf.h>

#include <iostream>

void test()
{
	std::cout << "test...\n";
}

extern "C"
#if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__CODEGEARC__)
__declspec(dllexport)
#endif
int luaopen_grpc_lua(lua_State* L)
{
	using namespace LuaIntf;
	LuaRef mod = LuaRef::createTable(L);
	LuaBinding(mod)
		.addFunction("test", &test);
	mod.pushToStack();
	return 1;
}
