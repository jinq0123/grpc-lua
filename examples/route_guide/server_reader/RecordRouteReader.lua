--- Server reader class for RecordRoute method.
-- @classmod server_reader.RecordRouteReader

local Reader = {}

local pb = require("luapbintf")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New Reader.
-- @string msg_type
-- @string msg_type message type, like "routeguide.Feature"
-- @treturn table Reader object
function Reader:new(msg_type, replier)
    assert("userdata" == type(c_writer))
    assert("string" == type(msg_type))

    local writer = {
        -- private:
        _c_writer = c_writer,
        _msg_type = msg_type,
    }

    setmetatable(writer, self)
    self.__index = self
    return writer
end  -- new()

--- Write message.
-- @tab message
-- @treturn boolean return false if error
function Reader:write(message)
    assert("table" == type(message))
    local msg_str = pb.encode(self._msg_type, message)
    self._c_writer:writer(msg_str)
end  -- write()

--- Close writer.
function Reader:close()
    self._c_writer:close()
end  -- close()

return Reader
