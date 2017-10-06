--- Service stub.
-- Wraps C `ServiceStub` class.
-- @classmod grpc_lua.client.service_stub.ServiceStub

local ServiceStub = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")
local MethodInfo = require("grpc_lua.impl.MethodInfo")
local ClientSyncReader = require("grpc_lua.client.sync.ClinetSyncReader")
local ClientSyncWriter = require("grpc_lua.client.sync.ClinetSyncWriter")
local response_callback = require("grpc_lua.client.service_stub.response_callback")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New `ServiceStub` object.
-- Do not call it directly, use `grpc_lua.ServiceStub(ch)` instead.
-- @tparam userdata c_channel C `Channel` object
-- @string service_name full service name like "helloworld.Greeter"
-- @treturn table `ServiceStub` object
function ServiceStub:new(c_channel, service_name)
    assert("userdata" == type(c_channel))
    local stub = {
        -- public:

        timeout_sec = nil,  -- default no timeout

        -- Error callback for async request.
        -- `function(error_str, status_code)`
        -- nil to ignore all errors.
        on_error = nil,

        -- private:
        _c_stub = c.ServiceStub(c_channel),
        _c_channel = c_channel,
        _service_name = service_name,
        _method_info_map = {}  -- map { [method_name] = MethodInfo }
    }
    setmetatable(stub, self)
    self.__index = self
    return stub
end  -- new()

-- Todo: get_channel() to new other stub.

--- Sync request.
-- @string method_name
-- @tab request request message
-- @treturn string|(nil, string, int) response string or
-- `(nil, error_string, grpc_status_code)`.
-- @usage request("SayHello", { name = "Jq" })
function ServiceStub:sync_request(method_name, request)
    assert("table" == type(request))
    self:_assert_simple_rpc(method_name)
    local request_name = self:_get_request_name(method_name)
    local request_str = self:_encode_request(method_name, request)
    local response_str, error_str, status_code =
        self._c_stub:sync_request(request_name, request_str)
    local response = self:_decode_response(method_name, response_str)
    return response, error_str, status_code
end  -- request()

--- Async request.
-- @string method_name method name
-- @tab request request message
-- @func[opt] response_cb response callback, `function(response_message_table)`
function ServiceStub:async_request(method_name, request, response_cb)
    assert("table" == type(request))
    assert(nil == response_cb or "function" == type(response_cb))
    self:_assert_simple_rpc(method_name)
    local request_name = self:_get_request_name(method_name)
    local request_str = self:_encode_request(method_name, request)
    -- Need to wrap the response callback.
    self._c_stub:async_request(request_name, request_str,
        self:_get_response_callback(method_name, response_cb),
        self.on_error)
end  -- async_request()

--- Sync request server side streaming rpc.
-- Will return immediately.
-- @string method_name method name
-- @tab request request message
-- @treturn ClientSyncReader
function ServiceStub:sync_request_read(method_name, request)
    assert("table" == type(request))
    self:_assert_server_side_streaming(method_name)
    local request_name = self:_get_request_name(method_name)
    local req_str = self:_encode_request(request)
    local response_type = self:_get_response_type(method_name)  -- XXX OK for streaming?
    return ClientSyncReader:new(self._c_channel, request_name,
        req_str, response_type, self.timeout_sec)
end  -- sync_request_read()

--- Async request server side streaming rpc.
-- Will return immediately.
-- The callback function on_read and on_status will be called in the run().
-- @string method_name method name
-- @tab request request message
-- @tparam[opt=nil] function|nil on_msg message callback, `function(table)`
-- @tparam[optchain=nil] function|nil on_status status callback,
--  `function(error_str|nil, status_code)`, nil means to use self.on_error
-- @usage
-- stub.async_request_read("ListFeatures", rect,
--   function(message) assert("table" == type(message)) end,
--   function(error_str, status_code)
--     assert(not error_str or "string" == type(error_str))
--     assert("number" == type(status_code))
--   end)
function ServiceStub:async_request_read(method_name, request, on_msg, on_status)
    assert("table" == type(request))
    assert(not on_msg or "function" == type(on_msg))
    on_status = on_status or self.on_error
    assert(not on_status or "function" == type(on_status))
    self:_assert_server_side_streaming(method_name)
    local request_name = self:_get_request_name(method_name)
    local req_str = self:_encode_request(request)
    local response_type = self:_get_response_type(method_name)  -- XXX OK for streaming?
    self._c_stub.async_request(self._c_channel, request_name, XXX)
