--- Wraps C `ServerWriter` class.
-- @classmod grpc_lua.server.Writer

local Writer = {}

local pb = require("luapbintf")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New Writer.
-- Used by `Service`. No not call it directly.
-- @tparam userdata c_writer C `ServerWriter` object
-- @string msg_type message type, like "routeguide.Feature"
-- @treturn table Writer object
function Writer:new(c_writer, msg_type)
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
function Writer:write(message)
    assert("table" == type(message))
    local msg_str = pb.encode(self._msg_type, message)
    return self._c_writer:write(msg_str)
end  -- write()

--- Close writer.
function Writer:close()
    self._c_writer:close()  -- always close with OK status
end  -- close()

return Writer
