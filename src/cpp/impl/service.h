#ifndef IMPL_SERVICE_H
#define IMPL_SERVICE_H

#include <grpc_cb/service.h>  // for Service and CallSptr

namespace LuaIntf {
class LuaRef;
}

// Adapt lua service table to grpc_cb::Service.
class Service : public grpc_cb::Service
{
public:
    using LuaRef = LuaIntf::LuaRef;
    using ServiceDescriptor = google::protobuf::ServiceDescriptor;

    Service(const ServiceDescriptor& desc, const LuaRef& luaService);
    ~Service();

public:
    const std::string& GetMethodName(size_t method_index) const override;

    void CallMethod(size_t method_index, grpc_byte_buffer* request,
        const grpc_cb::CallSptr& call_sptr) override;

private:
    const ServiceDescriptor& GetDescriptor() const override
    {
        return m_desc;
    }

private:
    const ServiceDescriptor& m_desc;
    const LuaRef& m_luaService;
};  // class Service

#endif  // IMPL_SERVICE_H
