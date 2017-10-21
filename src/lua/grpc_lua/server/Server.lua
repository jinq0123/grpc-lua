--- Wraps C `Server` class.
-- @classmod grpc_lua.server.Server

local Server = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")
local Service = require("grpc_lua.server.Service")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New server.
-- Do not call it directly, use `grpc_lua:Server()` instead.
-- @treturn table `Server` object
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
-- @string service_name full service name like "helloworld.Greeting"
-- @tab service service that has methods
-- @usage svr:register_service("helloworld.Greeting", service)
function Server:register_service(service_name, service)
    assert("string" == type(service_name))
    assert("table" == type(service))
    local desc = pb.get_service_descriptor(service_name)
    assert("table" == type(desc))  -- a service descriptor proto message

    -- service impl table is wrapped by lua Service,
    --  which is then wrapped by C Service, and then is registered in server.
    self.c_svr:register_service(Service:new(service_name, desc, service))
end  -- register_service()

--- Blocking run the server.
function Server:run()
    self.c_svr:run()
end

return Server
