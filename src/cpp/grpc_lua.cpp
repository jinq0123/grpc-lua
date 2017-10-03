/// grpc C module.
// Wraps grpc_cb_core library.
// @module grpc_lua.c

#include "bind/LuaBindChannel.h"
#include "impl/Service.h"  // for Service

#include <grpc_cb_core/completion_queue_for_next_sptr.h>  // for CompletionQueueForNextSptr
#include <grpc_cb_core/server.h>  // for Server
#include <grpc_cb_core/server_replier.h>  // for ServerReplier
#include <grpc_cb_core/service_stub.h>  // for ServiceStub
#include <grpc_cb_core/status.h>  // for Status

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

using Replier = grpc_cb_core::ServerReplier;

void test()
{
    std::cout << "test...\n";
}

// Sync request.
// Return (response_string, nil, nil) or
//   (nil, error_string, grpc_status_code).
std::tuple<LuaRef, LuaRef, LuaRef>
SyncRequest(lua_State* L, grpc_cb_core::ServiceStub* pServiceStub,
    const string& sMethod, const string& sRequest)
{
    assert(L);
    assert(pServiceStub);
    string sResponse;
    grpc_cb_core::Status status = pServiceStub->SyncRequest(
        sMethod, sRequest, sResponse);
    const LuaRef NIL(L, nullptr);
    if (status.ok())
        return std::make_tuple(LuaRef::fromValue(L, sResponse), NIL, NIL);
    return std::make_tuple(NIL,
        LuaRef::fromValue(L, status.GetDetails()),
        LuaRef::fromValue(L, status.GetCode()));
}  // SyncRequest()

void AsyncRequest(grpc_cb_core::ServiceStub* pServiceStub,
    const string& sMethod, const string& sRequest,
    const LuaRef& luaOnResponse, const LuaRef& luaOnError)
{
    assert(pServiceStub);
    grpc_cb_core::ServiceStub::OnResponse onResponse;  // function<void (const string&)>
    if (luaOnResponse)
    {
        luaOnResponse.checkFunction();  // void (string)
        onResponse = [luaOnResponse](const string& sResponse) {
            luaOnResponse.call(sResponse);
        };
    }
    grpc_cb_core::ErrorCallback onError;  // function<void (const Status& status)>
    if (luaOnError)
    {
        luaOnError.checkFunction();  // void (string, int)
        onError = [luaOnError](const grpc_cb_core::Status& status) {
            luaOnError.call(status.GetDetails(), status.GetCode());
        };
    }
    pServiceStub->AsyncRequest(sMethod, sRequest, onResponse, onError);
}  // AsyncRequest()

void RegisterService(grpc_cb_core::Server* pServer,
    const LuaRef& svcDecsPtr, const LuaRef& luaService)
{
    assert(pServer);
    svcDecsPtr.checkType(LuaIntf::LuaTypeID::LIGHTUSERDATA);
    const auto* pDesc = static_cast<const google::protobuf::ServiceDescriptor*>(
        svcDecsPtr.toPtr());
    if (!pDesc) throw LuaException("ServiceDescriptor pointer is nullptr.");
    luaService.checkTable();
    pServer->RegisterService(std::make_shared<Service>(*pDesc, luaService));
}  // RegisterService()

}  // namespace

extern "C"
#if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__CODEGEARC__)
__declspec(dllexport)
#endif
int luaopen_grpc_lua_c(lua_State* L)
{
    assert(L);

    using namespace grpc_cb_core;
    LuaRef mod = LuaRef::createTable(L);
    LuaBinding(mod)
        .addFunction("test", &test)

        .beginClass<Channel>("Channel")
            .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(const string&))
        .endClass()  // Channel

        .beginClass<ServiceStub>("ServiceStub")
            .addConstructor(LUA_ARGS(const ChannelSptr&,
                _opt<CompletionQueueForNextSptr>))
            .addFunction("sync_request",
                [L](ServiceStub* pServiceStub, const string& sMethod,
                        const string& sRequest) {
                    return SyncRequest(L, pServiceStub, sMethod, sRequest);
                })
            .addFunction("async_request", &AsyncRequest)
            .addFunction("run", &grpc_cb_core::ServiceStub::Run)
            .addFunction("shutdown", &grpc_cb_core::ServiceStub::Shutdown)
        .endClass()  // ServiceStub

        .beginClass<Server>("Server")
            .addConstructor(LUA_SP(std::shared_ptr<Server>), LUA_ARGS())
            // Returns bound port number on success, 0 on failure.
            .addFunction("add_listening_port",
                static_cast<int(Server::*)(const string&)>(
                    &Server::AddListeningPort))
            .addFunction("register_service", &RegisterService)
            .addFunction("run", &Server::Run)
        .endClass()  // Server

        .beginClass<Replier>("Replier")
            .addConstructor(LUA_SP(std::shared_ptr<Replier>),
                LUA_ARGS(const grpc_cb_core::CallSptr&))
            .addFunction("reply", &Replier::Reply)
        .endClass()  // Server

        ;

    bind::LuaBindChannel(mod);

    mod.pushToStack();
    return 1;
}  // luaopen_grpc_lua_c()

// lua doc

/// @type Channel
;
/// Constructor.
// @function Channel
// @string target host and port, like "a.b.com:6666" or "1.2.3.4:6666".
// @usage grpc_lua_c.Channel("localhost:6666")
;

/// @type ServiceStub
;
/// Constructor.
// @function ServiceStub
// @tparam Channel c_channel
// @usage grcp_lua_c.ServiceStub(c_channel)
;
/// Sync request.
// @function sync_request
// @string method_name
// @string request serialized message
// @usage stub:sync_request("SayHello", s)
;
/// Async request.
// @function async_request
// @string method_name
// @string request serialized message
// @func[opt] on_response response callback, `function(response_str)`
// @func[opt] on_error error handler, `function(error_str, status_code)`
;
/// Blocking run.
// Run async requests until shutdown.
// @function run
;
/// Shutdown.
// To end the blocking run.
// @function shutdown
;

/// @type Server
;
/// Constructor.
// @function Server
;
/// Add listening port.
// @function add_listening_port
// @treturn int returns bound port number on success, 0 on failure.
;
/// Register service.
// @function register_service
// @param service_descriptor
// @param service
;
/// Blocking run.
// Run the server.
// @function run
;

/// @type Replier
;
/// Constructor.
// @function Replier
// @param call
;
/// Reply.
// @function reply
// @string response_str serialized message
;
