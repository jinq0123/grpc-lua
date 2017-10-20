#include "BindChannel.h"

#include <grpc_cb_core/client/channel.h>  // for Channel
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace {

ChannelSptr GetChannelSptr(const std::string& sTarget)
{
    return std::make_shared<Channel>(sTarget);
}

}  // namespace

namespace client {

void BindChannel(const LuaRef& mod)
{
    // Need ChannelSptr object, not LUA_SP(ChannelSptr).
    LuaBinding(mod).beginClass<ChannelSptr>("Channel")
        // NOT .addConstructor(LUA_SP(ChannelSptr), LUA_ARGS(const std::string&))
        .addFactory(&GetChannelSptr)
    .endClass();
}  // BindChannel()

}  // namespace client
