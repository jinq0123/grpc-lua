--- Server reader class for RouteChat method.
-- @classmod server_reader.RouteChatReader

local Reader = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New Reader.
-- @tparam Writer writer `Writer` object
-- @treturn table Reader object
function Reader:new(writer, db)
    assert("table" == type(writer))

    local reader = {
        -- private:
        _writer = writer,
        _db = db,

        _summary = {
            point_count = 0,
            feature_count = 0,
            distance = 0.0,
            elapsed_time = 0,  -- in seconds
        }
        _previous = nil,  -- Point
        _start_time = os.time(),
    }

    setmetatable(reader, self)
    self.__index = self
    return reader
end  -- new()

function Reader:on_msg(msg)
    assert("table" == type(msg))
    local l0 = msg.location
    for _, n in ipairs(self._received_notes) do
        local l = n.location
        if l.latitude == l0.latitude and
                l.longitude == l0.longitude then
            self._writer.write(n)
        end  -- if
    end  -- for
    table.insert(self._received_notes, msg)
end

function Reader:on_error(error_str, status_code)
    assert("string" == type(error_str))
    assert("number" == type(status_code))
    print(string.format("RouteChat error: (%d)%s", status_code, error_str)
end

function Reader:on_end()
    print("RouteChat reader end.")
    self._writer.write({});
end

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return Reader
