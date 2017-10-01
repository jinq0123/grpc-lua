--- Wraps C `Replier` class.
-- @classmod grpc_lua.impl.Replier

local Replier = {}

local pb = require("luapbintf")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New Replier.
-- Used by `Service`. No not call it directly.
-- @tparam userdata c_replier C Replier object
-- @string response_type response type, like "helloworld.HelloResponse"
-- @treturn table Replier object
function Replier:new(c_replier, response_type)
    assert("userdata" == type(c_replier))
    assert("string" == type(response_type))

    local replier = {
        -- private:
        _c_replier = c_replier,
        _response_type = response_type,
    }

    setmetatable(replier, self)
    self.__index = self
    return replier
end  -- new()

--- Reply response.
-- @tab response response
function Replier:reply(response)
    assert("table" == type(response))
    local resp_str = pb.encode(self._response_type, response)
    self._c_replier:reply(resp_str)
end  -- reply()

return Replier
