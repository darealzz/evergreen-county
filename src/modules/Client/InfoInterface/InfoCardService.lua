--[=[
	@class ATMInterfaceService

	Renders interface for ATM banking
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local EvergreenScreenProvider = require("EvergreenScreenProvider")
local LoadingInterfaceService = require("LoadingInterfaceService")

local ScreenGuiService = require("ScreenGuiService")
local BasicPane = require("BasicPane")
local Blend = require("Blend")
local Maid = require("Maid")
local Rx = require("Rx")

local InfoCardFrame = ReplicatedStorage.InterfaceToMount.Game.InfoCard
local LocalPlayer = Players.LocalPlayer

local Service = {}
Service.ServiceName = script.Name

function Service:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._loadingInterfaceService = serviceBag:GetService(LoadingInterfaceService)
	self._evergreenScreenProvider = serviceBag:GetService(EvergreenScreenProvider)
	self._maid = Maid.new()
	self._view = BasicPane.new()
end

function Service:Start()
	self._screen = self._maid:Add(self:_mountScreen())
	self._view.Gui = self._maid:Add(self:_mountInterface(self._screen))
	self._view:Show()
end

function Service:ShowUi()
	self._view:Show()
end

function Service:ObserveUiVisible()
	return self._view:ObserveVisible()
end

function Service:_mountScreen()
	return self._evergreenScreenProvider:Get("INFO_CARD") :: ScreenGui
end

function Service:_mountInterface(screen: ScreenGui)
	local gui = self:_render()
	gui.Parent = screen
	return gui
end

function Service:_render()
	self._maid:GiveTask(Blend.mount(InfoCardFrame, {
		Visible = true,

		Blend.Find "ImageLabel" {
			Name = "Card",

			Blend.Find "TextLabel" {
				Name = "Username",
				Text = LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")",
			},

			Blend.Find "ImageButton" {
				Name = "CloseButton",

				[Blend.Tags] = "UiButton",

				[Blend.OnEvent "MouseButton1Click"] = function()
					self._view:Hide()
				end,
			}
		},

		Blend.Find "ImageButton" {
			Name = "ShowId",

			[Blend.Tags] = "UiButton",
		}
	}))

	self._screen.Enabled = false
	self._loadingInterfaceService:CallWhenSaveToEnableInterface(function()
		self:ObserveUiVisible():Subscribe(function(isVisible: boolean)
			self._screen.Enabled = isVisible
		end)
	end)

	return InfoCardFrame
end

function Service:Destroy()
	self._maid:DoCleaning()
end

return Service