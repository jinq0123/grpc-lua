#include "BindChannel.h"

#include <grpc_cb_core/client_sync_reader.h>  // for ClientSyncReader
#include <LuaIntf/LuaIntf.h>

#include <cstdint>  // for INT64_MAX
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientSyncReader GetClientSyncReader(const ChannelSptr& pChannel,
    const std::string& sMethod, const std::string& sRequest,
    const LuaRef& timeoutSec)
{
    int64_t nTimeoutMs = INT64_MAX;  // default timeoutSec == nil
    if (timeoutSec)
    {
        double dSec = timeoutSec.toValue<double>();
        if (dSec < INT64_MAX / 1000)
            nTimeoutMs = static_cast<int64_t>(dSec * 1000);
    }
    return ClientSyncReader(pChannel, sMethod, sRequest, nTimeoutMs);
}

std::tuple<bool, std::string> ReadOne(const ClientSyncReader* pReader)
{
    assert(pReader);
    std::string sMsg;
    bool ok = pReader->ReadOne(&sMsg);
    return std::make_tuple(ok, sMsg);
}

}  // namespace

namespace bind {

void BindClientSyncReader(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<ClientSyncReader>("ClientSyncReader")
        .addFactory(&GetClientSyncReader)
        .addFunction("read_one", &ReadOne)
    .endClass();
}  // ClientSyncReader()

}  // namespace bind
