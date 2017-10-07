--- Route guide example server.
-- route_guide_server.lua

require("init_package_path")
local grpc = require("grpc_lua.grpc_lua")

local function main()
    local svr = grpc.server()
    svr:add_listening_port("0.0.0.0:50051")
    -- Service implementation is a table.
    local service = require("route_guide_service")
    svr:register_service("routeguide.RouteGuide", service)
    svr:run()
end  -- main()

main()
