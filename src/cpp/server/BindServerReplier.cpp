#include "BindServerReplier.h"

#include <grpc_cb_core/server/server_replier.h>  // for ServerReplier
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace server {

void BindServerReplier(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<ServerReplier>("ServerReplier")
        .addConstructor(LUA_ARGS(const grpc_cb_core::CallSptr&))
        .addFunction("reply", &ServerReplier::Reply)
    .endClass();
}  // BindServerReplier()

}  // namespace server
