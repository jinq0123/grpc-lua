--- Wraps C module `Server`.
-- @classmod grpc_lua.impl.Server

local Server = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")
local Service = require("grpc_lua.impl.Service")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New server.
-- @treturn table server object
function Server:new()
    local svr = {
        c_svr = c.Server(),
    }
    setmetatable(svr, self)
    self.__index = self
    return svr
end  -- new()

--- Add listening host port pair.
-- @string host_port host and port string, like: "0.0.0.0:50051"
-- @treturn int bound port number on success, 0 on failure.
-- @usage svr:add_listening_port("0.0.0.0:50051")
function Server:add_listening_port(host_port)
    assert("string" == type(host_port))
    self.c_svr:add_listening_port(host_port)
end

--- Register a service.
-- Service implementation is a table.
-- @string full_svc_name full service name
-- @tab service service that has methods
-- @usage svr:register_service("helloworld.Greeting", service)
function Server:register_service(full_service_name, service)
    assert("string" == type(full_service_name))
    assert("table" == type(service))
    local desc = pb.get_service_descriptor(full_service_name)
    assert("userdata" == type(desc))  -- a pointer to service descriptor
    self.c_svr:register_service(desc, Service:new(service))
end  -- register_service()

--- Blocking run the server.
function Server:blocking_run()
    self.c_svr:blocking_run()
end

return Server
