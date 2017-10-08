#ifndef CLIENT_BINDCLIENTASYNCREADERWRITER_H
#define CLIENT_BINDCLIENTASYNCREADERWRITER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindClientAsyncReaderWriter(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDCLIENTASYNCWRITER_H
