--- Wrap message(table) callback into string callback.
-- C module need callback `function(string)`,
--   but user's callback is `function(table)`.
-- So wrap user's callback to a new function.
-- @module grpc_lua.client.service_stub.msg_cb_wrapper

local M = {}

local pb = require("luapbintf")

--- Async msg callback.
-- @string msg_type
-- @string msg_str
-- @func msg_cb `function(table)`
-- @func[opt] error_cb `function(string, int)`
local function on_msg_str(
        msg_type, msg_str, msg_cb, error_cb)
    assert("funciton" == type(msg_cb))
    local msg = pb.decode(msg_type, msg_str)
    if msg then
        msg_cb(msg)
        return
    end
    if error_cb then
        -- GRPC_STATUS_INTERNAL = 13
        error_cb("Failed to decode message.", 13)
    end
end  -- on_msg_str()

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Wrap message callback into string callback.
-- @tparam function|nil msg_cb message callback `function(table)`
-- @string msg_type message type
-- @func[opt] error_cb `function(error_str, status_code)`
-- @treturn function|nil `function(string)`
-- @usage
-- M.wrap(
--     function(message)
--         assert("table" == type(message))
--     end,
--     "routeguide.Rectangle",
--     function(error_str, status_code)
--         assert(not error_str or "string" == type(error_str))
--         assert("number" == type(status_code))
--     end)
function M.wrap(msg_cb, msg_type, error_cb)
    if not msg_cb then return nil end
    assert("function" == type(msg_cb))
    assert("string" == msg_type)
    assert(not error_cb or "function" == type(error_cb))

    return function(msg_str)
        on_msg_str(msg_type, msg_str, msg_cb, error_cb)
    end
end  -- wrap()

return M
