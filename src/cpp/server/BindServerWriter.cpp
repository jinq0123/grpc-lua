#include "BindServerWriter.h"

#include <grpc_cb_core/server/server_writer.h>  // for ServerWriter
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace server {

void BindServerWriter(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<ServerWriter>("ServerWriter")
        .addConstructor(LUA_ARGS(const grpc_cb_core::CallSptr&))
        // .addFunction("reply", &ServerReplier::Reply)
    .endClass();
}  // BindServerWriter()

}  // namespace server
