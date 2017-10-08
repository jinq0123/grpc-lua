#include "Service.h"

#include <google/protobuf/descriptor.h>  // for ServiceDescriptor
#include <grpc/byte_buffer.h>  // for grpc_byte_buffer_reader_init()
#include <grpc/byte_buffer_reader.h>  // for grpc_byte_buffer_reader
#include <grpc_cb_core/server/server_replier.h>  // for ServerReplier
#include <LuaIntf/LuaIntf.h>

#include <cassert>
#include <sstream>  // for ostringstream

namespace impl {

Service::Service(const ServiceDescriptor& desc,
    const LuaRef& luaService)
    : m_desc(desc),
    m_pLuaService(new LuaRef(luaService))
{
    luaService.checkTable();

    InitMethodNames();
}

Service::~Service()
{
}

const std::string& Service::GetFullName() const
{
    return m_desc.full_name();
}

size_t Service::GetMethodCount() const
{
    return m_desc.method_count();
}

bool Service::IsMethodClientStreaming(size_t iMthdIdx) const
{
    assert(iMthdIdx < GetMethodCount());  // XXX is assert enough?
    const ::google::protobuf::MethodDescriptor*
        method_desc = m_desc.method(static_cast<int>(iMthdIdx));
    assert(method_desc);
    return method_desc->client_streaming();
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
    const grpc_cb_core::CallSptr& call_sptr)
{
    assert(iMthdIdx < GetMethodCount());
    if (!request) return;

    grpc_slice req_slice = BufToSlice(request);
    {
        LuaIntf::LuaString strReq(reinterpret_cast<const char*>(
            GRPC_SLICE_START_PTR(req_slice)),
            GRPC_SLICE_LENGTH(req_slice));
        CallMethod(iMthdIdx, strReq, call_sptr);
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

void Service::CallMethod(size_t iMthdIdx, LuaIntf::LuaString& strReq,
    const grpc_cb_core::CallSptr& call_sptr)
{
    assert(iMthdIdx < GetMethodCount());

    const google::protobuf::MethodDescriptor& mthd = GetMthdDesc(iMthdIdx);
    const std::string& sReqType = mthd.input_type()->full_name();
    const std::string& sRespType = mthd.output_type()->full_name();
    // Like "SayHello", NOT Service::GetMethodName().
    const std::string& sMethodName = mthd.name();

    assert(m_pLuaService->isTable());
    if (mthd.client_streaming())
    {
        if (mthd.server_streaming())
        {
        }
        else
        {
        }
    }
    else if (mthd.server_streaming())
    {
        // XXX
        m_pLuaService->dispatch("call_server_side_streaming_method"
    }
    else
    {
        using Replier = grpc_cb_core::ServerReplier;
        m_pLuaService->dispatch("call_simple_method", sMethodName,
            sReqType, strReq, Replier(call_sptr), sRespType);
    }
}

}  // namespace impl
