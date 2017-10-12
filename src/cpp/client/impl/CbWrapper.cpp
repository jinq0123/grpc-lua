#include "CbWrapper.h"

#include <grpc_cb_core/common/status.h>  // for Status
#include <LuaIntf/LuaIntf.h>
#include <cassert>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace CbWrapper {

// Convert lua message callback into MsgStrCb.
// function(string):(string|nil) | nil -> Status (const string&)
MsgStrCb WrapLuaMsgCb(const LuaRef& luaMsgCb)
{
    if (!luaMsgCb) return MsgStrCb();
    luaMsgCb.checkFunction();  // function(string)
    return [luaMsgCb](const std::string& sMsg) {
        LuaRef luaErrStr = luaMsgCb.call<LuaRef>(sMsg);
        if (!luaErrStr) return Status::OK;
        assert(LuaTypeID::STRING == luaErrStr.type());
        return Status::InternalError(luaErrStr.toValue<std::string>());
    };
}

// Convert lua status callback into StatusCb.
// function(error_str, status_code) -> void (const Status&)
StatusCb WrapLuaStatusCb(const LuaRef& luaStatusCb)
{
    if (!luaStatusCb) return ErrorCb();
    luaStatusCb.checkFunction();  // function(string, int)
    return [luaStatusCb](const Status& status) {
        // Need to nil error_str if no error.
        if (status.ok())
            luaStatusCb(nullptr, status.GetCode());
        else
            luaStatusCb(status.GetDetails(), status.GetCode());
    };
}

}  // namespace CbWrapper
