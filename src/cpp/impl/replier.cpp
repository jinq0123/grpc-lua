#include "replier.h"

#include <LuaIntf/LuaIntf.h>  // for LuaRef

Replier::Replier(const grpc_cb::CallSptr& pCall)
    : m_pCall(pCall)
{
    assert(pCall);
}

Replier::~Replier()
{
}

void Replier::Reply(const LuaIntf::LuaRef& response) const
{
    response.checkTable();
    // XXX
}

