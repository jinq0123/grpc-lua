#include "BindServerReplier.h"

#include "grpc_cb_core/common/status.h"  // for Status
#include <grpc_cb_core/server/server_replier.h>  // for ServerReplier
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

static void ReplyError(ServerReplier* pReplier,
    const std::string& sError, int nStatusCode)
{
    assert(pReplier);
    pReplier->ReplyError(Status(static_cast<grpc_status_code>(
        nStatusCode), sError));
}

namespace server {

void BindServerReplier(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<ServerReplier>("ServerReplier")
        .addConstructor(LUA_ARGS(const grpc_cb_core::CallSptr&))
        .addFunction("reply", &ServerReplier::ReplyStr)
        .addFunction("reply_error", &ReplyError)
    .endClass();
}  // BindServerReplier()

}  // namespace server
