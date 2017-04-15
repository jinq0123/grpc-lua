-- greeter_client.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/lua/?.lua;" .. package.path
package.cpath = "../../build/bin/Debug/?.dll;" .. package.cpath

local grpc = require("grpc_lua")

function main()
    grpc.test()
    print("main")
    local ch = grpc.Channel("localhost:50051")
    print(ch)
end  -- main()

main()
