// Author: Jin Qing (http://blog.csdn.net/jq0123)
#include "ServerReader.h"

#include <LuaIntf/LuaIntf.h>  // for LuaRef

namespace impl {

ServerReader::ServerReader(const LuaRef& luaReader)
    : m_pLuaReader(new LuaRef(luaReader))
{
    assert(luaReader);
}

ServerReader::~ServerReader()
{
}

void ServerReader::OnMsgStr(const std::string& msg_str)
{
    // XXX
}

void ServerReader::OnError(const grpc_cb_core::Status& status)
{
    // XXX
}

void ServerReader::OnEnd()
{
    // XXX
}

}  // namespace impl
