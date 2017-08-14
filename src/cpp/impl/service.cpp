#include "service.h"

#include <google/protobuf/descriptor.h>  // for ServiceDescriptor
#include <LuaIntf/LuaIntf.h>

#include <cassert>
#include <sstream>  // for ostringstream

Service::Service(const ServiceDescriptor& desc,
    const LuaRef& luaService)
    : m_desc(desc),
    m_luaService(luaService)
{
    luaService.checkTable();

    InitMethodNames();
}

Service::~Service()
{
}

// Return method name, like: "/helloworld.Greeter/SayHello"
// Not full_name: "helloworld.Greeter.SayHello"
const std::string& Service::GetMethodName(size_t iMthdIdx) const
{
    assert(iMthdIdx < GetMethodCount());
    assert(iMthdIdx < m_vMethodNames.size());
    return m_vMethodNames[iMthdIdx];
}

void Service::CallMethod(size_t iMthdIdx, grpc_byte_buffer* request,
    const grpc_cb::CallSptr& call_sptr)
{
    assert(iMthdIdx < GetMethodCount());
    if (!request) return;
    // Like "SayHello", NOT Service::GetMethodName().
    const std::string& sMethodName = m_desc.method(iMthdIdx)->name();
    printf("Call Method: %s\n", sMethodName.c_str());
    
      //SayHello(*request_buffer,
      //    SayHello_Replier(call_sptr));
    // XXX
}

void Service::InitMethodNames()
{
    using namespace google::protobuf;
    const FileDescriptor* pFileDesc = m_desc.file();
    assert(pFileDesc);
    string sPackage = pFileDesc->package();
    if (!sPackage.empty()) sPackage.append(".");

    // Method name is like: "/helloworld.Greeter/SayHello"
    size_t nMthdCount = GetMethodCount();
    m_vMethodNames.reserve(nMthdCount);
    for (size_t i = 0; i < nMthdCount; ++i)
    {
        std::ostringstream oss;
        oss << "/" << sPackage;
        const MethodDescriptor* pMthdDesc = m_desc.method(i);
        assert(pMthdDesc);
        oss << m_desc.name() << "/" << pMthdDesc->name();
        m_vMethodNames.emplace_back(oss.str());
    }
}
