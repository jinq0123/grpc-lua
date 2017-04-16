#include <grpc_cb/channel.h>  // for Channel
#include <grpc_cb/service_stub.h>  // for ServiceStub

#include <LuaIntf/LuaIntf.h>

#include <iostream>

namespace LuaIntf
{
    LUA_USING_SHARED_PTR_TYPE(std::shared_ptr)
}

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
    using namespace grpc_cb;
    LuaRef mod = LuaRef::createTable(L);
    LuaBinding(mod)
        .addFunction("test", &test)

        .beginClass<Channel>("Channel")
            .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(std::string))
        .endClass()
        .beginClass<ServiceStub>("ServiceStub")
            .addConstructor(LUA_ARGS(const ChannelSptr&))  // XXX 
        .endClass()
        ;
    mod.pushToStack();
    return 1;
}
