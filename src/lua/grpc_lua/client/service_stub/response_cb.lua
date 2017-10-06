--- Wrap message(table) response callback into string response callback.
-- C module need callback `function(string)`,
--   but user's callback is `function(table)`.
-- So wrap user's callback to a new function.
-- @module grpc_lua.client.service_stub.response_cb

local M = {}

local pb = require("luapbintf")

--- Async request callback.
-- @string response_type
-- @string response_str
-- @func response_cb `function(table)`
-- @func[opt] error_cb `function(string, int)`
local function on_response_str(
        response_type, response_str, response_cb, error_cb)
    local response = pb.decode(response_type, response_str)
    if response then
        response_cb(response)
        return
    end
    if error_cb then
        -- GRPC_STATUS_INTERNAL = 13
        error_cb("Failed to decode response.", 13)
    end
end  -- on_response_str()

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Wrap message callback into string callback.
-- @func response_cb `function(table)`
-- @string response_type
-- @func[opt] error_cb `function(error_str, status_code)`
-- @treturn function `function(string)`
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
function M.wrap(response_cb, response_type, error_cb)
    assert("function" == type(response_cb))
    assert("string" == response_type)
    assert(not error_cb or "function" == type(error_cb))

    return function(response_str)
        on_response_str(response_type, response_str,
            response_cb, error_cb)
    end
end  -- wrap()

return M
