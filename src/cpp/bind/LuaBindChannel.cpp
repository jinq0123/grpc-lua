/// grpc C module binding Channel.
// @submodule grpc_lua.c

#include "LuaBindChannel.h"

#include <grpc_cb_core/channel.h>  // for Channel
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace bind {

void LuaBindChannel(const LuaRef& mod)
{
    LuaBinding(mod)
        .beginClass<Channel>("Channel")
            .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(const std::string&))
        .endClass()  // Channel
        ;
}  // LuaBindChannel()

}  // namespace bind
