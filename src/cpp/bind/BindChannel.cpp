#include "BindChannel.h"

#include <grpc_cb_core/channel.h>  // for Channel
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace bind {

void BindChannel(const LuaRef& mod)
{
    LuaBinding(mod)
        .beginClass<Channel>("Channel")
            .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(const std::string&))
        .endClass()  // Channel
        ;
}  // BindChannel()

}  // namespace bind
