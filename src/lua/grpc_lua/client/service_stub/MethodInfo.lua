--- Service method info class.
-- Internal used by `ServiceStub`.
-- @classmod grpc_lua.client.service_stub.MethodInfo

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
        -- method_name = method_name,
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

--- Is bi-directional streaming.
-- @treturn boolean
function MethodInfo:is_bidirectional_streaming()
    return self.is_client_streaming and self.is_server_streaming
end

--- Is client side streaming.
-- @treturn boolean
function MethodInfo:is_client_side_streaming()
    return self.is_client_streaming and not self.is_server_streaming
end

--- Is server side streaming.
-- @treturn boolean
function MethodInfo:is_server_side_streaming()
    return not self.is_client_streaming and self.is_server_streaming
end

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return MethodInfo
