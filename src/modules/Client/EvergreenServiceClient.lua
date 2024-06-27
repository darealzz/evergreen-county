--[=[
	@class EvergreenServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local EvergreenServiceClient = {}
EvergreenServiceClient.ServiceName = "EvergreenServiceClient"

function EvergreenServiceClient:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External

	-- Internal
	self._serviceBag:GetService(require("EvergreenScreenProvider"))

	self._serviceBag:GetService(require("LoadingInterfaceService"))
	self._serviceBag:GetService(require("ATMProximityBinder"))
	self._serviceBag:GetService(require("ButtonBinder"))
	self._serviceBag:GetService(require("ATMInterfaceService"))
	self._serviceBag:GetService(require("InfoCardService"))
end

return EvergreenServiceClient

