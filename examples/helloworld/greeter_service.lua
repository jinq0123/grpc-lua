-- greeter_service.lua

local M = {}

local grpc = require("grpc_lua")
grpc.import_proto_file("helloworld.proto")

return M
