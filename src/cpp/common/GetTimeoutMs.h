#ifndef COMMON_GETTIMEOUTMS_H
#define COMMON_GETTIMEOUTMS_H

#include "LuaRefFwd.h"  // forward LuaRef

#include <cstdint>  // for int64_t

namespace util {
int64_t GetTimeoutMs(const LuaIntf::LuaRef& timeoutSec);
}  // namespace util

#endif  // COMMON_GETTIMEOUTMS_H
