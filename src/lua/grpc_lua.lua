-- grpc_lua.lua

local M = {}

local c = require "grpc_lua.c"  -- from grpc_lua.so

function M.test()
	c.test()
end  -- test()

-- Input "host:port" like: "a.b.com:6666" or "1.2.3.4:6666".
function M.Channel(host_port)
	assert("string" == type(host_port))
	return c.Channel(host_port)
end  -- Channel()

local Stub = {}

function M.Stub(channel)
	local stub = {
		channel = channel,
	}
	setmetatable(stub, Stub)
	Stub.__index = Stub
	return stub
end  -- Stub()

return M
