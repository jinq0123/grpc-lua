--- Service stub.
-- @module grpc_lua.impl.service_stub

local ServiceStub = {}

local c = require("grpc_lua.c")  -- from grpc_lua.so
local pb = require("luapbintf")

function ServiceStub:new(channel)
    local stub = {
        c_stub = c.ServiceStub(channel),
        channel = channel,
    }
    setmetatable(stub, self)
    self.__index = self
    return stub
end  -- new()

-- Todo: move to new(service_name, channel), to make it const.
-- service_name is full name like "helloworld.Greeter".
function ServiceStub:set_service_name(service_name)
    self.service_name = service_name
end  -- set_service_name()

-- Set timeout seconds like 0.5s.
-- nil timeout means no timeout.
function ServiceStub:set_timeout_sec(timeout_sec)
    self.timeout_sec = timeout_sec
end  -- set_timeout_sec()

-- Like "/helloworld.Greeter/SayHello"
function ServiceStub:get_request_name(method_name)
    return "/" .. self.service_name .. "/" .. method_name
end  -- get_request_name()

-- Set error callback for async request.
-- on_error = function(error_str, status_code)
-- on_error may be nil to ignore all errors.
function ServiceStub:set_on_error(on_error)
    assert(nil == on_error or "function" == type(on_error))
    self.on_error = on_error
end  -- set_on_error

-- e.g. request("SayHello", { name = "Jq" })
-- Blocking request. 
-- Return the response string or (nil, error_string, grpc_status_code).
function ServiceStub:blocking_request(method_name, request)
    assert("table" == type(request))
    local request_name = self:get_request_name(method_name)
    local request_str = self:encode_request(method_name, request)
    local response_str, error_str, status_code =
        self.c_stub:blocking_request(request_name, request_str)
    local response = self:decode_response(method_name, response_str)
    return response, error_str, status_code
end  -- request()

-- Async request.
-- on_response is function(response_message_table)
function ServiceStub:async_request(method_name, request, on_response)
    assert("table" == type(request))
    assert(nil == on_response or "function" == type(on_response))
    local request_name = self:get_request_name(method_name)
    local request_str = self:encode_request(method_name, request)
    -- Need to wrap the response callback.
    self.c_stub:async_request(request_name, request_str,
        self:get_response_callback(method_name, on_response),
        self.on_error)
end  -- async_request()

function ServiceStub:blocking_run()
    self.c_stub:blocking_run()
end  -- blocking_run()

-- private --

-- Encode request table to string.
function ServiceStub:encode_request(method_name, request)
    local request_type = pb.get_rpc_input_name(self.service_name, method_name)
    return pb.encode(request_type, request)
end  -- encode_request()

-- Decode response string to message table.
function ServiceStub:decode_response(method_name, response_str)
    if not response_str then return nil end
    assert("string" == type(response_str))
    local response_type = pb.get_rpc_output_name(self.service_name, method_name)
    return pb.decode(response_type, response_str)
end  -- decode_response()

-- Async request callback.
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

-- Wrap a response callback.
function ServiceStub:get_response_callback(method_name, on_response)
    if not on_response then return nil end
    return function(response_str)
        on_response_str(self.service_name, method_name, response_str,
            on_response, self.on_error)
    end
end  -- get_response_callback()

return ServiceStub
