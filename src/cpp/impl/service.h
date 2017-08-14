#ifndef IMPL_SERVICE_H
#define IMPL_SERVICE_H

#include <grpc_cb/service.h>  // for Service and CallSptr

#include <vector>

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
    const std::string& GetMethodName(size_t iMthdIdx) const override;

    void CallMethod(size_t iMthdIdx, grpc_byte_buffer* request,
        const grpc_cb::CallSptr& call_sptr) override;

private:
    const ServiceDescriptor& GetDescriptor() const override
    {
        return m_desc;
    }

private:
    void InitMethodNames();
    const google::protobuf::MethodDescriptor& GetMthdDesc(
        size_t iMthdIdx) const;

private:
    const ServiceDescriptor& m_desc;
    const LuaRef& m_luaService;
    const LuaRef& m_luapbintf;  // = require("luapbintf")
    std::vector<std::string> m_vMethodNames;
};  // class Service

#endif  // IMPL_SERVICE_H
