local require = require(script.Parent.loader).load(script)

local GenericScreenGuiProvider = require("GenericScreenGuiProvider")

return GenericScreenGuiProvider.new({
	LOADING_SCREEN = 0,
	INFO_CARD = 50,
	ATM_INTERFACE = 100,
})
