--- Route guide example client.
-- route_guide_client.lua

-- Current work dir: grpc-lua/examples/route_guide
package.path = "json.lua-0.1.0/?.lua;" .. package.path
package.path = "../../src/?.lua;" .. package.path

local grpc = require("grpc_lua.grpc_lua")
local db = require("db")

local function main()
    db.load()
    grpc.import_proto_file("route_guide.proto")

    local ch = grpc.channel("localhost:50051")
    local stub = grpc.service_stub(ch)
    stub:set_service_name("routeguide.RouteGuide")
    -- or local stub = grpc.service_stub("localhost:50051", "routeguide.RouteGuide")

    -- XXX
end  -- main()

main()
