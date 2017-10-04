#include "BindServerReplier.h"

#include <grpc_cb_core/server_replier.h>  // for ServerReplier
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace LuaIntf
{
    LUA_USING_SHARED_PTR_TYPE(std::shared_ptr)
}

namespace bind {

void BindServerReplier(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<ServerReplier>("ServerReplier")
        .addConstructor(LUA_SP(std::shared_ptr<ServerReplier>),
            LUA_ARGS(const grpc_cb_core::CallSptr&))
        .addFunction("reply", &ServerReplier::Reply)
    .endClass();
}  // BindServerReplier()

}  // namespace bind
