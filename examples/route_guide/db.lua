--- Load DB file.
-- @module db

local M = {
    features = {},
}

local json = require("json")

local DB_PATH = "route_guide_db.json"

function M.load()
    local f = assert(io.open(DB_PATH))
    local s = f:read("a")
    M.features = json.decode(s)
end  -- load()

return M
