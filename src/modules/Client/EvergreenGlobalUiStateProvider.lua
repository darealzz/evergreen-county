local require = require(script.Parent.loader).load(script)

local Rx = require("Rx")
local Brio = require("Brio")
local ValueObject = require("ValueObject")

return ValueObject.new(
	false, -- All UI should be not enabled by default
	"boolean"
)
