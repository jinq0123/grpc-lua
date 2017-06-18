-- greeter_server.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/?.lua;" .. package.path

local grpc = require("grpc_lua.grpc_lua")

function main()
    local svr = grpc.Server()
    svr:add_listening_port("0.0.0.0:50051")
    -- Service implementation is a table.
    svr:register_service(require("greeter_service"))
    svr:blocking_run()
end  -- main()

main()
