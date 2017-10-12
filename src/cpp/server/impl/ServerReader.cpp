// Author: Jin Qing (http://blog.csdn.net/jq0123)
#include "ServerReader.h"

#include <grpc_cb_core/common/status.h>  // for GetDetails()

#include <LuaIntf/LuaIntf.h>  // for LuaRef
#include <cassert>

using LuaIntf::LuaRef;

namespace impl {

// Functions from server Reader.lua
struct LuaReaderFunctions
{
    LuaRef funOnMsgStr;  // function(string) -> string|nil
    LuaRef funOnError;  // function(string, int)
    LuaRef funOnEnd;  // function()
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

grpc_cb_core::Status ServerReader::OnMsgStr(const std::string& msg_str)
{
    LuaRef luaErrStr = m_pLuaReaderFunctions->funOnMsgStr.call<LuaRef>(msg_str);
    if (!luaErrStr) return grpc_cb_core::Status::OK;
    assert(LuaIntf::LuaTypeID::STRING == luaErrStr.type());
    return grpc_cb_core::Status::InternalError(
        luaErrStr.toValue<std::string>());
}

void ServerReader::OnError(const grpc_cb_core::Status& status)
{
    m_pLuaReaderFunctions->funOnError(
        status.GetDetails(), status.GetCode());
}

void ServerReader::OnEnd()
{
    m_pLuaReaderFunctions->funOnEnd();
}

void ServerReader::InitLuaReaderFunctions(const LuaIntf::LuaRef& luaReader)
{
    assert(luaReader);
    assert(m_pLuaReaderFunctions);
    LuaReaderFunctions& rFuns = *m_pLuaReaderFunctions;
    rFuns.funOnMsgStr = luaReader["on_msg_str"];
    rFuns.funOnMsgStr.checkFunction();
    rFuns.funOnError = luaReader["on_error"];
    rFuns.funOnError.checkFunction();
    rFuns.funOnEnd = luaReader["on_end"];
    rFuns.funOnEnd.checkFunction();
}

}  // namespace impl
