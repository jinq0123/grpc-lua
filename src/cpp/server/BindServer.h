#ifndef BIND_SERVER_BINDSERVER_H
#define BIND_SERVER_BINDSERVER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace bind {
void BindServer(const LuaIntf::LuaRef& mod);
}  // namespace bind

#endif  // BIND_SERVER_BINDSERVER_H
