#ifndef IMPL_SERVICE_H
#define IMPL_SERVICE_H

#include "LuaRefFwd.h"  // forward LuaRef

#include <grpc_cb_core/service.h>  // for Service and CallSptr

#include <vector>

namespace google {
namespace protobuf {
class MethodDescriptor;
class ServiceDescriptor;
}}  // namespace google::protobuf

// Adapt lua service table to grpc_cb_core::Service.
class Service : public grpc_cb_core::Service
{
public:
    using LuaRef = LuaIntf::LuaRef;
    using ServiceDescriptor = google::protobuf::ServiceDescriptor;

    Service(const ServiceDescriptor& desc, const LuaRef& luaService);
    ~Service();

public:
    const std::string& GetFullName() const override;
    size_t GetMethodCount() const override;
    bool IsMethodClientStreaming(size_t iMthdIdx) const override;
    const std::string& GetMethodName(size_t iMthdIdx) const override;
    void CallMethod(size_t iMthdIdx, grpc_byte_buffer* request,
        const grpc_cb_core::CallSptr& call_sptr) override;

private:
    void InitMethodNames();
    const google::protobuf::MethodDescriptor& GetMthdDesc(
        size_t iMthdIdx) const;

private:
    const ServiceDescriptor& m_desc;
    std::unique_ptr<const LuaRef> m_pLuaService;
    std::vector<std::string> m_vMethodNames;
};  // class Service

#endif  // IMPL_SERVICE_H
