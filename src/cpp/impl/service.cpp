#include "service.h"

#include <google/protobuf/descriptor.h>  // for ServiceDescriptor

#include <cassert>

Service::Service(const ServiceDescriptor& desc,
    const LuaRef& luaService)
    : m_desc(desc),
    m_luaService(luaService)
{
}

Service::~Service()
{
}

const std::string& Service::GetMethodName(size_t method_index) const
{
    assert(method_index < GetMethodCount());

    const google::protobuf::MethodDescriptor* pMthdDesc =
        m_desc.method(static_cast<int>(method_index));
    assert(pMthdDesc);
    return pMthdDesc->name();
}

void Service::CallMethod(size_t method_index, grpc_byte_buffer* request,
    const grpc_cb::CallSptr& call_sptr)
{
    assert(method_index < GetMethodCount());
    if (!request) return;
    const std::string& sMethodName = GetMethodName(method_index);
    printf("Call Method: %s\n", sMethodName.c_str());
    
      //SayHello(*request_buffer,
      //    SayHello_Replier(call_sptr));
    // XXX
}

