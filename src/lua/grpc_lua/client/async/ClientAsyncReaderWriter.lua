--- Client async reader writer class.
-- @classmod grpc_lua.client.async.ClientAsyncReaderWriter

local ClientAsyncReaderWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @treturn table object
function ClientAsyncReaderWriter:new()
    local rdwr = {
    }

    setmetatable(rdwr, self)
    self.__index = self
    return rdwr
end  -- new()

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
            c_completioin_queue, timeout_sec),
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

return ClientAsyncReaderWriter
