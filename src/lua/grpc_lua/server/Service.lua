--- Service.
-- Wraps service implementation module.
-- @classmod grpc_lua.server.Service

local Service = {}

local pb = require("luapbintf")
local Replier = require("grpc_lua.server.Replier")
local Reader = require("grpc_lua.server.Reader")
local Writer = require("grpc_lua.server.Writer")

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Service constructor.
-- Used by `Server`. Do not call it directly.
-- @tab svc_impl service implementation
-- @treturn Service
function Service:new(svc_impl)
    assert("table" == type(svc_impl))
    local svc = {
        impl = svc_impl,
    }
    setmetatable(svc, self)
    self.__index = self
    return svc
end  -- new()

--- Call simple rpc service method.
-- @string method_name method name, like: "SayHello"
-- @string request_type request type, like: "helloworld.HelloRequest"
-- @string request_str request message string
-- @tparam userdata c_replier C replier object
-- @string response_type response type, like: "helloworld.HelloResponse"
function Service:call_simple_method(method_name, request_type, request_str,
                                    c_replier, response_type)
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    assert("string" == type(request_str))
    assert("userdata" == type(c_replier))
    assert("string" == type(response_type))

    local method = assert(self.impl[method_name], "No such method: "..method_name)
    local request = assert(pb.decode(request_type, request_str))  -- XXX check result
    local replier = Replier:new(c_replier, response_type)
    method(request, replier)
end

--- Call server-to-client streaming rpc method.
-- @string method_name method name, like: "ListFeatures"
-- @string request_type request type, like: "routeguide.Rectangle"
-- @string request_str request message string
-- @tparam userdata c_writer C `ServerWriter` object
-- @string response_type response type, like: "routeguide.Feature"
function Service:call_s2c_streaming_method(method_name,
        request_type, request_str, c_writer, response_type)
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    assert("string" == type(request_str))
    assert("userdata" == type(c_writer))
    assert("string" == type(response_type))

    local method = assert(self.impl[method_name], "No such method: "..method_name)
    local request = assert(pb.decode(request_type, request_str))  -- XXX check result
    local writer = Writer:new(c_writer, response_type)
    method(request, writer)
end

--- Call client-to-server streaming rpc method.
-- @string method_name method name, like: "RecordRoute"
-- @string request_type request type, like: "routeguide.Point"
-- @tparam userdata c_replier C `ServerReplier` object
-- @string response_type response type, like: "routeguide.Summary"
-- @treturn Reader server reader object
function Service:call_c2s_streaming_method(method_name,
        request_type, c_replier, response_type)
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    assert("userdata" == type(c_replier))
    assert("string" == type(response_type))

    local method = assert(self.impl[method_name], "No such method: "..method_name)
    local replier = Replier:new(c_replier, response_type)
    local reader_impl = method(replier)
    return Reader:new(reader_impl, request_type)
end

--- Call bi-directional streaming rpc method.
-- @string method_name method name, like: "RouteChat"
-- @string request_type request type, like: "routeguide.RouteNote"
-- @tparam userdata c_writer C `ServerWriter` object
-- @string response_type response type, like: "routeguide.RouteNote"
-- @treturn Reader server reader object
function Service:call_bidi_streaming_method(method_name,
        request_type, c_writer, response_type)
    assert("string" == type(method_name))
    assert("string" == type(request_type))
    assert("userdata" == type(c_writer))
    assert("string" == type(response_type))

    local method = assert(self.impl[method_name], "No such method: "..method_name)
    local writer = Writer:new(c_writer, response_type)
    local reader_impl = method(writer)
    return Reader:new(reader_impl, request_type)
end

return Service
