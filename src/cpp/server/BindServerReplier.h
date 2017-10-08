#ifndef SERVER_BINDSERVERREPLIER_H
#define SERVER_BINDSERVERREPLIER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace server {
void BindServerReplier(const LuaIntf::LuaRef& mod);
}  // namespace server

#endif  // SERVER_BINDSERVERREPLIER_H
