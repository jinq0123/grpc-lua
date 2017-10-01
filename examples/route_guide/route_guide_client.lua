--- Route guide example client.
-- route_guide_client.lua

-- Current work dir: grpc-lua/examples/route_guide
package.path = "json.lua-0.1.0/?.lua;" .. package.path
package.path = "../../src/?.lua;" .. package.path

local grpc = require("grpc_lua.grpc_lua")
local db = require("db")

local function main()
    db.load()
end  -- main()

main()
