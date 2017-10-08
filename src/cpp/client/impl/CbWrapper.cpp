#include "CbWrapper.h"

#include <grpc_cb_core/common/status.h>  // for Status
#include <LuaIntf/LuaIntf.h>
#include <string>

using namespace grpc_cb_core;
using namespace LuaIntf;

namespace CbWrapper {

// Convert lua message callback into MsgCb.
// function(string) -> void (const string&)
MsgCb WrapLuaMsgCb(const LuaRef& luaMsgCb)
{
    if (!luaMsgCb) return MsgCb();
    luaMsgCb.checkFunction();  // function(string)
    return [luaMsgCb](const std::string& sMsg) {
        luaMsgCb(sMsg);
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
