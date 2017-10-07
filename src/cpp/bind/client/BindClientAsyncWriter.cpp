#include "BindClientAsyncWriter.h"

#include "impl/GetTimeoutMs.h"

#include <grpc_cb_core/client/client_async_writer.h>  // for ClientAsyncWriter
#include <grpc_cb_core/common/status.h>  // for Status
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

void Close(ClientAsyncWriter* pWriter, LuaRef& luaCloseCb)
{
    assert(pWriter);
    if (!luaCloseCb)
    {
        pWriter->Close(CloseCb());  // use empty callback
        return;
    }

    pWriter->Close(
        [luaCloseCb](const Status& status, const std::string& sResponse) {
            if (status.ok())
                luaCloseCb(sResponse, nullptr, status.GetCode());
            else
                luaCloseCb(nullptr, status.GetDetails(), status.GetCode());
        });
}  // Close()

}  // namespace

namespace bind {

void BindClientAsyncWriter(const LuaRef& mod)
{
    lua_State* L = mod.state();
    assert(L);
    LuaBinding(mod).beginClass<ClientAsyncWriter>("ClientAsyncWriter")
        .addFactory(&GetClientAsyncWriter)
        .addFunction("write", &ClientAsyncWriter::Write)
        .addFunction("close", &Close)
    .endClass();
}  // ClientAsyncWriter()

}  // namespace bind
