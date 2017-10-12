// Author: Jin Qing (http://blog.csdn.net/jq0123)
#include "ServerReader.h"

#include <grpc_cb_core/common/status.h>  // for GetDetails()

#include <LuaIntf/LuaIntf.h>  // for LuaRef

using LuaIntf::LuaRef;

namespace impl {

struct LuaReaderFunctions
{
    LuaRef funOnMsgStr;
    LuaRef funOnError;
    LuaRef funOnEnd;
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
    const LuaRef& f = m_pLuaReaderFunctions->funOnMsgStr;
    if (f) f(msg_str);
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
    rFuns.funOnMsgStr = luaReader["OnMsgStr"];
    rFuns.funOnError = luaReader["OnError"];
    rFuns.funOnEnd = luaReader["OnEnd"];
}

}  // namespace impl
