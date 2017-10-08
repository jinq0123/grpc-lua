#ifndef SERVER_BINDSERVER_H
#define SERVER_BINDSERVER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace server {
void BindServer(const LuaIntf::LuaRef& mod);
}  // namespace server

#endif  // SERVER_BINDSERVER_H
