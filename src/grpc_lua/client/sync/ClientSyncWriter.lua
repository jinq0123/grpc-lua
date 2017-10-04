--- Client sync writer class.
-- @classmod grpc_lua.client.sync.ClientSyncWriter

local ClientSyncWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @function ClientSyncWriter
-- @tparam Channel c_channel
-- @string method_name
-- @tparam number|nil timeout_sec nil means no timeout
-- @treturn table object
function ClientSyncWriter:new(c_channel, method_name,
                              request_type, timeout_sec)
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    local writer = {
        -- private:
        _c_writer = c.ClientSyncWriter(c_channel, method_name, timeout_sec),
        _request_type = request_type,
    }

    setmetatable(writer, self)
    self.__index = self
    return writer
end  -- new()

--- Write message.
-- @table message
-- @treturn boolean return false on error
function ClientSyncWriter:write(message)
    assert("table" == type(message))
    local msg_str = pb.encode(self._request_type, message)
    self._writer.write(msg_str)
end  -- write()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncWriter
