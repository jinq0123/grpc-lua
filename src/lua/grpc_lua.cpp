#include <grpc_cb/channel.h>  // for Channel
#include <grpc_cb/service_stub.h>  // for ServiceStub
#include <grpc_cb/status.h>  // for Status

#include <LuaIntf/LuaIntf.h>

#include <iostream>

namespace LuaIntf
{
    LUA_USING_SHARED_PTR_TYPE(std::shared_ptr)
}

namespace {

void test()
{
    std::cout << "test...\n";
}

std::string Request(grpc_cb::ServiceStub* pServiceStub,
    const std::string& sMethod, const std::string& sRequest)
{
    assert(pServiceStub);
    std::string sResponse;
    grpc_cb::Status status = pServiceStub->BlockingRequest(
        sMethod, sRequest, sResponse);
    if (status.ok()) return sResponse;
    return "Error";  // XXX
}

}  // namespace

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
            .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(const std::string&))
        .endClass()
        .beginClass<ServiceStub>("ServiceStub")
            .addConstructor(LUA_ARGS(const ChannelSptr&))
            .addFunction("request", &Request)
        .endClass()
        ;
    mod.pushToStack();
    return 1;
}
