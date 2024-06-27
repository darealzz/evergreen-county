--[=[
	@class ATMInterfaceService

	Renders interface for ATM banking
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EvergreenScreenProvider = require("EvergreenScreenProvider")
local LoadingInterfaceService = require("LoadingInterfaceService")

local BasicPane = require("BasicPane")
local Blend = require("Blend")
local Maid = require("Maid")

local AtmFrame = ReplicatedStorage.InterfaceToMount.Game.Bank

local Service = {}
Service.ServiceName = script.Name

function Service:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._loadingInterfaceService = serviceBag:GetService(LoadingInterfaceService)
	self._evergreenScreenProvider = serviceBag:GetService(EvergreenScreenProvider)
	self._view = BasicPane.new()
	self._maid = Maid.new()
end

function Service:Start()
	self._screen = self._maid:Add(self:_mountScreen())
	self._view.Gui = self._maid:Add(self:_mountInterface(self._screen))
end

function Service:ShowUi()
	self._view:Show()
end

function Service:ObserveUiVisible()
	return self._view:ObserveVisible()
end

function Service:_mountScreen()
	return self._evergreenScreenProvider:Get("ATM_INTERFACE")
end

function Service:_mountInterface(screen)
	local gui = self:_render()
	gui.Parent = screen
	return gui
end

function Service:_render()
	self._maid:GiveTask(Blend.mount(AtmFrame, {
		Visible = true,

		Blend.Find("ImageLabel")({
			Name = "Content",

			Blend.Find("ImageButton")({
				Name = "Transact",
				[Blend.Tags] = "UiButton",
			}),

			Blend.Find("ImageButton")({
				Name = "CloseButton",

				[Blend.Tags] = "UiButton",

				[Blend.OnEvent("MouseButton1Click")] = function()
					self._view:Hide()
				end,
			}),
		}),
	}))

	self._screen.Enabled = false
	self._loadingInterfaceService:CallWhenSaveToEnableInterface(function()
		self:ObserveUiVisible():Subscribe(function(isVisible: boolean)
			self._screen.Enabled = isVisible
		end)
	end)

	return AtmFrame
end

function Service:Destroy()
	self._maid:DoCleaning()
end

return Service
