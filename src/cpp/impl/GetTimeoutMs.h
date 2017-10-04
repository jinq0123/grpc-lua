#ifndef IMPL_GETTIMEOUTMS_H
#define IMPL_GETTIMEOUTMS_H

#include "LuaRefFwd.h"  // forward LuaRef

#include <cstdint>  // for int64_t

namespace impl {
int64_t GetTimeoutMs(const LuaIntf::LuaRef& timeoutSec);
}  // namespace impl

#endif  // IMPL_GETTIMEOUTMS_H
