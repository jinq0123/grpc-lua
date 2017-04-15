-- grpc_lua.lua

local M = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("protobuf")
local Stub = require("impl.stub")

function M.test()
	c.test()
end  -- test()

function M.register(buffer)
	pb.register(buffer)
end

function M.register_file(file_name)
	pb.register(file_name)
end

-- Input "host:port" like: "a.b.com:6666" or "1.2.3.4:6666".
function M.Channel(host_port)
	assert("string" == type(host_port))
	return c.Channel(host_port)
end  -- Channel()

function M.Stub(channel)
	return Stub:new(channel)
end  -- Stub()

return M
