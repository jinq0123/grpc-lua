--- Hello world greeter example client.
-- greeter_client.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/lua/?.lua;" .. package.path

local grpc = require("grpc_lua.grpc_lua")

local function main()
    grpc.import_proto_file("helloworld.proto")
    local stub = grpc.service_stub("localhost:50051", "helloworld.Greeter")

    -- Sync request.
    local request = { name = "world" }
    local response = assert(stub:sync_request("SayHello", request))
    print("Greeter received: " .. response.message)

    -- Async request.
    stub:async_request("SayHello", request, function(resp)
        print("Async greeter received: " .. resp.message)
        stub:shutdown()  -- to stop stub:run()
    end)
    stub:run()
end  -- main()

main()
