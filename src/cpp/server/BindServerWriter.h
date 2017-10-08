#ifndef SERVER_BINDSERVERWRITER_H
#define SERVER_BINDSERVERWRITER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace server {
void BindServerWriter(const LuaIntf::LuaRef& mod);
}  // namespace server

#endif  // SERVER_BINDSERVERWRITER_H
