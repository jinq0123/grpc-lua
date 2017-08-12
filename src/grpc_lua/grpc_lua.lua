--- Wraps grpc_lua C module.
-- Provides the interface to grpc.
-- Calls luapbintf to encode and decode protobuf messages.
-- @module grpc_lua.grpc_lua

local M = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")
local ServiceStub = require("grpc_lua.impl.service_stub")

function M.test()
    c.test()
end  -- test()

-- @section luapbintf

--- Add proto path as `protoc --proto_path=PATH`.
-- Specify the directory in which to search for imports.
-- May add multiple times to set multiple proto paths,
-- and the directories will be searched in order.
-- If not given, the current working directory is used.
-- Directly calls `luaphintf.add_proto_path()`
-- @string proto_path the directory name
function M.add_proto_path(proto_path)
    pb.add_proto_path(proto_path)
end  -- add_proto_path()

--- Map a path on disk to a location in the SourceTree.
-- See Protobuf `DiskSourceTree::MapPath()`.
-- @string virtual_path virtual path
-- @string disk_path disk path
function M.map_path(virtual_path, disk_path)
    pb.map_path(virtual_path, disk_path)
end  -- map_path()

--- Import the given file to a FileDescriptor.
-- Dependencies are imported automatically.
-- @string file_name *.proto file name, must be relative to proto path.
-- @usage import_proto_file("foo.proto")
function M.import_proto_file(file_name)
    pb.import_proto_file(file_name)
end

-- @section grpc

--- Create a channel.
-- @string host_port input "host:port" like: "a.b.com:6666" or "1.2.3.4:6666"
-- @treturn Channel channel object
function M.Channel(host_port)
    assert("string" == type(host_port))
    return c.Channel(host_port)
end  -- Channel()

--- Create service stub.
-- @Channel channel
-- @treturn ServiceStub service stub object
function M.ServiceStub(channel)
    return ServiceStub:new(channel)
end  -- Stub()

--- Create a server.
-- @treturn Server server object
function M.Server()
    return c.Server()
end  -- Server()

return M
