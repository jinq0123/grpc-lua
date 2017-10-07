#include "BindClientAsyncWriter.h"

#include "impl/GetTimeoutMs.h"

#include <grpc_cb_core/client/client_async_writer.h>  // for ClientAsyncWriter
#include <LuaIntf/LuaIntf.h>

#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientAsyncWriter GetClientAsyncWriter(const ChannelSptr& pChannel,
    const std::string& sMethod, const CompletionQueueSptr& pCq,
    const LuaRef& timeoutSec)
{
    assert(pCq);
    int64_t nTimeoutMs = impl::GetTimeoutMs(timeoutSec);
    return ClientAsyncWriter(pChannel, sMethod, pCq, nTimeoutMs);
}

//std::tuple<LuaRef, std::string, grpc_status_code>
//Close(const ClientSyncWriter& writer, lua_State* L)
//{
//    assert(L);
//    std::string response;
//    Status status = writer.Close(&response);
//    LuaRef result = LuaRef(L, nullptr);
//    if (status.ok()) result = LuaRef::fromValue(L, response);
//    return std::make_tuple(result, status.GetDetails(), status.GetCode());
//}  // Close()

}  // namespace

namespace bind {

void BindClientAsyncWriter(const LuaRef& mod)
{
    lua_State* L = mod.state();
    assert(L);
    LuaBinding(mod).beginClass<ClientAsyncWriter>("ClientAsyncWriter")
        .addFactory(&GetClientAsyncWriter)
        .addFunction("write", &ClientAsyncWriter::Write)
        //.addFunction("close",
        //    [L](const ClientSyncWriter* pWriter) {
        //        assert(pWriter);
        //        Close(*pWriter, L);
        //    })
    .endClass();
}  // ClientAsyncWriter()

}  // namespace bind
