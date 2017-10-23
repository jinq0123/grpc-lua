--- Client sync reader writer class.
-- @classmod grpc_lua.client.sync.ClientSyncReaderWriter

local ClientSyncReaderWriter = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @tparam Channel c_channel
-- @string request_name, like "/routeguide.RouteGuide/RouteChat"
-- @string request_type
-- @string response_type
-- @tparam number|nil timeout_sec nil means no timeout
-- @treturn table object
function ClientSyncReaderWriter:new(c_channel,
        request_name, request_type, response_type, timeout_sec)
    assert("userdata" == type(c_channel))
    assert("string" == type(request_name))
    assert("string" == type(request_type))
    assert("string" == type(response_type))
    local rdwr = {
        -- private:
        _c_rdwr = c.ClientSyncReaderWriter(c_channel, request_name, timeout_sec),
        _request_type = request_type,
        _response_type = response_type,
    }

    setmetatable(rdwr, self)
    self.__index = self
    return rdwr
end  -- new()

--- Read one message.
-- @treturn table|nil message table, nil means error or end
function ClientSyncReaderWriter:read_one()
    local msg = self._c_rdwr:read_one()
    if not msg then return nil end
    return pb.decode(self._response_type, msg)  -- return nil if decode error
end  -- read_one()

--- Write message.
-- @table message
-- @treturn boolean return false on error
function ClientSyncReaderWriter:write(message)
    assert("table" == type(message))
    local msg_str = pb.encode(self._request_type, message)
    self._c_rdwr:write(msg_str)
end  -- write()

--- Close writing.
-- Optional. Writing is auto closed in dtr().
function ClientSyncReaderWriter:close_writing()
    self._c_rdwr:close_writing()
end  -- close_writing()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncReaderWriter
