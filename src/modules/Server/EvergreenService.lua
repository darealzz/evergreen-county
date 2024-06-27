--[=[
	@class EvergreenService
]=]

local require = require(script.Parent.loader).load(script)

local EvergreenService = {}
EvergreenService.ServiceName = "EvergreenService"

function EvergreenService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrService"))

	-- Internal
	self._serviceBag:GetService(require("EvergreenTranslator"))
end

return EvergreenService

