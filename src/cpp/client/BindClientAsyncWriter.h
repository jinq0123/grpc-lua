#ifndef CLIENT_BINDCLIENTASYNCWRITER_H
#define CLIENT_BINDCLIENTASYNCWRITER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindClientAsyncWriter(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDCLIENTASYNCWRITER_H
