--- Route guide example client.
-- route_guide_client.lua

require("init_package_path")
local grpc = require("grpc_lua.grpc_lua")
local db = require("db")
local inspect = require("inspect")

local SVC = "routeguide.RouteGuide"
local c_channel  -- C `Channel` object
local kCoordFactor = 10000000.0;

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

local function route_note(name, latitude, longitude)
    return { name = name, location = point(latitude, longitude) }
end  -- route_note()

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
    -- request_read, request_write, request_rdwr ? XXX
    while true do
        local ok, feature = sync_reader.read_one()
        if not ok then break end
        print("Found feature: "..inspect(feature))
    end  -- while
    -- sync_reader.recv_status() XXX
    print("ListFeatures rpc succeeded.")
    -- print("ListFeatures rpc failed.")
end  -- sync_list_features()

local function sync_record_route()
    print("Sync record route...")
    local stub = new_stub()
    local sync_writer = stub.sync_request_write("RecordRoute")
    for i = 1, 10 do
        local feature = db.get_rand_feature()
        local loc = assert(feature.location)
        print(string.format("Visiting point (%f, %f)",
            loc.latitude()/kCoordFactor, loc.longitude()/kCoordFactor))
        if not sync_writer.write(loc) then
            print("Failed to sync write.")
            break
        end  -- if
    end  -- for

    -- Recv status and reponse. XXX
    local status_code, status_str, stats = sync_writer.close()  -- Todo: timeout
    if 0 ~= status_code then
        print(string.format("RecordRoute rpc failed: (%d)%s.", status_code, status_str)
        return
    end

    print(string.format(
[[[Finished trip with %d points
Passed %d features
Traveled %d meters
It took %d seconds]]],
        stats.point_count, stats.feature_count,
        stats.distance, stats.elapsed_time))
end  -- sync_record_route()

local function sync_route_chat()
    print("Sync route chat...")
    local stub = new_stub()
    local sync_rdwr = stub.sync_request_rdwr("RouteChat")  -- XXX

    local notes = { route_note("First message", 0, 0),
                    route_note("Second message", 0, 1),
                    route_note("Third message", 1, 0),
                    route_note("Fourth message", 0, 0) }
    for _, note in ipairs(notes) do
        print("Sending message: " .. inspect(note))
        sync_rdwr.write(note)  -- XXX

        -- write one then read one
        local ok, server_note = sync_rdwr.read_one()  -- XXX
        if ok then
            print("Got message: "..inspect(server_note))
        end
    }
    sync_rdwr.close_writing()  -- XXX

    -- read remaining
    while true do
        local ok, server_note = sync_rdwr.read_one()
        if not ok then break end
        print("Got message: "..inspect(server_note))
    end  -- while
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
