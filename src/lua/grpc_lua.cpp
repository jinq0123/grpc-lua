#include <grpc_cb/channel.h>  // for Channel
#include <grpc_cb/service_stub.h>  // for ServiceStub
#include <grpc_cb/status.h>  // for Status

#include <LuaIntf/LuaIntf.h>

#include <iostream>

using namespace LuaIntf;
using std::string;

namespace LuaIntf
{
    LUA_USING_SHARED_PTR_TYPE(std::shared_ptr)
}

namespace {

void test()
{
    std::cout << "test...\n";
}

// Blocking request.
// Return (response_string, nil, nil) or
//   (nil, error_string, grpc_status_code).
std::tuple<LuaRef, LuaRef, LuaRef>
Request(lua_State* L, grpc_cb::ServiceStub* pServiceStub,
    const string& sMethod, const string& sRequest)
{
    assert(L);
    assert(pServiceStub);
    string sResponse;
    grpc_cb::Status status = pServiceStub->BlockingRequest(
        sMethod, sRequest, sResponse);
    const LuaRef NIL(L, nullptr);
    if (status.ok())
        return std::make_tuple(LuaRef::fromValue(L, sResponse), NIL, NIL);
    return std::make_tuple(NIL,
        LuaRef::fromValue(L, status.GetDetails()),
        LuaRef::fromValue(L, status.GetCode()));
}

}  // namespace

extern "C"
#if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__CODEGEARC__)
__declspec(dllexport)
#endif
int luaopen_grpc_lua_c(lua_State* L)
{
    assert(L);

    using namespace grpc_cb;
    LuaRef mod = LuaRef::createTable(L);
    LuaBinding(mod)
        .addFunction("test", &test)

        .beginClass<Channel>("Channel")
            .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(const string&))
        .endClass()
        .beginClass<ServiceStub>("ServiceStub")
            .addConstructor(LUA_ARGS(const ChannelSptr&))
            .addFunction("request", [L](ServiceStub* pServiceStub,
                    const string& sMethod, const string& sRequest) {
                Request(L, pServiceStub, sMethod, sRequest);
            })
        .endClass()
        ;
    mod.pushToStack();
    return 1;
}
