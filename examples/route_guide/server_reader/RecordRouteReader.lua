--- Server reader class for RecordRoute method.
-- @classmod server_reader.RecordRouteReader

local Reader = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New Reader.
-- @tparam Replier replier Replier object
-- @treturn table Reader object
function Reader:new(replier, db)
    assert("table" == type(replier))

    local reader = {
        -- private:
        _replier = replier,
        _db = db,

        _summary = {
            point_count = 0,
            feature_count = 0,
            distance = 0.0,
            elapsed_time = 0,  -- in seconds
        },
        _previous = nil,  -- Point
        _start_time = os.time(),
    }

    setmetatable(reader, self)
    self.__index = self
    return reader
end  -- new()

local function get_distance(p1, p2)
    local kCoordFactor = 10000000.0
    local lat_1 = p1.latitude  / kCoordFactor
    local lat_2 = p2.latitude  / kCoordFactor
    local lon_1 = p1.longitude / kCoordFactor
    local lon_2 = p2.longitude / kCoordFactor
    local lat_rad_1 = math.rad(lat_1)
    local lat_rad_2 = math.rad(lat_2)
    local delta_lat_rad = math.rad(lat_2-lat_1)
    local delta_lon_rad = math.rad(lon_2-lon_1)
  
    local a = math.sin(delta_lat_rad/2) ^ 2
               + math.cos(lat_rad_1) * math.cos(lat_rad_2) *
                  math.sin(delta_lon_rad/2) ^ 2
    local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    local R = 6371000  -- metres
    return R * c
end  -- get_distance()

function Reader:on_msg(msg)
    assert("table" == type(msg))
    self._summary.point_count = self._summary.point_count + 1
    if self:_get_feature_name(msg) then
        self._summary.feature_count = self._summary.feature_count + 1
    end
    if self._previous then
        self._summary.distance = self._summary.distance
            + get_distance(self._previous, msg);
    end
    self._previous = msg;
end

function Reader:on_error(error_str, status_code)
    assert("string" == type(error_str))
    assert("number" == type(status_code))
    print(string.format("RecordRoute error: (%d)%s", status_code, error_str))
    self._replier.reply_error(error_str, status_code)
end

function Reader:on_end()
    print("RecordRoute reader end.")
    self._summary.elapsed_time = os.time() - self._start_time
    self._replier.Reply(self._summary);
end

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

--- Get feature name.
-- @table point
-- @treturn string|nil
function Reader:_get_feature_name(point)
    assert("table" == type(point))
    for _, f in ipairs(self._db.features) do
        local l = f.location
        if l.latitude == point.latitude and
                l.longitude == point.longitude then
            return f.name
        end  -- if
    end  -- for
    return nil
end

return Reader
