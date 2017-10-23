--- Service.
-- Wraps service implementation module.
-- @classmod grpc_lua.server.Service

local Service = {}

local pb = require("luapbintf")
local Replier = require("grpc_lua.server.Replier")
local Reader = require("grpc_lua.server.Reader")
local Writer = require("grpc_lua.server.Writer")

--[[ Method info = {
    name = string, like "SayHello"
    input_type = string, like "helloworld.HelloRequest"
    output_type = string, like "helloworld.HelloReply"

    func = function of implementation (nil to load later)
} ]]

--- Get initial service method info array.
-- @string svc_full_name like "helloworld.Greeter"
-- @tab svc_desc service descriptor message table
-- @tab svc_impl service implementation
-- @treturn table array of method info
local function init_method_info_arr(svc_full_name, svc_desc, svc_impl)
    assert("table" == type(svc_desc))
    assert("table" == type(svc_impl))
    -- See: service_descriptor_example.txt
    local methods = svc_desc.method
    assert("table" == type(methods))
    local result = {}
    for i = 1, #methods do
        local mthd = methods[i]
        assert("table" == type(mthd))
        local name = mthd.name
        local func = svc_impl[name]
        assert(not func or "function" == type(func))
        result[i] = {  -- method info array
            name = name,
            input_type = pb.get_rpc_input_name(svc_full_name, name),
            output_type = pb.get_rpc_output_name(svc_full_name, name),
            func = func,  -- may nil to load later
        }  -- result
    end  -- for
    return result
end  -- init_method_info_arr()

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Service constructor.
-- Used by `Server`. Do not call it directly.
-- @string svc_full_name like "helloworld.Greeter"
-- @tab svc_desc service descriptor message table
-- @tab svc_impl service implementation
-- @treturn Service
function Service:new(svc_full_name, svc_desc, svc_impl)
    assert("string" == type(svc_full_name))
    assert("table" == type(svc_desc))
    assert("table" == type(svc_impl))
    local svc = {
        -- private:
        _full_name = svc_full_name,
        _descriptor = svc_desc,
        _impl = svc_impl,

        -- method info array
        _method_info_arr = init_method_info_arr(svc_full_name, svc_desc, svc_impl),
    }
    setmetatable(svc, self)
    self.__index = self
    return svc
end  -- new()

-- Get service full name, like "helloworld.Greeter".
-- @treturn string
function Service:get_full_name()
    return self._full_name
end  -- get_full_name()

-- Get service descriptor table.
-- @treturn table
function Service:get_descriptor()
    return self._descriptor
end  -- get_descriptor()

--- Call simple rpc service method.
-- @int method_index method index, start from 1
-- @string request_str request message string
-- @tparam userdata c_replier C replier object
function Service:call_simple_method(method_index, request_str, c_replier)
    assert("number" == type(method_index) and method_index >= 1)
    assert("string" == type(request_str))
    assert("userdata" == type(c_replier))

    local mi = self._get_method_info(method_index)
    local request = assert(pb.decode(mi.input_type, request_str))  -- XXX check result
    local replier = Replier:new(c_replier, mi.output_type)
    method(request, replier)
end

--- Call server-to-client streaming rpc method.
-- @int method_index method index, start from 1
-- @string request_str request message string
-- @tparam userdata c_writer C `ServerWriter` object
function Service:call_s2c_streaming_method(method_index, request_str, c_writer)
    assert("number" == type(method_index) and method_index >= 1)
    assert("string" == type(request_str))
    assert("userdata" == type(c_writer))

    local mi = self._get_method_info(method_index)
    local request = assert(pb.decode(mi.input_type, request_str))  -- XXX check result
    local writer = Writer:new(c_writer, mi.output_type)
    method(request, writer)
end

--- Call client-to-server streaming rpc method.
-- @int method_index method index, start from 1
-- @tparam userdata c_replier C `ServerReplier` object
-- @treturn Reader server reader object
function Service:call_c2s_streaming_method(method_index, c_replier)
    assert("number" == type(method_index) and method_index >= 1)
    assert("userdata" == type(c_replier))

    local mi = self._get_method_info(method_index)
    local replier = Replier:new(c_replier, mi.output_type)
    local reader_impl = method(replier)
    return Reader:new(reader_impl, mi.input_type)
end

--- Call bi-directional streaming rpc method.
-- @int method_index method index, start from 1
-- @tparam userdata c_writer C `ServerWriter` object
-- @treturn Reader server reader object
function Service:call_bidi_streaming_method(method_index, c_writer)
    assert("number" == type(method_index) and method_index >= 1)
    assert("userdata" == type(c_writer))

    local mi = self._get_method_info(method_index)
    local writer = Writer:new(c_writer, mi.output_type)
    local reader_impl = method(writer)
    return Reader:new(reader_impl, mi.input_type)
end

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

--- Get method info.
-- Reload method function if necessary.
-- @int method_index
-- @treturn table method info
function Service:_get_method_info(method_index)
    -- assert("number" == type(method_index) and method_index >= 1)
    local info = assert(self._method_info_arr[method_index],
        "No such method index: "..method_index)
    if not info.func then
        info.func = assert(self._impl[info.name], "No such method: "..info.name)
        assert("function" == type(info.func))
    end
    return info
end  -- _get_method()

return Service
