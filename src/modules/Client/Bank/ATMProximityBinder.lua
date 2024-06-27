local require = require(script.Parent.loader).load(script)

local LoadingInterfaceService = require("LoadingInterfaceService")

local Blend = require("Blend")
local Binder = require("Binder")
local BaseObject = require("BaseObject")

local ATMInterfaceSerivce = require("ATMInterfaceService")

local Component = setmetatable({}, BaseObject)
Component.__index = Component

function Component.new(robloxInstance, serviceBag)
	local self = setmetatable(BaseObject.new(robloxInstance), Component)

	self._loadingInterfaceService = serviceBag:GetService(LoadingInterfaceService)
	self._atmInterfaceService = serviceBag:GetService(ATMInterfaceSerivce)

	self._maid:GiveTask(self:_render():Subscribe(function(Gui)
		self.Gui = Gui

		self.Gui.Enabled = false
		self._loadingInterfaceService:CallWhenSaveToEnableInterface(function()
			self._atmInterfaceService:ObserveUiVisible():Subscribe(function(isVisible: boolean)
				self.Gui.Enabled = not isVisible
			end)
		end)
	end))

	return self
end

function Component:_render()
	return Blend.New "ProximityPrompt" {
		Name = "ATMPrompt",
		Parent = self._obj,

		[Blend.OnEvent("Triggered")] = function()
			self._atmInterfaceService:ShowUi()
		end
	}
end

return Binder.new("ATM", Component)