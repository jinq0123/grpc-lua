--- Route guide example client.
-- route_guide_client.lua

require("init_package_path")
local grpc = require("grpc_lua.grpc_lua")
local db = require("db")

local SVC = "routeguide.RouteGuide"
local c_channel  -- C `Channel` object

-- New stub on the same channel.
local function new_stub()
    return grcp.service_stub(c_channel, SVC)
end

local function point(latitude, longitude)
    return { latitude = latitude, longitude = longitude }
end  -- point()

local function rectangle(lo_latitude, lo_longitude,
                         hi_latitude, hi_longitude)
    return { lo = point(lo_latitude, lo_longitude),
             hi = point(hi_latitude, hi_longitude) }
end  -- rectangle()

local function sync_get_feature()
    print("Sync get feature...")
    local stub = new_stub()
    local feature
    feature = stub.sync_request("GetFeature", point(409146138, -746188906))
    print("Get feature: "..inspect(feature))
    feature = stub.sync_request("GetFeature", point(0, 0)
    print("Get feature: "..inspect(feature))
end  -- sync_get_feature()

local function sync_list_features()
    print("Sync list features...")
    local stub = new_stub()
    local rect = rectangle(400000000, -750000000, 420000000, -730000000)
    print("Looking for features between 40, -75 and 42, -73")
    local sync_reader = stub:sync_request_read("ListFeatures", rect)
    -- request_read, request_write, request_rw ? XXX
    while true do
        local ok, feature = sync_reader.read_one()  -- XXX
        if not ok then break end
        print("Found feature: "..inspect(feature))
    end  -- while
    -- sync_reader.recv_status()
    print("ListFeatures rpc succeeded.")
    -- print("ListFeatures rpc failed.")
end  -- sync_list_features()

local function sync_record_route()
    print("Sync record route...")
    local stub = new_stub()
end  -- sync_record_route()

local function sync_route_chat()
    print("Sync route chat...")
    local stub = new_stub()
end  -- sync_route_chat()

local function get_feature_async()
    print("Get feature async...")
    local stub = new_stub()
    stub.async_request("GetFeature", point())  -- ignore response
    stub.async_request("GetFeature", point(409146138, -746188906),
        function(resp)
            print("Get feature: "..inspect(resp))
            stub.shutdown()  -- to return
        end)
    stub.run()  -- run async requests until stub.shutdown()
end  -- get_feature_async()

local function list_features_async()
    print("List features async...")
    local stub = new_stub()
end  -- list_features_async()

local function record_route_async()
    print("Record_route_async...")
    local stub = new_stub()
end  -- record_route_async()

local function route_chat_async()
    print("Route chat async...")
    local stub = new_stub()
end  -- route_chat_async()

local function main()
    db.load()
    grpc.import_proto_file("route_guide.proto")
    c_channel = grpc.channel("localhost:50051")

    sync_get_feature()
    sync_list_features()
    sync_record_route()
    sync_route_chat()

    get_feature_async()
    list_features_async()
    record_route_async()
    route_chat_async()
end  -- main()

main()