end  -- async_request_read()

--- Sync request client side streaming rpc.
-- Will return immediately.
-- @string method_name method name
-- @treturn ClientSyncWriter
function ServiceStub:sync_request_write(method_name)
    self:_assert_client_side_streaming(method_name)
    local request_name = self:_get_request_name(method_name)
    local request_type = self:_get_request_type(method_name)
    local response_type = self:_get_response_type(method_name)
    return ClientSyncWriter:new(self._c_channel,
        request_name, request_type, response_type, self.timeout_sec)
end  -- sync_request_read()

--- Sync request bi-directional streaming rpc.
-- Will return immediately.
-- @string method_name method name
-- @treturn ClientSyncReaderWriter
function ServiceStub:sync_request_rdwr(method_name)
    self:_assert_bidirectional_streaming(method_name)
    local request_name = self:_get_request_name(method_name)
    local request_type = self:_get_request_type(method_name)
    local response_type = self:_get_response_type(method_name)
    return ClientSyncReaderWriter:new(self._c_channel,
        request_name, request_type, response_type, self.timeout_sec);
end  -- sync_request_rdwr()

--- Blocking run.
function ServiceStub:run()
    self._c_stub:run()
end  -- run()

--- Shutdown the stub.
-- To end run().
function ServiceStub:shutdown()
    self._c_stub:shutdown()
end  -- shutdown()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

--- Encode request table to string.
function ServiceStub:_encode_request(method_name, request)
    local request_type = self:_get_request_type(method_name)
    return pb.encode(request_type, request)
end  -- _encode_request()

--- Decode response string to message table.
function ServiceStub:_decode_response(method_name, response_str)
    if not response_str then return nil end
    assert("string" == type(response_str))
    local response_type = self:_get_response_type(method_name)
    return pb.decode(response_type, response_str)
end  -- _decode_response()

--- Wrap a response callback.
-- @string method_name
-- @tparam function|nil response_cb `function(table)`
-- @func[opt] on_error `function(string, int)`
-- @treturn function `function(string)`
function ServiceStub:_get_response_callback(method_name, response_cb, on_error)
    if not response_cb then return nil end
    on_error = on_error or self.on_error
    local response_type = self:_get_response_type(method_name)
    local cb = response_callback.wrap(response_cb, response_type,
        response_cb, self.on_error)
    assert("function" == type(cb))
    return cb
end  -- _get_response_callback()

--- Get request type.
-- @string method_name
-- @treturn string
function ServiceStub:_get_request_type(method_name)
    return self:_get_method_info(method_name).request_type
end  -- _get_request_type()

function ServiceStub:_get_response_type(method_name)
    return self:_get_method_info(method_name).response_type
end  -- _get_response_type()

--- Get method information.
-- Load it if not.
-- @string method_name
-- @treturn MethodInfo
function ServiceStub:_get_method_info(method_name)
    local method_info = self._method_info_map[method_name]
    if method_info then return method_info end

    method_info = MethodInfo:new(self._service_name, method_name)
    self._method_info_map[method_name] = method_info
    return method_info
end  -- _get_method_info()

--- Assert method is simple rpc.
-- @string method_name
function ServiceStub:_assert_simple_rpc(method_name)
    assert(self:_get_method_info(method_name):is_simple_rpc(),
        method_name .. " is not simple rpc method.")
end

--- Assert method is bi-directional streaming.
-- @string method_name
function ServiceStub:_assert_bidirectional_streaming(method_name)
    assert(self:_get_method_info(method_name):is_bidirectional_streaming(),
        method_name .. " is not bi-directional streaming rpc method.")
end

--- Assert method is client side streaming rpc.
-- @string method_name
function ServiceStub:_assert_client_side_streaming(method_name)
    assert(self:_get_method_info(method_name):is_client_side_streaming(),
        method_name .. " is not client side streaming rpc method.")
end

--- Assert method is server side streaming rpc.
-- @string method_name
function ServiceStub:_assert_server_side_streaming(method_name)
    assert(self:_get_method_info(method_name):is_server_side_streaming(),
        method_name .. " is not server side streaming rpc method.")
end

--- Get request name.
-- @string method_name method name, like "SayHello"
-- @treturn request name, like "/helloworld.Greeter/SayHello"
function ServiceStub:_get_request_name(method_name)
    return "/" .. self._service_name .. "/" .. method_name
end  -- _get_request_name()

return ServiceStub
