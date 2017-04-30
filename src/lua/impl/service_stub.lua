local ServiceStub = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")

function ServiceStub:new(channel)
    local stub = {
        c_stub = c.ServiceStub(channel),
        channel = channel,
    }
    setmetatable(stub, self)
    self.__index = self
    return stub
end  -- new()

-- service_name is full name like "helloworld.Greeter".
function ServiceStub:set_service_name(service_name)
    self.service_name = service_name
end  -- set_service_name()

-- Set timeout seconds like 0.5s.
-- nil timeout means no timeout.
function ServiceStub:set_timeout_sec(timeout_sec)
    self.timeout_sec = timeout_sec
end  -- set_timeout_sec()

-- Like "/helloworld.Greeter/SayHello"
function ServiceStub:get_request_name(method_name)
    return "/" .. self.service_name .. "/" .. method_name
end  -- get_request_name()

-- e.g. request("SayHello", { name = "Jq" })
-- Blocking request. Return the response string. XXX or error?
function ServiceStub:request(method_name, request)
    assert("table" == type(request))
    local request_name = self:get_request_name(method_name)
    local request_str = self:encode_request(method_name, request)
    self.c_stub.request(request_name, request_str)
    return {}  -- XXX
end  -- request()

-- Async request.
function ServiceStub:async_request(method_name, request, on_response)
    assert("table" == type(request))
    assert(nil == on_response or "function" == type(on_response))
    -- XXX
end  -- async_request()

-- Encode request table to string.
function ServiceStub:encode_request(method_name, request)
    local request_type = pb.get_rpc_input_name(self.service_name, method_name)
    return pb.encode(request_type, request)
end  -- async_request()

return ServiceStub
