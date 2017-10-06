#include "BindServiceStub.h"

#include "impl/GetTimeoutMs.h"

#include <grpc_cb_core/common/completion_queue_for_next_sptr.h>  // for CompletionQueueForNextSptr
#include <grpc_cb_core/common/status.h>  // for Status
#include <grpc_cb_core/client/client_async_reader.h>  // for ClientAsyncReader
#include <grpc_cb_core/client/service_stub.h>  // for ServiceStub

#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;
using string = std::string;

namespace {

// Convert lua error callback into ErrorCb.
// function(error_str, status_code) -> void (const Status&)
ErrorCb FromLuaErrorCb(const LuaRef& luaErrorCb)
{
    if (!luaErrorCb) return ErrorCb();
    luaErrorCb.checkFunction();  // function(string, int)
    return [luaErrorCb](const Status& status) {
        // Need to nil error_str if no error.
        if (status.ok())
            luaErrorCb(nullptr, status.GetCode());
        else
            luaErrorCb(status.GetDetails(), status.GetCode());
    };
}

// Convert lua message callback into MsgCb.
// function(string) -> void (const string&)
MsgCb FromLuaMsgCb(const LuaRef& luaMsgCb)
{
    if (!luaMsgCb) return MsgCb();
    luaMsgCb.checkFunction();  // function(string)
    return [luaMsgCb](const string& sMsg) {
        luaMsgCb(sMsg);
    };
}

void SetErrorCb(ServiceStub* pServiceStub, const LuaRef& luaErrorCb)
{
    assert(pServiceStub);
    pServiceStub->SetErrorCb(FromLuaErrorCb(luaErrorCb));
}

void SetTimeoutSec(ServiceStub* pServiceStub, const LuaRef& luaTimeoutSec)
{
    assert(pServiceStub);
    int64_t nTimeoutMs = impl::GetTimeoutMs(luaTimeoutSec);
    pServiceStub->SetCallTimeoutMs(nTimeoutMs);
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
    ResponseCb cbResponse = FromLuaMsgCb(luaResponseCb);
    ErrorCb cbError = FromLuaErrorCb(luaErrorCb);
    pServiceStub->AsyncRequest(sMethod, sRequest, cbResponse, cbError);
}  // AsyncRequest()

void AsyncRequestRead(ServiceStub* pServiceStub,
    const string& sMethod, const string sRequest,
    const LuaRef& luaMsgCb, const LuaRef& luaStatusCb)
{
    ClientAsyncReader reader(pServiceStub->GetChannelSptr(),
        sMethod, sRequest, pServiceStub->GetCompletionQueue(),
        pServiceStub->GetCallTimeoutMs());
    reader.ReadEach(FromLuaMsgCb(luaMsgCb), FromLuaErrorCb(luaStatusCb));
}

}  // namespace

namespace bind {

void BindServiceStub(const LuaRef& mod)
{
    lua_State* L = mod.state();
    LuaBinding(mod).beginClass<ServiceStub>("ServiceStub")
        .addConstructor(LUA_ARGS(const ChannelSptr&,
            _opt<CompletionQueueForNextSptr>))

        .addFunction("set_error_cb", &SetErrorCb)
        .addFunction("set_timeout_sec", &SetTimeoutSec)

        .addFunction("sync_request",
            [L](ServiceStub* pServiceStub, const string& sMethod,
                    const string& sRequest) {
                return SyncRequest(L, pServiceStub, sMethod, sRequest);
            })
        .addFunction("async_request", &AsyncRequest)

        // Async request server side streaming.
        .addFunction("async_request_read", &AsyncRequestRead)

        .addFunction("run", &ServiceStub::Run)
        .addFunction("shutdown", &ServiceStub::Shutdown)
    .endClass();  // ServiceStub
}  // BindServiceStub()

}  // namespace bind
