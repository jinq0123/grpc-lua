--- Route guide example server side service.
-- @module route_guide_service

local M = {}

local grpc = require("grpc_lua.grpc_lua")
grpc.import_proto_file("route_guide.proto")

local db = require("db")
db.load()

local function get_feature_name(point)
    assert("table" == type(point))
    for _, f in ipairs(db.features)
        local l = f.location
        if l.latitude == point.latitude and
                l.longitude == point.longitude then
            return f.name
        end
    end
    return ""
end

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Simple RPC method.
-- @tab request
-- @tparam Replier replier
function M.GetFeature(request, replier)
    assert("table" == type(request))
    assert("table" == type(replier))
    local name = get_feature_name(request)
    local response = { name = name, location = request }
    replier:reply(response);
end  -- GetFeature()

--- Server-to-client streaming method.
-- @table rectangle
-- @tparam Writer writer
function M.ListFeatures(rectangle, writer)
    assert("table" == type(rectangle))
    assert("table" == type(writer))
    local lo = assert(rectangle.lo)
    local hi = assert(rectangle.hi)
    local left = math.min(lo.longitude, hi.longitude)
    local right = math.max(lo.longitude, hi.longitude)
    local top = math.max(lo.latitude, hi.latitude)
    local bottom = math.min(lo.latitude, hi.latitude);

    -- Todo: write in thread...

    for _, f in ipairs(db.features) do
        local l = f.location
        if l.longitude >= left and
           l.longitude <= right and
           l.latitude >= bottom and
           l.latitude <= top then
            if not writer:write(f) then
                print("Failed to write.")
                break
            end  -- if not writer:write()
        end  -- if l
    end  -- for _, f
    writer:close()
end  -- ListFeatures()

--- Client-to-server streaming method.
-- @tab replier `Replier` object
-- @treturn table server reader object
function M.RecordRoute(replier)
    assert("table" == type(replier))
    return require("server_reader.RecordRouteReader"):new(replier, db)
end  -- RecordRoute()

--- Bi-directional streaming method.
-- @table writer `Writer` object
-- @treturn table server reader object
function M.RouteChat(writer)
    assert("table" == type(writer))
    return require("server_reader.RouteChatReader"):new(writer, db)
end  -- RouteChat()

return M
