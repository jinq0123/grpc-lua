--- Hello world greeter example server.
-- greeter_server.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/?.lua;" .. package.path

local grpc = require("grpc_lua.grpc_lua")

local function main()
    local svr = grpc.Server()
    svr:add_listening_port("0.0.0.0:50051")
    -- Service implementation is a table.
    local service = require("greeter_service")
    svr:register_service("helloworld.Greeter", service)
    svr:blocking_run()
end  -- main()

main()
