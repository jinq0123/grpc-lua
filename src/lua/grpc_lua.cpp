#include <grpc_cb/channel.h>  // for Channel
#include <grpc_cb/service_stub.h>  // for ServiceStub

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
int luaopen_grpc_lua_c(lua_State* L)
{
    using namespace LuaIntf;
    LuaRef mod = LuaRef::createTable(L);
    LuaBinding(mod)
        .addFunction("test", &test)

        .beginClass<grpc_cb::Channel>("Channel")
            .addConstructor(LUA_ARGS(std::string))
        .endClass()
        .beginClass<grpc_cb::ServiceStub>("ServiceStub")
            .addConstructor(LUA_ARGS(grpc_cb::Channel))  // XXX 
        .endClass()
        ;
    mod.pushToStack();
    return 1;
}
