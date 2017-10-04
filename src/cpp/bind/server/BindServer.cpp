#include "BindServer.h"

#include "impl/Service.h"  // for Service

#include <grpc_cb_core/server.h>  // for Server
#include <LuaIntf/LuaIntf.h>
#include <google/protobuf/descriptor.h>  // for ServiceDescriptor
#include <string>

using namespace LuaIntf;

namespace {

void RegisterService(grpc_cb_core::Server* pServer,
    const LuaRef& svcDecsPtr, const LuaRef& luaService)
{
    assert(pServer);
    svcDecsPtr.checkType(LuaIntf::LuaTypeID::LIGHTUSERDATA);
    const auto* pDesc = static_cast<const google::protobuf::ServiceDescriptor*>(
        svcDecsPtr.toPtr());
    if (!pDesc) throw LuaException("ServiceDescriptor pointer is nullptr.");
    luaService.checkTable();
    pServer->RegisterService(std::make_shared<
        impl::Service>(*pDesc, luaService));
}  // RegisterService()

}  // namespace

namespace bind {

void BindServer(const LuaRef& mod)
{
    using namespace grpc_cb_core;
    LuaBinding(mod).beginClass<Server>("Server")
        .addConstructor(LUA_ARGS())
        // Returns bound port number on success, 0 on failure.
        .addFunction("add_listening_port",
            static_cast<int(Server::*)(const std::string&)>(
                &Server::AddListeningPort))
        .addFunction("register_service", &RegisterService)
        .addFunction("run", &Server::Run)
    .endClass();  // Server
}  // BindServer()

}  // namespace bind
