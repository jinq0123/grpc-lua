--- Hello world greeter example client.
-- greeter_client.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/?.lua;" .. package.path

local grpc = require("grpc_lua.grpc_lua")

local function main()
    grpc.import_proto_file("helloworld.proto")

    local ch = grpc.Channel("localhost:50051")
    local stub = grpc.ServiceStub(ch)
    stub:set_service_name("helloworld.Greeter")

    -- Blocking request.
    local request = { name = "world" }
    local response = assert(stub:blocking_request("SayHello", request))
    print("Greeter received: " .. response.message)

    -- Async request.
    stub:async_request("SayHello", request, function(resp)
        print("Async greeter received: " .. resp.message)
    end)
    stub:blocking_run()
end  -- main()

main()
