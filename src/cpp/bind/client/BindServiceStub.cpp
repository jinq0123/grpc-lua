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

void SetErrorCb(ServiceStub* pServiceStub, const LuaRef& luaErrorCb)
{
    assert(pServiceStub);
    if (!luaErrorCb)
    {
        pServiceStub->SetErrorCb(ErrorCb());  // clear error callback
        return;
    }
    // XXX
}

// Sync request.
// Return (response_string, nil, nil) or
//   (nil, error_string, grpc_status_code).
// XXX change to return (string|nil, string, code)
std::tuple<LuaRef, LuaRef, LuaRef>
SyncRequest(lua_State* L, ServiceStub* pServiceStub,
    const string& sMethod, const string& sRequest)
{
    assert(L);
    assert(pServiceStub);
    string sResponse;
    Status status = pServiceStub->SyncRequest(
        sMethod, sRequest, sResponse);
    const LuaRef NIL(L, nullptr);
    if (status.ok())
        return std::make_tuple(LuaRef::fromValue(L, sResponse), NIL, NIL);
    return std::make_tuple(NIL,
        LuaRef::fromValue(L, status.GetDetails()),
        LuaRef::fromValue(L, status.GetCode()));
}  // SyncRequest()

void AsyncRequest(ServiceStub* pServiceStub,
    const string& sMethod, const string& sRequest,
    const LuaRef& luaResponseCb, const LuaRef& luaErrorCb)
{
    assert(pServiceStub);
    ResponseCb cbResponse;  // function<void (const string&)>
    if (luaResponseCb)
    {
        luaResponseCb.checkFunction();  // void (string)
        cbResponse = [luaResponseCb](const string& sResponse) {
            luaResponseCb.call(sResponse);
        };
    }
    ErrorCb cbError;  // function<void (const Status& status)>
    if (luaErrorCb)
    {
        luaErrorCb.checkFunction();  // void (string, int)
        cbError = [luaErrorCb](const Status& status) {
            // XXX if (status.ok()) call(nil, 0)
            luaErrorCb.call(status.GetDetails(), status.GetCode());
        };
    }
    pServiceStub->AsyncRequest(sMethod, sRequest, cbResponse, cbError);
}  // AsyncRequest()

}  // namespace

namespace bind {

void BindServiceStub(const LuaRef& mod)
{
    lua_State* L = mod.state();
    LuaBinding(mod).beginClass<ServiceStub>("ServiceStub")
        .addConstructor(LUA_ARGS(const ChannelSptr&,
            _opt<CompletionQueueForNextSptr>))
        .addFunction("set_error_cb", &SetErrorCb)
        .addFunction("sync_request",
            [L](ServiceStub* pServiceStub, const string& sMethod,
                    const string& sRequest) {
                return SyncRequest(L, pServiceStub, sMethod, sRequest);
            })
        .addFunction("async_request", &AsyncRequest)
        .addFunction("run", &ServiceStub::Run)
        .addFunction("shutdown", &ServiceStub::Shutdown)
    .endClass();  // ServiceStub
}  // BindServiceStub()

}  // namespace bind
