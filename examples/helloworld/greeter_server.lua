-- greeter_server.lua

-- Current work dir: grpc-lua/examples/helloworld
package.path = "../../src/lua/?.lua;" .. package.path

local grpc = require("grpc_lua")

function main()
    grpc.import_proto_file("helloworld.proto")

end  -- main()

main()
