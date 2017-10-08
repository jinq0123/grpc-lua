#ifndef CLIENT_BINDCLIENTSYNCREADERWRITER_H
#define CLIENT_BINDCLIENTSYNCREADERWRITER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindClientSyncReaderWriter(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDCLIENTSYNCWRITER_H
