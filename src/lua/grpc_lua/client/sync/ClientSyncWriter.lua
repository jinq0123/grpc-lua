--- Client sync writer class.
-- @classmod grpc_lua.client.sync.ClientSyncWriter

local ClientSyncWriter = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")

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
function ClientSyncWriter:new(c_channel, request_name,
        request_type, response_type, timeout_sec)
    assert("userdata" == type(c_channel))
    assert("string" == type(request_name))
    assert("string" == type(request_type))
    assert("string" == type(response_type))
    local writer = {
        -- private:
        _c_writer = c.ClientSyncWriter(c_channel, request_name, timeout_sec),
        _request_type = request_type,
        _response_type = response_type,
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
    self._c_writer:write(msg_str)
end  -- write()

--- Close and get response.
-- @treturn table|nil response message or nil on error
-- @treturn string error string, "" if OK
-- @treturn int status code
-- @usage resp, error_str, status_code = writer:close()
function ClientSyncWriter:close()
    local resp_str, error_str, status_code = self._c_writer:close()
    if not resp_str then
        return nil, error_str, status_code
    end

    local resp = pb.decode(self._response_type, resp_str)
    if resp then
        return resp, error_str, status_code
    end

    error_str = "Failed to decode response " .. self._response_type
    return nil, error_str, 13  -- GRPC_STATUS_INTERNAL = 13
end  -- close()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncWriter
