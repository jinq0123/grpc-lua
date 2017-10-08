#include "BindServiceStub.h"

#include "impl/CbWrapper.h"
#include "common/GetTimeoutMs.h"

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

void SetErrorCb(ServiceStub* pServiceStub, const LuaRef& luaErrorCb)
{
    assert(pServiceStub);
    pServiceStub->SetErrorCb(CbWrapper::WrapLuaErrorCb(luaErrorCb));
}  // SetErrorCb()

void SetTimeoutSec(ServiceStub* pServiceStub, const LuaRef& luaTimeoutSec)
{
    assert(pServiceStub);
    int64_t nTimeoutMs = util::GetTimeoutMs(luaTimeoutSec);
    pServiceStub->SetCallTimeoutMs(nTimeoutMs);
}  // SetTimeoutSec()

// Sync request.
// Return (response_str|nil, error_str|nil, status_code).
std::tuple<LuaRef, LuaRef, LuaRef>
SyncRequest(ServiceStub& rServiceStub, const string& sMethod,
    const string& sRequest, lua_State* L)
{
    assert(L);
    string sResponse;
    Status status = rServiceStub.SyncRequest(
        sMethod, sRequest, sResponse);
    const LuaRef NIL(L, nullptr);
    LuaRef luaStatusCode = LuaRef::fromValue(L, status.GetCode());
    if (status.ok())
    {
        // (response_str, nil, status_code)
        return std::make_tuple(LuaRef::fromValue(
            L, sResponse), NIL, luaStatusCode);
    }
    // (nil, error_str, status_code)
    return std::make_tuple(NIL, LuaRef::fromValue(
        L, status.GetDetails()), luaStatusCode);
}  // SyncRequest()

void AsyncRequest(ServiceStub* pServiceStub,
    const string& sMethod, const string& sRequest,
    const LuaRef& luaResponseCb, const LuaRef& luaErrorCb)
{
    assert(pServiceStub);
    ResponseCb cbResponse = CbWrapper::WrapLuaMsgCb(luaResponseCb);
    ErrorCb cbError = CbWrapper::WrapLuaErrorCb(luaErrorCb);
    pServiceStub->AsyncRequest(sMethod, sRequest, cbResponse, cbError);
}  // AsyncRequest()

void AsyncRequestRead(ServiceStub* pServiceStub,
    const string& sMethod, const string sRequest,
    const LuaRef& luaMsgCb, const LuaRef& luaStatusCb)
{
    ClientAsyncReader reader(pServiceStub->GetChannelSptr(),
        sMethod, sRequest, pServiceStub->GetCompletionQueue(),
        pServiceStub->GetCallTimeoutMs());
    reader.ReadEach(CbWrapper::WrapLuaMsgCb(luaMsgCb),
        CbWrapper::WrapLuaErrorCb(luaStatusCb));
}  // AsyncRequestRead()

}  // namespace

namespace bind {

void BindServiceStub(const LuaRef& mod)
{
    lua_State* L = mod.state();
    LuaBinding(mod).beginClass<ServiceStub>("ServiceStub")
        .addConstructor(LUA_ARGS(const ChannelSptr&,
            _opt<CompletionQueueForNextSptr>))

        .addFunction("set_error_cb", &SetErrorCb)
        .addFunction("get_completion_queue", &ServiceStub::GetCompletionQueue)
        .addFunction("set_timeout_sec", &SetTimeoutSec)

        .addFunction("sync_request",
            [L](ServiceStub* pServiceStub, const string& sMethod,
                    const string& sRequest) {
                assert(pServiceStub);
                return SyncRequest(*pServiceStub, sMethod, sRequest, L);
            })
        .addFunction("async_request", &AsyncRequest)

        // Async request server side streaming.
        .addFunction("async_request_read", &AsyncRequestRead)

        .addFunction("run", &ServiceStub::Run)
        .addFunction("shutdown", &ServiceStub::Shutdown)
    .endClass();  // ServiceStub
}  // BindServiceStub()

}  // namespace bind
