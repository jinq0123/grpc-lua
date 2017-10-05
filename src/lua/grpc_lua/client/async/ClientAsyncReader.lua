--- Client async reader class.
-- @classmod grpc_lua.client.async.ClientAsyncReader

local ClientAsyncReader = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @treturn table object
function ClientAsyncReader:new()
    local reader = {
    }

    setmetatable(reader, self)
    self.__index = self
    return reader
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientAsyncReader
