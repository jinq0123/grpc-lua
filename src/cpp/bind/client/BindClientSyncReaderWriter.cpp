#include "BindClientSyncReaderWriter.h"

#include "impl/GetTimeoutMs.h"

#include <grpc_cb_core/client/client_sync_reader_writer.h>  // for ClientSyncReaderWriter
#include <LuaIntf/LuaIntf.h>

#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientSyncReaderWriter GetClientSyncReaderWriter(const ChannelSptr& pChannel,
    const std::string& sMethod, const LuaRef& timeoutSec)
{
    int64_t nTimeoutMs = impl::GetTimeoutMs(timeoutSec);
    return ClientSyncReaderWriter(pChannel, sMethod, nTimeoutMs);
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

void BindClientSyncReaderWriter(const LuaRef& mod)
{
    lua_State* L = mod.state();
    assert(L);
    LuaBinding(mod).beginClass<ClientSyncReaderWriter>("ClientSyncReaderWriter")
        .addFactory(&GetClientSyncReaderWriter)
        //.addFunction("write", &ClientSyncWriter::Write)
        //.addFunction("close",
        //    [L](const ClientSyncWriter* pWriter) {
        //        assert(pWriter);
        //        Close(*pWriter, L);
        //    })
    .endClass();
}  // ClientSyncWriter()

}  // namespace bind
