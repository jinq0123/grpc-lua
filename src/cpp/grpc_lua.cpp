#include "bind/BindChannel.h"
#include "bind/BindServiceStub.h"
#include "bind/BindServer.h"
#include "bind/BindServerReplier.h"

#include <LuaIntf/LuaIntf.h>

extern "C"
#if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__CODEGEARC__)
__declspec(dllexport)
#endif
int luaopen_grpc_lua_c(lua_State* L)
{
    assert(L);
    LuaIntf::LuaRef mod = LuaIntf::LuaRef::createTable(L);

    bind::BindChannel(mod);
    bind::BindServiceStub(mod);
    bind::BindServer(mod);
    bind::BindServerReplier(mod);

    mod.pushToStack();
    return 1;
}  // luaopen_grpc_lua_c()
