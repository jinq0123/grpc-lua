--- Service method info class.
-- Internal used by `ServiceStub` and `Service`.
-- @classmod grpc_lua.cpmmon.MethodInfo

local MethodInfo = {}

local pb = require("luapbintf")

--- Get request name.
-- @string service_name full service name, like "helloword.Greeter"
-- @string method_name method name, like "SayHello"
-- @treturn request name, like "/helloworld.Greeter/SayHello"
local function get_request_name(service_name, method_name)
    return "/" .. service_name .. "/" .. method_name
end  -- get_request_name()

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- New `MethodInfo` object.
-- @string service_name full service name like "helloworld.Greeter"
-- @string method_name
-- @treturn table `MethodInfo` object
function MethodInfo:new(service_name, method_name)
    local info = {
        -- service_name = service_name,
        method_name = method_name,
        request_name = get_request_name(service_name, method_name),
        request_type = pb.get_rpc_input_name(service_name, method_name),
        response_type = pb.get_rpc_output_name(service_name, method_name),
        is_client_streaming = pb.is_rpc_client_streaming(service_name, method_name),
        is_server_streaming = pb.is_rpc_server_streaming(service_name, method_name),
    }
    assert("string" == type(info.request_type))
    assert("string" == type(info.response_type))
    assert("boolean" == type(info.is_client_streaming))
    assert("boolean" == type(info.is_server_streaming))

    setmetatable(info, self)
    self.__index = self
    return info
end  -- new()

--- Is simple rpc.
-- @treturn boolean
function MethodInfo:is_simple_rpc()
    return not self.is_client_streaming and not self.is_server_streaming
end

--- Assert simple rpc.
function MethodInfo:assert_simple_rpc()
    assert(self:is_simple_rpc(), self.method_name .. " is not simple rpc method.")
end

--- Is bi-directional streaming.
-- @treturn boolean
function MethodInfo:is_bidirectional_streaming()
    return self.is_client_streaming and self.is_server_streaming
end

--- Assert bi-directional streaming.
function MethodInfo:assert_bidirectional_streaming()
    assert(self:is_bidirectional_streaming(),
        self.method_name .. " is not bi-directional streaming rpc method.")
end

--- Is client side streaming.
-- @treturn boolean
function MethodInfo:is_client_side_streaming()
    return self.is_client_streaming and not self.is_server_streaming
end

--- Assert client side streaming.
function MethodInfo:assert_client_side_streaming()
    assert(self:is_client_side_streaming(),
        self.method_name .. " is not client side streaming rpc method.")
end

--- Is server side streaming.
-- @treturn boolean
function MethodInfo:is_server_side_streaming()
    return not self.is_client_streaming and self.is_server_streaming
end

--- Assert server side streaming.
function MethodInfo:assert_server_side_streaming()
    assert(self:is_server_side_streaming(),
        self.method_name .. " is not server side streaming rpc method.")
end

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return MethodInfo
