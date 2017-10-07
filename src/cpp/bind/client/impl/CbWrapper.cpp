#include "BindChannel.h"

#include <grpc_cb_core/client/channel.h>  // for Channel
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace LuaIntf
{
    LUA_USING_SHARED_PTR_TYPE(std::shared_ptr)
}

namespace bind {

void BindChannel(const LuaRef& mod)
{
    LuaBinding(mod).beginClass<Channel>("Channel")
        .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(const std::string&))
    .endClass();
}  // BindChannel()

}  // namespace bind
