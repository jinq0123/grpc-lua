--- Client sync writer class.
-- @classmod grpc_lua.client.sync.ClientSyncWriter

local ClientSyncWriter = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @treturn table object
function ClientSyncWriter:new()
    local writer = {
    }

    setmetatable(writer, self)
    self.__index = self
    return writer
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncWriter
