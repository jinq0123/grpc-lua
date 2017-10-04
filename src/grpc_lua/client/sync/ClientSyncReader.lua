--- Client sync reader class.
-- @classmod grpc_lua.client.sync.ClientSyncReader

local ClientSyncReader = {}

-------------------------------------------------------------------------------
--- Public functions.
-- @section public

--- Constructor.
-- @treturn table object
function ClientSyncReader:new()
    local reader = {
    }

    setmetatable(reader, self)
    self.__index = self
    return reader
end  -- new()

-------------------------------------------------------------------------------
--- Private functions.
-- @section private

return ClientSyncReader
