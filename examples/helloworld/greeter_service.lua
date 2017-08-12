-- greeter_service.lua

local M = {}

local grpc = require("grpc_lua.grpc_lua")
grpc.import_proto_file("helloworld.proto")

function M.SayHello(request, replier)
	assert("table" == type(request))
	assert("table" == type(replier))
	-- replier can be copied and reply() later after return.
	response = { message = "Hello "..request.name }
	replier.reply(response);
end  -- SayHello()

return M
