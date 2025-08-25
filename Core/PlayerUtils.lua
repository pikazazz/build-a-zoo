-- PlayerUtils.lua
-- Player-related utility functions
local GameServices = require(script.Parent.GameServices)
local LocalPlayer = GameServices.LocalPlayer

local PlayerUtils = {}

-- Get player's assigned island name
function PlayerUtils.getAssignedIslandName()
    if not LocalPlayer then
        return nil
    end
    return LocalPlayer:GetAttribute("AssignedIslandName")
end

-- Get player's net worth
function PlayerUtils.getPlayerNetWorth()
    if not LocalPlayer then
        return 0
    end

    local attrValue = LocalPlayer:GetAttribute("NetWorth")
    if type(attrValue) == "number" then
        return attrValue
    end

    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local netWorthValue = leaderstats:FindFirstChild("NetWorth")
        if netWorthValue and type(netWorthValue.Value) == "number" then
            return netWorthValue.Value
        end
    end

    return 0
end

-- Get player's root position
function PlayerUtils.getPlayerRootPosition()
    local character = LocalPlayer and LocalPlayer.Character
    if not character then
        return nil
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end
    return hrp.Position
end

-- Get owned pet names
function PlayerUtils.getOwnedPetNames()
    local names = {}
    local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
    local data = playerGui and playerGui:FindFirstChild("Data")
    local petsContainer = data and data:FindFirstChild("Pets")

    if petsContainer then
        for _, child in ipairs(petsContainer:GetChildren()) do
            local name
            if child:IsA("ValueBase") then
                name = tostring(child.Value)
            else
                name = tostring(child.Name)
            end
            if name and name ~= "" then
                table.insert(names, name)
            end
        end
    end

    return names
end

-- Get player pet configurations
function PlayerUtils.getPlayerPetConfigurations()
    local petConfigs = {}

    if not LocalPlayer then
        return petConfigs
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return petConfigs
    end

    local data = playerGui:FindFirstChild("Data")
    if not data then
        return petConfigs
    end

    local petsFolder = data:FindFirstChild("Pets")
    if not petsFolder then
        return petConfigs
    end

    for _, petConfig in ipairs(petsFolder:GetChildren()) do
        if petConfig:IsA("Configuration") then
            table.insert(petConfigs, {
                name = petConfig.Name,
                config = petConfig
            })
        end
    end

    return petConfigs
end

-- Get pets in workspace
function PlayerUtils.getPlayerPetsInWorkspace()
    local petsInWorkspace = {}
    local playerPets = PlayerUtils.getPlayerPetConfigurations()
    local workspacePets = workspace:FindFirstChild("Pets")

    if not workspacePets then
        return petsInWorkspace
    end

    for _, petConfig in ipairs(playerPets) do
        local petModel = workspacePets:FindFirstChild(petConfig.name)
        if petModel and petModel:IsA("Model") then
            table.insert(petsInWorkspace, {
                name = petConfig.name,
                model = petModel,
                position = petModel:GetPivot().Position
            })
        end
    end

    return petsInWorkspace
end

-- Check if player owns an instance
function PlayerUtils.playerOwnsInstance(instance)
    if not instance then
        return false
    end

    local current = instance
    while current and current ~= workspace do
        if current.GetAttribute then
            local uidAttr = current:GetAttribute("UserId")
            if type(uidAttr) == "number" then
                return LocalPlayer and LocalPlayer.UserId == uidAttr
            end
            if type(uidAttr) == "string" then
                local userId = tonumber(uidAttr)
                return userId and LocalPlayer and LocalPlayer.UserId == userId
            end
        end
        current = current.Parent
    end

    return false
end

return PlayerUtils
