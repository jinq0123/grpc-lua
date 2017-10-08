// client
#include "client/BindChannel.h"
#include "client/BindClientAsyncReaderWriter.h"
#include "client/BindClientAsyncWriter.h"
#include "client/BindClientSyncReader.h"
#include "client/BindClientSyncReaderWriter.h"
#include "client/BindClientSyncWriter.h"
#include "client/BindServiceStub.h"
// server
#include "server/BindServer.h"
#include "server/BindServerReplier.h"
#include "server/BindServerWriter.h"

#include <LuaIntf/LuaIntf.h>

extern "C"
#if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__CODEGEARC__)
__declspec(dllexport)
#endif
int luaopen_grpc_lua_c(lua_State* L)
{
    assert(L);
    LuaIntf::LuaRef mod = LuaIntf::LuaRef::createTable(L);

    // client
    client::BindChannel(mod);
    client::BindClientAsyncReaderWriter(mod);
    client::BindClientAsyncWriter(mod);
    client::BindClientSyncReader(mod);
    client::BindClientSyncReaderWriter(mod);
    client::BindClientSyncWriter(mod);
    client::BindServiceStub(mod);
    // server
    server::BindServer(mod);
    server::BindServerReplier(mod);
    server::BindServerWriter(mod);

    mod.pushToStack();
    return 1;
}  // luaopen_grpc_lua_c()
