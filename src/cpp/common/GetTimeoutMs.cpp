#include "GetTimeoutMs.h"

#include <LuaIntf/LuaIntf.h>  // for LuaRef

namespace util {

int64_t GetTimeoutMs(const LuaIntf::LuaRef& timeoutSec)
{
    // nil means no timeout
    if (!timeoutSec)
        return INT64_MAX;

    double dSec = timeoutSec.toValue<double>();
    if (dSec < INT64_MAX / 1000)
        return static_cast<int64_t>(dSec * 1000);
    return INT64_MAX;
}

}  // namespace util
