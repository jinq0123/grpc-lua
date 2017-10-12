--- Server reader class for RecordRoute method.
-- @classmod server_reader.RecordRouteReader

local Reader = {}

local pb = require("luapbintf")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New Reader.
-- @tparam Replier replier Replier object
-- @treturn table Reader object
function Reader:new(replier)
    assert("table" == type(replier))

    local reader = {
        -- private:
        _replier = replier,
    }

    setmetatable(reader, self)
    self.__index = self
    return reader
end  -- new()

function Reader:on_msg(msg)
    assert("table" == type(msg))
    -- XXX
end

function Reader:on_error(error_str, status_code)
    assert("string" == type(error_str))
    assert("number" == type(status_code))
    -- XXX
end

function Reader:on_end()
    -- XXX
end

return Reader
