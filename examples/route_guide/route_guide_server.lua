--- Route guide example server.
-- route_guide_server.lua

-- Current work dir: grpc-lua/examples/route_guide
package.path = "json.lua-0.1.0/?.lua;" .. package.path
package.path = "../../src/?.lua;" .. package.path

local grpc = require("grpc_lua.grpc_lua")
local db = require("db")

local function main()
    db.load()
    grpc.import_proto_file("route_guide.proto")

    -- XXX
end  -- main()

main()
