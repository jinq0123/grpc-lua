#include "BindClientAsyncWriter.h"

#include "common/GetTimeoutMs.h"

#include <grpc_cb_core/client/client_async_writer.h>  // for ClientAsyncWriter
#include <grpc_cb_core/client/service_stub.h>         // for ServiceStub
#include <grpc_cb_core/common/completion_queue_for_next.h>  // to cast GetCompletionQueue()
#include <grpc_cb_core/common/status.h>                     // for Status

#include <LuaIntf/LuaIntf.h>

#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientAsyncWriter GetClientAsyncWriter(const ServiceStub& stub,
    const std::string& sMethod, const LuaRef& timeoutSec)
{
    const ChannelSptr pChannel = stub.GetChannelSptr();
    const CompletionQueueSptr pCq = stub.GetCompletionQueue();
    assert(pChannel);
    assert(pCq);
    int64_t nTimeoutMs = util::GetTimeoutMs(timeoutSec);
    return ClientAsyncWriter(pChannel, sMethod, pCq, nTimeoutMs);
}

void Close(ClientAsyncWriter* pWriter, LuaRef& luaCloseCb)
{
    assert(pWriter);
    CloseCb cbClose;  // default empty callback
    if (luaCloseCb)
    {
        cbClose = [luaCloseCb](const Status& status,
            const std::string& sResponse)
        {
            if (status.ok())
                luaCloseCb(sResponse, nullptr, status.GetCode());
            else
                luaCloseCb(nullptr, status.GetDetails(), status.GetCode());
        };
    }

    pWriter->Close(cbClose);
}  // Close()

}  // namespace

namespace client {

void BindClientAsyncWriter(const LuaRef& mod)
{
    lua_State* L = mod.state();
    assert(L);
    LuaBinding(mod).beginClass<ClientAsyncWriter>("ClientAsyncWriter")
        .addFactory(&GetClientAsyncWriter)
        .addFunction("write", &ClientAsyncWriter::Write)
        .addFunction("close", &Close)
    .endClass();
}  // BindClientAsyncWriter()

}  // namespace client
