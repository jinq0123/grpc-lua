#include "BindClientSyncReaderWriter.h"

#include "common/GetTimeoutMs.h"

#include <grpc_cb_core/client/client_sync_reader_writer.h>  // for ClientSyncReaderWriter
#include <LuaIntf/LuaIntf.h>

#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientSyncReaderWriter GetClientSyncReaderWriter(const ChannelSptr& pChannel,
    const std::string& sMethod, const LuaRef& timeoutSec)
{
    int64_t nTimeoutMs = util::GetTimeoutMs(timeoutSec);
    return ClientSyncReaderWriter(pChannel, sMethod, nTimeoutMs);
}

// return string|nil, nil means error or end
LuaRef ReadOne(const ClientSyncReaderWriter& rw, lua_State* L)
{
    assert(L);
    std::string sMsg;
    if (rw.ReadOne(&sMsg))
        return LuaRef::fromValue(L, sMsg);
    return LuaRef(L, nullptr);
}

}  // namespace

namespace client {

void BindClientSyncReaderWriter(const LuaRef& mod)
{
    lua_State* L = mod.state();
    assert(L);
    LuaBinding(mod).beginClass<ClientSyncReaderWriter>("ClientSyncReaderWriter")
        .addFactory(&GetClientSyncReaderWriter)
        .addFunction("read_one",
            [L](const ClientSyncReaderWriter* pRdWr) {
                assert(pRdWr);
                return ReadOne(*pRdWr, L);
            })
        .addFunction("write", &ClientSyncReaderWriter::Write)
        .addFunction("close_writing", &ClientSyncReaderWriter::CloseWriting)
    .endClass();
}  // BindClientSyncReaderWriter()

}  // namespace client
