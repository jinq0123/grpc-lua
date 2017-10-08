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
    bind::BindChannel(mod);
    bind::BindClientAsyncReaderWriter(mod);
    bind::BindClientAsyncWriter(mod);
    bind::BindClientSyncReader(mod);
    bind::BindClientSyncReaderWriter(mod);
    bind::BindClientSyncWriter(mod);
    bind::BindServiceStub(mod);
    // server
    bind::BindServer(mod);
    bind::BindServerReplier(mod);

    mod.pushToStack();
    return 1;
}  // luaopen_grpc_lua_c()
