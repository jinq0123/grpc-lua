--- Client async writer class.
-- @classmod grpc_lua.client.async.ClientAsyncWriter

local ClientAsyncWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @tparam Channel c_channel
-- @string request_name like "/routeguide.RouteGuide/ListFeatures"
-- @string request_type
-- @string response_type
-- @tparam number|nil timeout_sec nil means no timeout
-- @treturn table object
function ClientAsyncWriter:new(c_channel, request_name, c_completion_queue,
        request_type, response_type, timeout_sec)
    assert("userdata" == type(c_channel))
    assert("string" == type(request_name))
    assert("userdata" == type(c_completion_queue)
    assert("string" == type(request_type))
    assert("string" == type(response_type))
    local writer = {
        -- private:
        _c_writer = c.ClientAsyncWriter(c_channel,
            request_name, c_completion_queue, timeout_sec),
        _request_type = request_type,
        _response_type = response_type,
    }

    setmetatable(writer, self)
    self.__index = self
    return writer
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientAsyncWriter
