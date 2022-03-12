local ProximityPromptService = game:GetService("ProximityPromptService")
local ServerStorage = game:GetService("ServerStorage")
local Ingredient = require(ServerStorage.Data.Ingredient)

local function onPromptTriggered(promptObject, player)
	local ancestorModel = promptObject:FindFirstAncestorWhichIsA("Model")
	if ancestorModel.Name == "Cauldron" then
		local character = player.Character
		local tool = character:FindFirstChildWhichIsA("Tool")
		if tool then
			Ingredient.remove(tool, player)
		end
	end
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)