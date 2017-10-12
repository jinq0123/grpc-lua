#ifndef CLIENT_IMPL_CBWRAPPER_H
#define CLIENT_IMPL_CBWRAPPER_H

#include "common/LuaRefFwd.h"  // forward LuaRef

#include <grpc_cb_core/client/msg_str_cb.h>  // for MsgStrCb
#include <grpc_cb_core/client/status_cb.h>  // for StatusCb

namespace CbWrapper {

// Convert lua message callback into MsgStrCb.
// function(string):(string|nil) | nil -> Status (const string&)
grpc_cb_core::MsgStrCb WrapLuaMsgCb(const LuaIntf::LuaRef& luaMsgCb);

// Convert lua status callback into StatusCb.
// function(error_str, status_code) -> void (const Status&)
grpc_cb_core::StatusCb WrapLuaStatusCb(const LuaIntf::LuaRef& luaStatusCb);

// Convert lua error callback into ErrorCb.
// function(error_str, status_code) -> void (const Status&)
inline grpc_cb_core::ErrorCb WrapLuaErrorCb(const LuaIntf::LuaRef& luaErrorCb)
{
    return WrapLuaStatusCb(luaErrorCb);
}

}  // namespace CbWrapper

#endif  // CLIENT_IMPL_CBWRAPPER_H
