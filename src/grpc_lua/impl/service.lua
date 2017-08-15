--- Service.
-- Wraps service implementation module.
-- @module grpc_lua.impl.service

local Service = {}

local pb = require("luapbintf")

--- Service constructor.
-- @tab svc_impl service implementation
-- @treturn Service
function Service:new(svc_impl)
    assert("table" == type(svc_impl))
    local svc = {
        impl = svc_impl,
    }
    setmetatable(svc, self)
    self.__index = self
    return svc
end  -- new()

--- Call service method.
-- @string method_name method name, like: "SayHello"
-- @string request_type request type, like: "helloworld.HelloRequest"
-- @string request_str request message string
-- @tparam userdata replier replier object
function Service:call_method(method_name, request_type, request_str, replier)
    local method = assert(self.impl[method_name], "No such method: "..method_name)
    local request = assert(pb.decode(request_type, request_str))
    method(request, replier)
end

return Service
