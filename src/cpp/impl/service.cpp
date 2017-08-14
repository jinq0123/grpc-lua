#include "service.h"

#include <google/protobuf/descriptor.h>  // for ServiceDescriptor
#include <grpc/byte_buffer.h>  // for grpc_byte_buffer_reader_init()
#include <grpc/byte_buffer_reader.h>  // for grpc_byte_buffer_reader
#include <LuaIntf/LuaIntf.h>

#include <cassert>
#include <sstream>  // for ostringstream

Service::Service(const ServiceDescriptor& desc,
    const LuaRef& luaService)
    : m_desc(desc),
    m_luaService(luaService),
    m_luapbintf(LuaIntf::Lua::eval(
        luaService.state(), "require('luapbintf')"))
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

static LuaIntf::LuaString BufToStr(grpc_byte_buffer* request)
{
    grpc_byte_buffer_reader bbr;
    grpc_byte_buffer_reader_init(&bbr, request);
    grpc_slice req_slice = grpc_byte_buffer_reader_readall(&bbr);
    grpc_byte_buffer_reader_destroy(&bbr);
    return LuaIntf::LuaString(XXX);
}

void Service::CallMethod(size_t iMthdIdx, grpc_byte_buffer* request,
    const grpc_cb::CallSptr& call_sptr)
{
    assert(iMthdIdx < GetMethodCount());
    if (!request) return;

    const std::string& sReqType = GetMthdDesc(iMthdIdx)
        .input_type()->full_name();
    LuaIntf::LuaString strReq = BufToStr(request);
    LuaRef req = m_luapbintf.dispatchStatic("decode", sReqType, strReq);
    req.checkTable();
    // Like "SayHello", NOT Service::GetMethodName().
    const std::string& sMethodName = GetMthdDesc(iMthdIdx).name();
    m_luaService.dispatchStatic(sMethodName.c_str(), req, Replier(call_sptr));
    // XXX m_luaService.dispatchStatic(sMethodName.c_str(), request, replier);
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
    std::string sPackage = pFileDesc->package();
    if (!sPackage.empty()) sPackage.append(".");

    // Method name is like: "/helloworld.Greeter/SayHello"
    size_t nMthdCount = GetMethodCount();
    m_vMethodNames.reserve(nMthdCount);
    for (size_t i = 0; i < nMthdCount; ++i)
    {
        std::ostringstream oss;
        oss << "/" << sPackage;
        oss << m_desc.name() << "/" << GetMthdDesc(i).name();
        m_vMethodNames.emplace_back(oss.str());
    }
}

const google::protobuf::MethodDescriptor&
Service::GetMthdDesc(size_t iMthdIdx) const
{
    assert(m_desc.method(static_cast<int>(iMthdIdx)));
    return *m_desc.method(static_cast<int>(iMthdIdx));
}

