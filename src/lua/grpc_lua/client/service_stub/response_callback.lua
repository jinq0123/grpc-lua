--- Wrap message(table) response callback into string response callback.
-- C module need callback `function(string)`,
--   but user's callback is `function(table)`.
-- So wrap user's callback to a new function.
-- @module grpc_lua.client.service_stub.response_callback

local M = {}

local pb = require("luapbintf")

--- Async request callback.
-- @string response_type
-- @string response_str
-- @func on_response `function(table)`
-- @func[opt] on_error `function(string, int)`
local function on_response_str(
        response_type, response_str, on_response, on_error)
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

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Wrap message callback into string callback.
-- @func on_response `function(table)`
-- @string response_type
-- @func[opt] on_error `function(error_str, status_code)`
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
function M.wrap(on_response, response_type, on_error)
    assert("function" == type(on_response))
    assert("string" == response_type)
    assert(not on_error or "function" == type(on_error))

    return function(response_str)
        on_response_str(response_type, response_str,
            on_response, on_error)
    end
end  -- wrap()

return M
