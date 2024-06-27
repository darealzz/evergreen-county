--[=[
	@class ATMInterfaceService

	Renders interface for ATM banking
]=]

local require = require(script.Parent.loader).load(script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local EvergreenScreenProvider = require("EvergreenScreenProvider")

local BasicPane = require("BasicPane")
local Blend = require("Blend")
local Maid = require("Maid")
local Rx = require("Rx")

local LoadingFrame = ReplicatedStorage.InterfaceToMount.OpeningScreen
local LocalPlayer = Players.LocalPlayer

local Service = {}
Service.ServiceName = script.Name

function Service:Init(serviceBag)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._evergreenScreenProvider = serviceBag:GetService(EvergreenScreenProvider)
	self._maid = Maid.new()
	self._view = BasicPane.new()

	--[=[
	When init is called, public observe function can't be accessed.
	We set visibility to true before other services begin to subscribe.
	]=]
	self._view:Show()
end

function Service:Start()
	self._screen = self._maid:Add(self:_mountScreen())
	self._view.Gui = self._maid:Add(self:_mountInterface(self._screen))
	self:_startCameraMovement()
end

function Service:ObserveUiVisible()
	return self._view:ObserveVisible()
end

function Service:CallWhenSaveToEnableInterface(callback)
	self._maid:GiveTask(self:ObserveUiVisible():Pipe({
		Rx.where(function(value)
			return value == false
		end)
	}):Subscribe(callback))
end

function Service:_mountScreen()
	local screen = self._evergreenScreenProvider:Get("LOADING_SCREEN") :: ScreenGui
	screen.IgnoreGuiInset = true
	return screen
end

function Service:_mountInterface(screen: ScreenGui)
	local gui = self:_render()
	gui.Parent = screen
	return gui
end

function Service:_render()
	self._maid:GiveTask(Blend.mount(LoadingFrame, {
		Visible = true,

		Blend.Find "Folder" {
			Name = "Content",

			Blend.Find "ImageButton" {
				Name = "PlayButton",

				[Blend.Tags] = 'UiButton',

				[Blend.OnEvent "MouseButton1Click"] = function()
					-- CAMERA MOVEMENT NEEDS TO STOP BEFORE ANYTHING ELSE
					self._view:Hide()
				end
			},

			Blend.Find "TextLabel" {
				Name = "PlayerName",
				Text = "@" .. LocalPlayer.DisplayName
			}
		},

		Blend.Find "ImageLabel" {
			Name = "CommunityLink",

			Blend.Find "TextLabel" {
				Name = "TitleText",
				Text = "Join our community @ discord.com/abcdefg"
			}
		}
	}))

	self:ObserveUiVisible():Subscribe(function(isVisible: boolean)
		self._screen.Enabled = isVisible
	end)

	return LoadingFrame
end

function Service:_startCameraMovement()
	-- HERE NOX
end

function Service:Destroy()
	self._maid:DoCleaning()
end

return Service