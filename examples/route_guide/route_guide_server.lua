--- Route guide example server.
-- route_guide_server.lua

require("init_package_path")
local grpc = require("grpc_lua.grpc_lua")
local db = require("db")

local function main()
    db.load()
    grpc.import_proto_file("route_guide.proto")

    -- XXX
end  -- main()

main()
