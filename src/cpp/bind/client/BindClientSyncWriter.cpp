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

// XXX return string|nil, nil means error or end
//std::tuple<bool, std::string> ReadOne(const ClientSyncReader* pReader)
//{
//    assert(pReader);
//    std::string sMsg;
//    bool ok = pReader->ReadOne(&sMsg);
//    return std::make_tuple(ok, sMsg);
//}

}  // namespace

namespace bind {

void BindClientSyncWriter(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<ClientSyncWriter>("ClientSyncWriter")
        .addFactory(&GetClientSyncWriter)
        // .addFunction("read_one", &ReadOne)
    .endClass();
}  // ClientSyncWriter()

}  // namespace bind
