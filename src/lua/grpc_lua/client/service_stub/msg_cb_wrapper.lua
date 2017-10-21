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
-- @treturn string|nil error string, nil means no error
local function on_msg_str(msg_type, msg_str, msg_cb)
    assert("function" == type(msg_cb))
    local msg = pb.decode(msg_type, msg_str)
    if msg then
        msg_cb(msg)
        return nil
    end
    -- return error string.
    return "Failed to decode message " .. msg_type
end  -- on_msg_str()

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Wrap message callback into string callback.
-- @tparam function|nil msg_cb message callback `function(table)`
-- @string msg_type message type
-- @treturn function|nil `function(string) -> string|nil`
-- @usage
-- M.wrap(
--     function(message)
--         assert("table" == type(message))
--     end,
--     "routeguide.Rectangle")
function M.wrap(msg_cb, msg_type)
    if not msg_cb then return nil end
    assert("function" == type(msg_cb))
    assert("string" == type(msg_type))
    return function(msg_str)
        on_msg_str(msg_type, msg_str, msg_cb)
    end
end  -- wrap()

return M
