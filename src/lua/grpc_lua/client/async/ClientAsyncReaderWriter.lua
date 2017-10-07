--- Client async reader writer class.
-- @classmod grpc_lua.client.async.ClientAsyncReaderWriter

local ClientAsyncReaderWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @tparam Channel c_channel
-- @string request_name, like "/routeguide.RouteGuide/RouteChat"
-- @param c_completion_queue C completion queue object
-- @string request_type
-- @string response_type
-- @tparam number|nil timeout_sec nil means no timeout
-- @treturn table object
function ClientAsyncReaderWriter:new(c_channel, request_name,
        c_completion_queue, request_type, response_type, timeout_sec)
    assert("userdata" == type(c_channel))
    assert("string" == type(request_name))
    assert("userdata" == type(c_completion_queue)
    assert("string" == type(request_type))
    assert("string" == type(response_type))
    local rdwr = {
        -- private:
        _c_rdwr = c.ClientAsyncReaderWriter(c_channel, request_name,
            c_completion_queue, timeout_sec),
        _request_type = request_type,
        _response_type = response_type,
    }

    setmetatable(rdwr, self)
    self.__index = self
    return rdwr
end  -- new()

--- Write message.
-- @table message
-- @treturn boolean return false on error
function ClientAsyncWriter:write(message)
    assert("table" == type(message))
    local msg_str = pb.encode(self._request_type, message)
    self._c_writer.write(msg_str)
end  -- write()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientAsyncReaderWriter
