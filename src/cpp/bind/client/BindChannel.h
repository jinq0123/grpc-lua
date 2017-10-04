#ifndef BIND_BINDCHANNEL_H
#define BIND_BINDCHANNEL_H

#include "impl/LuaRefFwd.h"  // forward LuaRef

namespace bind {
void BindChannel(const LuaIntf::LuaRef& mod);
}  // namespace bind

#endif  // BIND_BINDCHANNEL_H
