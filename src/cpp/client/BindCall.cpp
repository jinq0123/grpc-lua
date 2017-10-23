#include "BindCall.h"

#include <grpc_cb_core/common/call_sptr.h>  // for CallSptr
#include <LuaIntf/LuaIntf.h>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace client {

void BindCall(const LuaRef& mod)
{
    // Need CallSptr object, not LUA_SP(CallSptr).
    LuaBinding(mod).beginClass<CallSptr>("Call")
        // Can not construct from Lua.
    .endClass();
}  // BindCall()

}  // namespace client
