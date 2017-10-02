--- Client sync reader writer class.
-- @classmod grpc_lua.client.sync.ClientSyncReaderWriter

local ClientSyncReaderWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @treturn table object
function ClientSyncReaderWriter:new()
    local rdwr = {
    }

    setmetatable(rdwr, self)
    self.__index = self
    return rdwr
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncReaderWriter
