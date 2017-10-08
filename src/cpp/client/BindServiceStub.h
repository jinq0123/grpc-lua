#ifndef CLIENT_BINDSERVICESTUB_H
#define CLIENT_BINDSERVICESTUB_H

#include "common/LuaRefFwd.h"  // forward LuaRef

namespace client {
void BindServiceStub(const LuaIntf::LuaRef& mod);
}  // namespace client

#endif  // CLIENT_BINDSERVICESTUB_H
