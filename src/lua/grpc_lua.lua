-- grpc_lua.lua

local M = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")
local ServiceStub = require("impl.service_stub")

function M.test()
    c.test()
end  -- test()

function M.add_proto_path(proto_path)
    pb.add_proto_path(proto_path)
end  -- add_proto_path()

function M.map_path(virtual_path, disk_path)
    pb.map_path(virtual_path, disk_path)
end  -- map_path()

-- file_name must be relative to proto path.
-- e.g. import_proto_file("foo.proto")
function M.import_proto_file(file_name)
    pb.import_proto_file(file_name)
end

-- Input "host:port" like: "a.b.com:6666" or "1.2.3.4:6666".
function M.Channel(host_port)
    assert("string" == type(host_port))
    return c.Channel(host_port)
end  -- Channel()

function M.ServiceStub(channel)
    return ServiceStub:new(channel)
end  -- Stub()

return M
