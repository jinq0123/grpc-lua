#ifndef BIND_CLIENT_BINDCHANNEL_H
#define BIND_CLIENT_BINDCHANNEL_H

#include "impl/LuaRefFwd.h"  // forward LuaRef

namespace bind {
void BindChannel(const LuaIntf::LuaRef& mod);
}  // namespace bind

#endif  // BIND_CLIENT_BINDCHANNEL_H
