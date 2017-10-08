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
-- @string response_type response type, like "routeguide.Feature"
-- @treturn table Writer object
function Writer:new(c_writer, response_type)
    assert("userdata" == type(c_writer))
    assert("string" == type(response_type))

    local writer = {
        -- private:
        _c_writer = c_writer,
        _response_type = response_type,
    }

    setmetatable(writer, self)
    self.__index = self
    return writer
end  -- new()

--- Reply response.
-- @tab response response
--function Replier:reply(response)
--    assert("table" == type(response))
--    local resp_str = pb.encode(self._response_type, response)
--    self._c_replier:reply(resp_str)
--end  -- reply()

return Writer
