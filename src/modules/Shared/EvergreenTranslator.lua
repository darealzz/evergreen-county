--[[
	@class EvergreenTranslator
]]

local require = require(script.Parent.loader).load(script)

return require("JSONTranslator").new("EvergreenTranslator", "en", {
	gameName = "Evergreen",
})

