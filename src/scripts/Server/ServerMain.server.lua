--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService.Evergreen:FindFirstChild("LoaderUtils", true).Parent
local require = require(loader).bootstrapGame(ServerScriptService.Evergreen)

local serviceBag = require("ServiceBag").new()
serviceBag:GetService(require("EvergreenService"))
serviceBag:Init()
serviceBag:Start()

