#ifndef SERVER_IMPL_SERVICE_H
#define SERVER_IMPL_SERVICE_H

#include "common/LuaRefFwd.h"  // forward LuaRef

#include <grpc_cb_core/server/service.h>  // for Service and CallSptr

#include <vector>

namespace LuaIntf {
struct LuaString;
}  // namespace LuaIntf

namespace impl {

// Adapt lua service table to grpc_cb_core::Service.
class Service : public grpc_cb_core::Service
{
public:
    using LuaRef = LuaIntf::LuaRef;
    explicit Service(const LuaRef& luaService);
    ~Service();

public:
    using string = std::string;
    const string& GetFullName() const override;
    size_t GetMethodCount() const override;
    bool IsMethodClientStreaming(size_t iMthdIdx) const override;
    const string& GetMethodName(size_t iMthdIdx) const override;
    void CallMethod(size_t iMthdIdx, grpc_byte_buffer* pReqBuf,
        const grpc_cb_core::CallSptr& pCall) override;

private:
    void InitMethods();
    void InitMethod(size_t iMthdIdx, const LuaRef& luaMethod);
    void CallClientStreamingMethod(size_t iMthdIdx,
        const grpc_cb_core::CallSptr& pCall);
    void CallNonClientStreamingMethod(size_t iMthdIdx,
        LuaIntf::LuaString& strReq, const grpc_cb_core::CallSptr& pCall);

private:
    std::unique_ptr<const LuaRef> m_pLuaService;
    string m_sFullName;  // like "helloworld.Greeter"

    struct MethodInfo
    {
        // string sName;  like "SayHello"
        // Method request name is like: "/helloworld.Greeter/SayHello"
        string sRequestName;
        bool IsClientStreaming;
        bool IsServerStreaming;
    };  // struct MethodInfo
    std::vector<MethodInfo> m_vMethods;
};  // class Service

}  // namespace impl
#endif  // SERVER_IMPL_SERVICE_H
