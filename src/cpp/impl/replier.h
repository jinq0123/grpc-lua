#ifndef IMPL_REPLIER_H
#define IMPL_REPLIER_H

#include <grpc_cb/server_replier.h>  // for CallSptr

class Replier
{
public:
    Replier(const grpc_cb::CallSptr& pCall);
    ~Replier();
};  // class Replier

#endif  // IMPL_REPLIER_H
