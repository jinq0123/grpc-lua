#include <grpc_cb/channel.h>  // for Channel
#include <grpc_cb/completion_queue_for_next_sptr.h>  // for CompletionQueueForNextSptr
#include <grpc_cb/server.h>  // for Server
#include <grpc_cb/service_stub.h>  // for ServiceStub
#include <grpc_cb/status.h>  // for Status

#include <google/protobuf/descriptor.h>  // for ServiceDescriptor
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
BlockingRequest(lua_State* L, grpc_cb::ServiceStub* pServiceStub,
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
}  // BlockingRequest()

void AsyncRequest(grpc_cb::ServiceStub* pServiceStub,
    const string& sMethod, const string& sRequest,
    const LuaRef& luaOnResponse, const LuaRef& luaOnError)
{
    assert(pServiceStub);
    grpc_cb::ServiceStub::OnResponse onResponse;  // function<void (const string&)>
    if (luaOnResponse)
    {
        luaOnResponse.checkFunction();  // void (string)
        onResponse = [luaOnResponse](const string& sResponse) {
            luaOnResponse.call(sResponse);
        };
    }
    grpc_cb::ErrorCallback onError;  // function<void (const Status& status)>
    if (luaOnError)
    {
        luaOnError.checkFunction();  // void (string, int)
        onError = [luaOnError](const grpc_cb::Status& status) {
            luaOnError.call(status.GetDetails(), status.GetCode());
        };
    }
    pServiceStub->AsyncRequest(sMethod, sRequest, onResponse, onError);
}  // AsyncRequest()

void RegisterService(grpc_cb::Server* pServer,
    const google::protobuf::ServiceDescriptor* pDesc,
    const LuaRef& luaService)
{
    assert(pServer);
    if (!pDesc) return;
    luaService.checkTable();
    // XXX pServer->RegisterService(LuaService(luaService));  // XXX
    // XXX
}  // RegisterService()

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
        .endClass()  // Channel

        .beginClass<ServiceStub>("ServiceStub")
            .addConstructor(LUA_ARGS(const ChannelSptr&,
                _opt<CompletionQueueForNextSptr>))
            .addFunction("blocking_request",
                [L](ServiceStub* pServiceStub, const string& sMethod,
                        const string& sRequest) {
                    return BlockingRequest(L, pServiceStub, sMethod, sRequest);
                })
            .addFunction("async_request", &AsyncRequest)
            .addFunction("blocking_run", &grpc_cb::ServiceStub::BlockingRun)
        .endClass()  // ServiceStub

        .beginClass<Server>("Server")
            .addConstructor(LUA_SP(std::shared_ptr<Server>), LUA_ARGS())
            // Returns bound port number on success, 0 on failure.
            .addFunction("add_listening_port",
                static_cast<int(Server::*)(const string&)>(
                    &Server::AddListeningPort))
            .addFunction("register_service", &RegisterService)
            .addFunction("blocking_run", &Server::BlockingRun)
        .endClass()  // Server

        ;
    mod.pushToStack();
    return 1;
}  // luaopen_grpc_lua_c()
