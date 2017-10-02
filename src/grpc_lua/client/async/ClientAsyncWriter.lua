--- Client async writer class.
-- @classmod grpc_lua.client.sync.ClientAsyncWriter

local ClientAsyncWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @treturn table object
function ClientAsyncWriter:new()
    local writer = {
    }

    setmetatable(writer, self)
    self.__index = self
    return writer
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientAsyncWriter
