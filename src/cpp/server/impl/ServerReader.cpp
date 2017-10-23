// Author: Jin Qing (http://blog.csdn.net/jq0123)
#include "ServerReader.h"

#include <grpc_cb_core/common/status.h>  // for GetDetails()

#include <LuaIntf/LuaIntf.h>  // for LuaRef
#include <cassert>

namespace impl {

ServerReader::ServerReader(const LuaRef& luaReader)
    : m_pLuaReader(new LuaRef(luaReader))
{
    assert(luaReader);
}

ServerReader::~ServerReader()
{
}

grpc_cb_core::Status ServerReader::OnMsgStr(const std::string& msg_str)
{
    LuaRef luaErrStr = m_pLuaReader->dispatch<LuaRef>("on_msg_str", msg_str);
    if (!luaErrStr) return grpc_cb_core::Status::OK;
    assert(LuaIntf::LuaTypeID::STRING == luaErrStr.type());
    return grpc_cb_core::Status::InternalError(
        luaErrStr.toValue<std::string>());
}

void ServerReader::OnError(const grpc_cb_core::Status& status)
{
    m_pLuaReader->dispatch("on_error",
        status.GetDetails(), status.GetCode());
}

void ServerReader::OnEnd()
{
    m_pLuaReader->dispatch("on_end");
}

}  // namespace impl
