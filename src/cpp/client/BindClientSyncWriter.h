#ifndef CLIENT_BINDCLIENTSYNCWRITER_H
#define CLIENT_BINDCLIENTSYNCWRITER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindClientSyncWriter(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDCLIENTSYNCWRITER_H
