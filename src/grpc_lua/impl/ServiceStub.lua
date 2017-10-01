--- Service stub.
-- Wraps C `ServiceStub` class.
-- @classmod grpc_lua.impl.ServiceStub

local ServiceStub = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New `ServiceStub` object.
-- Do not call it directly, use `grpc_lua.ServiceStub(ch)` instead.
-- @tparam userdata c_channel C `Channel` object
-- @string[opt] service_name service name like "helloworld.Greeter"
-- @treturn table `ServiceStub` object
function ServiceStub:new(c_channel, service_name)
    assert("userdata" == type(c_channel))
    local stub = {
        service_name = service_name,

        -- private:
        _c_stub = c.ServiceStub(c_channel),
        -- channel = c_channel,  -- to new other ServiceStubs
    }
    setmetatable(stub, self)
    self.__index = self
    return stub
end  -- new()

-- Todo: get_channel() to new other stub.

--- Set service name.
-- @string service_name full name like "helloworld.Greeter".
function ServiceStub:set_service_name(service_name)
    self.service_name = service_name
end  -- set_service_name()

--- Set timeout seconds like 0.5s.
-- @tparam number|nil timeout_sec timeout seconds, nil means no timeout.
function ServiceStub:set_timeout_sec(timeout_sec)
    self.timeout_sec = timeout_sec
end  -- set_timeout_sec()

--- Get request name.
-- @string method_name method name, like "/helloworld.Greeter/SayHello"
function ServiceStub:get_request_name(method_name)
    return "/" .. self.service_name .. "/" .. method_name
end  -- get_request_name()

--- Set error callback for async request.
-- @tparam function|nil on_error error callback
-- `on_error` is `function(error_str, status_code)`
-- `on_error` may be nil to ignore all errors.
function ServiceStub:set_on_error(on_error)
    assert(nil == on_error or "function" == type(on_error))
    self.on_error = on_error
end  -- set_on_error()

--- Blocking request.
-- @string method_name
-- @tab request request message
-- @treturn string|(nil, string, int) response string or
-- `(nil, error_string, grpc_status_code)`.
-- @usage request("SayHello", { name = "Jq" })
function ServiceStub:blocking_request(method_name, request)
    assert("table" == type(request))
    local request_name = self:get_request_name(method_name)
    local request_str = self:_encode_request(method_name, request)
    local response_str, error_str, status_code =
        self._c_stub:blocking_request(request_name, request_str)
    local response = self:_decode_response(method_name, response_str)
    return response, error_str, status_code
end  -- request()

--- Async request.
-- @string method_name method name
-- @tab request request message
-- @func[opt] on_response response callback, `function(response_message_table)`
function ServiceStub:async_request(method_name, request, on_response)
    assert("table" == type(request))
    assert(nil == on_response or "function" == type(on_response))
    local request_name = self:get_request_name(method_name)
    local request_str = self:_encode_request(method_name, request)
    -- Need to wrap the response callback.
    self._c_stub:async_request(request_name, request_str,
        self:_get_response_callback(method_name, on_response),
        self.on_error)
end  -- async_request()

--- Blocking run.
function ServiceStub:blocking_run()
    self._c_stub:blocking_run()
end  -- blocking_run()

--- Shutdown the stub.
-- To end blocking_run().
function ServiceStub:shutdown()
    self._c_stub:shutdown()
end  -- shutdown()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

--- Encode request table to string.
function ServiceStub:_encode_request(method_name, request)
    local request_type = pb.get_rpc_input_name(self.service_name, method_name)
    return pb.encode(request_type, request)
end  -- _encode_request()

--- Decode response string to message table.
function ServiceStub:_decode_response(method_name, response_str)
    if not response_str then return nil end
    assert("string" == type(response_str))
    local response_type = pb.get_rpc_output_name(self.service_name, method_name)
    return pb.decode(response_type, response_str)
end  -- _decode_response()

--- Async request callback.
local function on_response_str(service_name, method_name, response_str,
                               on_response, on_error)
    assert(on_response)  -- while on_error may be nil
    local response_type = pb.get_rpc_output_name(service_name, method_name)
    local response = pb.decode(response_type, response_str)
    if response then
        on_response(response)
        return
    end
    if on_error then
        -- GRPC_STATUS_INTERNAL = 13
        on_error("Failed to decode response.", 13)
    end
end  -- on_response_str()

--- Wrap a response callback.
function ServiceStub:_get_response_callback(method_name, on_response)
    if not on_response then return nil end
    return function(response_str)
        on_response_str(self.service_name, method_name, response_str,
            on_response, self.on_error)
    end
end  -- _get_response_callback()

return ServiceStub
