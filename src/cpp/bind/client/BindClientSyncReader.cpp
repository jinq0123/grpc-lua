#include "BindClientSyncReader.h"

#include "impl/GetTimeoutMs.h"

#include <grpc_cb_core/client_sync_reader.h>  // for ClientSyncReader
#include <LuaIntf/LuaIntf.h>

#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientSyncReader GetClientSyncReader(const ChannelSptr& pChannel,
    const std::string& sMethod, const std::string& sRequest,
    const LuaRef& timeoutSec)
{
    int64_t nTimeoutMs = impl::GetTimeoutMs(timeoutSec);
    return ClientSyncReader(pChannel, sMethod, sRequest, nTimeoutMs);
}

// XXX return string|nil, nil means error or end
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
