#ifndef IMPL_REPLIER_H
#define IMPL_REPLIER_H

#include <grpc_cb/server_replier.h>  // for CallSptr

namespace LuaIntf {
class LuaRef;
}

class Replier
{
public:
    Replier(const grpc_cb::CallSptr& pCall);
    ~Replier();

public:
    void Reply(const LuaIntf::LuaRef& response) const;

private:
    const grpc_cb::CallSptr m_pCall;
};  // class Replier

#endif  // IMPL_REPLIER_H
