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

static grpc_slice BufToSlice(grpc_byte_buffer* buf)
{
    grpc_byte_buffer_reader bbr;
    grpc_byte_buffer_reader_init(&bbr, buf);
    grpc_slice slice = grpc_byte_buffer_reader_readall(&bbr);
    grpc_byte_buffer_reader_destroy(&bbr);
    return slice;
}

void Service::CallMethod(size_t iMthdIdx, grpc_byte_buffer* request,
    const grpc_cb::CallSptr& call_sptr)
{
    assert(iMthdIdx < GetMethodCount());
    if (!request) return;

    const std::string& sReqType = GetMthdDesc(iMthdIdx)
        .input_type()->full_name();
    // Like "SayHello", NOT Service::GetMethodName().
    const std::string& sMethodName = GetMthdDesc(iMthdIdx).name();
    grpc_slice req_slice = BufToSlice(request);
    {
        LuaIntf::LuaString strReq(reinterpret_cast<const char*>(
            GRPC_SLICE_START_PTR(req_slice)),
            GRPC_SLICE_LENGTH(req_slice));
        m_luaService.dispatch(sMethodName.c_str(), sReqType, strReq,
            Replier(call_sptr));
    }
    grpc_slice_unref(req_slice);
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

