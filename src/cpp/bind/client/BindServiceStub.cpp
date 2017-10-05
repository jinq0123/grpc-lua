#include "BindServiceStub.h"

#include <grpc_cb_core/common/completion_queue_for_next_sptr.h>  // for CompletionQueueForNextSptr
#include <grpc_cb_core/client/service_stub.h>  // for ServiceStub
#include <grpc_cb_core/common/status.h>  // for Status

#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;
using string = std::string;

namespace {

// Sync request.
// Return (response_string, nil, nil) or
//   (nil, error_string, grpc_status_code).
// XXX change to return (string|nil, string, code)
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

}  // namespace

namespace bind {

void BindServiceStub(const LuaRef& mod)
{
    lua_State* L = mod.state();
    LuaBinding(mod).beginClass<ServiceStub>("ServiceStub")
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
    .endClass();  // ServiceStub
}  // BindServiceStub()

}  // namespace bind
