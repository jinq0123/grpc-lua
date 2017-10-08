#ifndef CLIENT_BINDCLIENTSYNCREADER_H
#define CLIENT_BINDCLIENTSYNCREADER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindClientSyncReader(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDCLIENTSYNCREADER_H
