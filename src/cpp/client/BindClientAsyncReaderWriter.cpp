#include "BindClientAsyncReaderWriter.h"

#include "impl/CbWrapper.h"
#include "common/GetTimeoutMs.h"

#include <grpc_cb_core/client/client_async_reader_writer.h>  // for ClientAsyncReaderWriter
#include <grpc_cb_core/common/status.h>  // for Status

#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientAsyncReaderWriter GetClientAsyncReaderWriter(const ChannelSptr& pChannel,
    const std::string& sMethod, const CompletionQueueSptr& pCq,
    const LuaRef& timeoutSec, const LuaRef& luaStatusCb)
{
    assert(pCq);
    int64_t nTimeoutMs = util::GetTimeoutMs(timeoutSec);
    StatusCb cbStatus = CbWrapper::WrapLuaStatusCb(luaStatusCb);
    return ClientAsyncReaderWriter(pChannel, sMethod, pCq,
                                   nTimeoutMs, cbStatus);
}

// luaMsgCb is nil or function(string)
void ReadEach(ClientAsyncReaderWriter* pRw, const LuaRef& luaMsgCb)
{
    assert(pRw);
    pRw->ReadEach(CbWrapper::WrapLuaMsgCb(luaMsgCb));
}

}  // namespace

namespace bind {

void BindClientAsyncReaderWriter(const LuaRef& mod)
{
    lua_State* L = mod.state();
    assert(L);
    LuaBinding(mod).beginClass<ClientAsyncReaderWriter>("ClientAsyncReaderWriter")
        .addFactory(&GetClientAsyncReaderWriter)
        .addFunction("read_each", &ReadEach)
        .addFunction("write", &ClientAsyncReaderWriter::Write)
        .addFunction("close_writing", &ClientAsyncReaderWriter::CloseWriting)
    .endClass();
}  // BindClientAsyncReaderWriter()

}  // namespace bind
