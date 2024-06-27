local require = require(script.Parent.loader).load(script)

local Blend = require("Blend")
local Binder = require("Binder")
local BaseObject = require("BaseObject")
local Rx = require("Rx")
local ButtonHighlightModel = require("ButtonHighlightModel")

local Component = setmetatable({}, BaseObject)
Component.__index = Component

function Component.new(robloxInstance: ImageButton)
	local self = setmetatable(BaseObject.new(robloxInstance), Component)

	self._buttonModel = self._maid:Add(ButtonHighlightModel.new())
	self._defaultImageTransparency = robloxInstance.ImageTransparency
	-- self._defaultFrameSize = robloxInstance.Size
	self._buttonModel:SetButton(robloxInstance)

	self.Gui = self:_render(robloxInstance)

	return self
end

function Component:_render(frame)
	Blend.mount(frame, {
		ImageTransparency = self._buttonModel:ObserveIsMouseOrTouchOver():Pipe({
			Rx.map(function(isHovering: boolean)
				if isHovering then
					return 0.5
				end
				return self._defaultImageTransparency
			end),
		}),
	})

	return frame
end

return Binder.new("UiButton", Component)
