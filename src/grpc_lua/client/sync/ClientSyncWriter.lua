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
-- @string method_name
-- @string request_type
-- @string response_type
-- @tparam number|nil timeout_sec nil means no timeout
-- @treturn table object
function ClientSyncWriter:new(c_channel, method_name,
        request_type, response_type, timeout_sec)
    assert("userdata" == type(c_channel))
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    assert("string" == type(response_type))
    local writer = {
        -- private:
        _c_writer = c.ClientSyncWriter(c_channel, method_name, timeout_sec),
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
    self._c_writer.write(msg_str)
end  -- write()

--- Close and get response.
-- @treturn table|nil response message or nil on error
-- @treturn string error string, "" if OK
-- @treturn int status code
-- @usage resp, error_str, status_code = writer.close()
function ClientSyncWriter:close()
    local resp_str, error_str, status_code = self._c_writer.close()
    local resp = nil
    if resp_str then 
        resp = pb.decode(self._response_type, resp_str)  -- XXX if error?
    end
    return resp, error_str, status_code
end  -- close()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncWriter
