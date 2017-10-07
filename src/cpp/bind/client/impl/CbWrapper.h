#ifndef BIND_CLIENT_IMPL_CBWRAPPER_H
#define BIND_CLIENT_IMPL_CBWRAPPER_H

#include "impl/LuaRefFwd.h"  // forward LuaRef

#include <grpc_cb_core/client/msg_cb.h>  // for MsgCb
#include <grpc_cb_core/client/status_cb.h>  // for StatusCb

namespace CbWrapper {
grpc_cb_core::MsgCb WrapLuaMsgCb(const LuaIntf::LuaRef& lauMsgCb);
grpc_cb_core::StatusCb WrapLuaStatusCb(const LuaIntf::LuaRef& lauStatusCb);
}  // namespace CbWrapper

#endif  // BIND_CLIENT_IMPL_CBWRAPPER_H
