-- greeter_service.lua

local M = {}

local grpc = require("grpc_lua.grpc_lua")
grpc.import_proto_file("helloworld.proto")

function M.SayHello(request, replier)
    assert("table" == type(request))
    assert("userdata" == type(replier))
    print("Got hello from "..request.name)
    -- replier can be copied and reply() later after return.
    local response = { message = "Hello "..request.name }
    replier.reply(response);
end  -- SayHello()

return M
