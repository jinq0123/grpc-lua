local ServiceStub = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so

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

-- Blocking request. Return the response.
function ServiceStub:request(method_name, request)
	self.c_stub.request()
	return {}  -- XXX
end  -- request()

-- Async request.
function ServiceStub:async_request(method_name, request, on_response)
	assert(nil == on_response or "function" == type(on_response))
	-- XXX
end  -- async_request()

return ServiceStub