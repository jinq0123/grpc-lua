#include "BindClientSyncWriter.h"

#include "impl/GetTimeoutMs.h"

#include <grpc_cb_core/client_sync_writer.h>  // for ClientSyncWriter
#include <LuaIntf/LuaIntf.h>

#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientSyncWriter GetClientSyncWriter(const ChannelSptr& pChannel,
    const std::string& sMethod, const LuaRef& timeoutSec)
{
    int64_t nTimeoutMs = impl::GetTimeoutMs(timeoutSec);
    return ClientSyncWriter(pChannel, sMethod, nTimeoutMs);
}

}  // namespace

namespace bind {

void BindClientSyncWriter(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<ClientSyncWriter>("ClientSyncWriter")
        .addFactory(&GetClientSyncWriter)
        .addFunction("write", &ClientSyncWriter::Write)
    .endClass();
}  // ClientSyncWriter()

}  // namespace bind
