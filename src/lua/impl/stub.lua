local Stub = {}

function Stub:new(channel)
	local stub = {
		channel = channel,
	}
	setmetatable(stub, self)
	self.__index = self
	return stub
end  -- new()

-- service_name is full name like "helloworld.Greeter".
function Stub:set_service_name(service_name)
	self.service_name = service_name
end  -- set_service_name()

return Stub