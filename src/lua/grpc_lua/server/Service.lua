--- Service.
-- Wraps service implementation module.
-- @classmod grpc_lua.server.Service

local Service = {}

local pb = require("luapbintf")
local Replier = require("grpc_lua.server.Replier")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Service constructor.
-- Used by `Server`. Do not call it directly.
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
-- @tparam userdata c_replier C replier object
-- @string response_type response type, like: "helloworld.HelloResponse"
function Service:call_method(method_name, request_type, request_str,
                                c_replier, response_type)
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    assert("string" == type(request_str))
    assert("userdata" == type(c_replier))
    assert("string" == type(response_type))

    local method = assert(self.impl[method_name], "No such method: "..method_name)
    local request = assert(pb.decode(request_type, request_str))
    local replier = Replier:new(c_replier, response_type)
    method(request, replier)
end

return Service
