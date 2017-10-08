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

function M.GetFeature(request, replier)
    assert("table" == type(request))
    assert("table" == type(replier))
    local name = get_feature_name(request)
    local response = { name = name, location = request }
    replier:reply(response);
end  -- GetFeature()

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
            if not writer.write(f) then
                print("Failed to write.")
                break
            end  -- if not writer.write()
        end  -- if l
    end  -- for _, f
    writer.close()
end  -- ListFeatures()

return M
