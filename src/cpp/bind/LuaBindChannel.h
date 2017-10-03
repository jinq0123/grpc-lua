#ifndef BIND_LUABINDCHANNEL_H
#define BIND_LUABINDCHANNEL_H

#include "impl/LuaRefFwd.h"  // forward LuaRef

namespace bind {
void LuaBindChannel(const LuaIntf::LuaRef& mod);
}  // namespace bind

#endif  // BIND_LUABINDCHANNEL_H
