#include "BindClientAsyncReaderWriter.h"

#include "impl/CbWrapper.h"
#include "common/GetTimeoutMs.h"

#include <grpc_cb_core/client/client_async_reader_writer.h>  // for ClientAsyncReaderWriter
#include <grpc_cb_core/client/service_stub.h>                // for ServiceStub
#include <grpc_cb_core/common/completion_queue_for_next.h>  // to cast GetCompletionQueue()
#include <grpc_cb_core/common/status.h>                     // for Status

#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ClientAsyncReaderWriter GetClientAsyncReaderWriter(
    const ServiceStub& stub, const std::string& sMethod,
    const LuaRef& timeoutSec, const LuaRef& luaStatusCb)
{
    const ChannelSptr pChannel = stub.GetChannelSptr();
    const CompletionQueueSptr pCq = stub.GetCompletionQueue();
    assert(pChannel);
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

namespace client {

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

}  // namespace client
