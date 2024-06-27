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

-- function Component:_transformScaleByPercent(scale: UDim2, percent: number): UDim2
-- 	percent = percent - 100
-- 	return UDim2.fromScale(
-- 		(self._defaultFrameSize.X.Scale / 100) * percent,
-- 		(self._defaultFrameSize.Y.Scale / 100) * percent
-- 	)
--
-- end

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

		-- Size = self._buttonModel:ObserveIsPressed():Pipe({
		-- 	Rx.map(function(isPressed: boolean)
		-- 		if isPressed then
		-- 			return self:_transformScaleByPercent(self._defaultFrameSize, 1)
		-- 		end
		--
		-- 		return self._defaultFrameSize
		-- 	end)
		-- })
	})

	return frame
end

return Binder.new("UiButton", Component)
