-- greeter_client.lua

package.cpath = package.cpath .. ";../../build/bin/Debug/?.dll"

local grpc = require("grpc_lua")

function main()
    grpc.test()
    print("main")
end  -- main()

main()
