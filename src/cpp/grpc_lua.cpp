// client
#include "bind/client/BindChannel.h"
#include "bind/client/BindClientSyncReader.h"
#include "bind/client/BindClientSyncWriter.h"
#include "bind/client/BindServiceStub.h"
// server
#include "bind/server/BindServer.h"
#include "bind/server/BindServerReplier.h"

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
    bind::BindClientSyncReader(mod);
    bind::BindClientSyncWriter(mod);
    bind::BindServiceStub(mod);
    // server
    bind::BindServer(mod);
    bind::BindServerReplier(mod);

    mod.pushToStack();
    return 1;
}  // luaopen_grpc_lua_c()
