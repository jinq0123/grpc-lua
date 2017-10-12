// Author: Jin Qing (http://blog.csdn.net/jq0123)
#include "ServerReader.h"

#include <grpc_cb_core/common/status.h>  // for GetDetails()

#include <LuaIntf/LuaIntf.h>  // for LuaRef

using LuaIntf::LuaRef;

namespace impl {

// Lua reader can provide these functions:
struct LuaReaderFunctions
{
    LuaRef funOnMsg;  // function(table) | nil
    LuaRef funOnError;  // function(string, int) | nil
    LuaRef funOnEnd;  // function() | nil
};

ServerReader::ServerReader(const LuaRef& luaReader)
    : m_pLuaReaderFunctions(new LuaReaderFunctions)
{
    assert(luaReader);
    InitLuaReaderFunctions(luaReader);
}

ServerReader::~ServerReader()
{
}

void ServerReader::OnMsgStr(const std::string& msg_str)
{
    const LuaRef& f = m_pLuaReaderFunctions->funOnMsg;
    // XXX if (f) f(msg_str);
}

void ServerReader::OnError(const grpc_cb_core::Status& status)
{
    const LuaRef& f = m_pLuaReaderFunctions->funOnError;
    if (f) f(status.GetDetails(), status.GetCode());
}

void ServerReader::OnEnd()
{
    const LuaRef& f = m_pLuaReaderFunctions->funOnEnd;
    if (f) f();
}

void ServerReader::InitLuaReaderFunctions(const LuaIntf::LuaRef& luaReader)
{
    assert(luaReader);
    assert(m_pLuaReaderFunctions);
    LuaReaderFunctions& rFuns = *m_pLuaReaderFunctions;
    rFuns.funOnMsg = luaReader["OnMsg"];
    rFuns.funOnError = luaReader["OnError"];
    rFuns.funOnEnd = luaReader["OnEnd"];
}

}  // namespace impl
