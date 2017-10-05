--- Client sync reader writer class.
-- @classmod grpc_lua.client.sync.ClientSyncReaderWriter

local ClientSyncReaderWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @tparam Channel c_channel
-- @string method_name
-- @string request_type
-- @string response_type
-- @tparam number|nil timeout_sec nil means no timeout
-- @treturn table object
function ClientSyncReaderWriter:new(c_channel,
        method_name, request_type, response_type, timeout_sec);
    assert("userdata" == type(c_channel))
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    assert("string" == type(response_type))
    local rdwr = {
        -- private:
        _c_rdwr = c.ClientSyncReaderWriter(c_channel, method_name, timeout_sec),
        _request_type = request_type,
        _response_type = response_type,
    }

    setmetatable(rdwr, self)
    self.__index = self
    return rdwr
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncReaderWriter
