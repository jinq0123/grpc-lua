#ifndef BIND_BINDSERVER_H
#define BIND_BINDSERVER_H

#include "impl/LuaRefFwd.h"  // forward LuaRef

namespace bind {
void BindServer(const LuaIntf::LuaRef& mod);
}  // namespace bind

#endif  // BIND_BINDSERVER_H
