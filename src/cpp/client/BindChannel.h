#ifndef CLIENT_BINDCHANNEL_H
#define CLIENT_BINDCHANNEL_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindChannel(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDCHANNEL_H
