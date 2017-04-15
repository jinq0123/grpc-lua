-- greeter_client.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/lua/?.lua;" .. package.path
package.cpath = "../../build/bin/Debug/?.dll;" .. package.cpath

local grpc = require("grpc_lua")

function main()
	print("main")
	grpc.test()

	grpc.register_file("descriptors.pb")

	local ch = grpc.Channel("localhost:50051")
	print(ch)
	local stub = grpc.Stub(ch)
	stub:set_service_name("helloworld.Greeter")

	-- Blocking request.
	local request = { name = "world" }
	local response = stub:request("SayHello", request)
	print("Greeter received: " .. response.message)
	
	-- Async request.
	stub:async_request("SayHello", request, function(response)
		print("Async greeter received: " .. response.message)
	end)
	-- Todo: Wait for response...
end  -- main()

main()
