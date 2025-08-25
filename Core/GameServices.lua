-- GameServices.lua
-- Centralized game service management
local GameServices = {}

-- Cache frequently used services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Export services
GameServices.Players = Players
GameServices.ReplicatedStorage = ReplicatedStorage
GameServices.CollectionService = CollectionService
GameServices.ProximityPromptService = ProximityPromptService
GameServices.VirtualInputManager = VirtualInputManager
GameServices.TeleportService = TeleportService
GameServices.HttpService = HttpService

-- LocalPlayer reference
GameServices.LocalPlayer = Players.LocalPlayer

-- Helper vector creation
GameServices.vector = {
    create = function(x, y, z)
        return Vector3.new(x, y, z)
    end
}

return GameServices
