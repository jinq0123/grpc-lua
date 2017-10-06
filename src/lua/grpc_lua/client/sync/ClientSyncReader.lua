--- Client sync reader class.
-- @classmod grpc_lua.client.sync.ClientSyncReader

local ClientSyncReader = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @tparam Channel c_channel
-- @string request_name, like "/helloworld.Greeter/SayHello"
-- @string request_str
-- @string response_type
-- @tparam number|nil timeout_sec nil means no timeout
-- @treturn table object
function ClientSyncReader:new(c_channel, request_name, request_str,
                              response_type, timeout_sec)
    assert("string" == type(request_str))
    assert("string" == type(response_type))
    local reader = {
        -- private:
        _c_reader = c.ClientSyncReader(c_channel,
            request_name, request_str, timeout_sec),  -- XXX set timeout later
        _response_type = response_type,
    }

    setmetatable(reader, self)
    self.__index = self
    return reader
end  -- new()

--- Read one message.
-- @treturn table|nil message table, nil means error or end
function ClientSyncReader:read_one()
    local msg = self._c_reader.read_one()
    if not msg then return nil end
    return pb.decode(self._response_type, msg)  -- return nil if decode error
end  -- read_one()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncReader
