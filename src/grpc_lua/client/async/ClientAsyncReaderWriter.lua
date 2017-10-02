--- Client async reader writer class.
-- @classmod grpc_lua.client.sync.ClientAsyncReaderWriter

local ClientAsyncReaderWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @treturn table object
function ClientAsyncReaderWriter:new()
    local rdwr = {
    }

    setmetatable(rdwr, self)
    self.__index = self
    return rdwr
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientAsyncReaderWriter
