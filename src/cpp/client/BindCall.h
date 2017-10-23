#ifndef CLIENT_BINDCALL_H
#define CLIENT_BINDCALL_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindCall(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDCALL_H
