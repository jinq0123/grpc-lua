#ifndef BIND_CLIENT_BINDSERVICESTUB_H
#define BIND_CLIENT_BINDSERVICESTUB_H

#include "impl/LuaRefFwd.h"  // forward LuaRef

namespace bind {
void BindServiceStub(const LuaIntf::LuaRef& mod);
}  // namespace bind

#endif  // BIND_CLIENT_BINDSERVICESTUB_H
