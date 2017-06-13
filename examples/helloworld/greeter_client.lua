-- greeter_client.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/lua/?.lua;" .. package.path

local grpc = require("grpc_lua")

function main()
    grpc.import_proto_file("helloworld.proto")

    local ch = grpc.Channel("localhost:50051")
    local stub = grpc.ServiceStub(ch)
    stub:set_service_name("helloworld.Greeter")

    -- Blocking request.
    local request = { name = "world" }
    local response = stub:request("SayHello", request)
    print("Greeter received: " .. response.message)
    
    -- Async request.
    stub:async_request("SayHello", request, function(response)
        print("Async greeter received: " .. response.message)
    end)
    stub:blocking_run()
end  -- main()

main()
