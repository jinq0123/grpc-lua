--- Route guide example client.
-- route_guide_client.lua

require("init_package_path")
local grpc = require("grpc_lua.grpc_lua")
local db = require("db")

local stub  -- ServiceStub

local function blocking_get_feature()
    print("Blocking get feature...")
end  -- blocking_get_feature()

local function blocking_list_features()
    print("Blocking list features...")
end  -- blocking_list_features()

local function blocking_record_route()
    print("Blocking record route...")
end  -- blocking_record_route()

local function blocking_route_chat()
    print("Blocking route chat...")
end  -- blocking_route_chat()

local function get_feature_async()
    print("Get feature async...")
end  -- get_feature_async()

local function list_features_async()
    print("List features async...")
end  -- list_features_async()

local function record_route_async()
    print("Record_route_async...")
end  -- record_route_async()

local function route_chat_async()
    print("Route chat async...")
end  -- route_chat_async()

local function main()
    db.load()
    grpc.import_proto_file("route_guide.proto")
    stub = grpc.service_stub("localhost:50051", "routeguide.RouteGuide")

    blocking_get_feature()
    blocking_list_features()
    blocking_record_route()
    blocking_route_chat()

    get_feature_async()
    list_features_async()
    record_route_async()
    route_chat_async()
end  -- main()

main()
