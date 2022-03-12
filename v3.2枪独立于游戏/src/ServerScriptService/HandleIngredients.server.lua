local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ingredients = ServerStorage.Ingredients

local connections = {}

local REGENERATION_TIME = 15
local START_SLOT = 1

-- Check if there is still room for picking an ingredient.
local function haveSlot(character, player)
	local i = 0

	local tool = character:FindFirstChildWhichIsA("Tool")
	if tool then
		i += 1
	end

	local backpack = player.Backpack
	i = i + #backpack:GetChildren() - 1

	if i < START_SLOT then
		return true
	else
		return false
	end
end

-- Check if the ingredient should be picked. If yes, pick it.
local function pick(otherPart, ingredient)
	local character = otherPart.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	local player = Players:GetPlayerFromCharacter(character)
	if humanoid and humanoid.Health > 0 and haveSlot(character, player) then
		ingredient.handle.Anchored = false
		ingredient.handle.Name = "Handle"
		ingredient.Parent = player.Backpack
		connections[ingredient]:Disconnect()
		return true
	else
		return false
	end
end

-- Generate a new piece of ingredient.
local function generate(ingredient)
	local clonedIngredient = ingredient:Clone()
	clonedIngredient.handle.Anchored = true
	clonedIngredient.Parent = workspace
	-- Add Touched Event.
	connections[clonedIngredient] = clonedIngredient.handle.Touched:Connect(function(otherPart)
		if pick(otherPart, clonedIngredient) then
			wait(REGENERATION_TIME)
			generate(ingredients:FindFirstChild(ingredient.Name))
		end
	end)
end

-- Setup ingredients at the beginning.
for _, ingredient in pairs(ingredients:GetChildren()) do
	generate(ingredient)
end


-- //////////////////////////////////////////////////
-- The following script is for dealing with dropped ingredients.

-- Drop an ingredient in front of characterCFrame and add Touched Event.
local function drop(ingredient, characterCFrame)
	ingredient.Parent = workspace
	ingredient.handle.CFrame = characterCFrame * CFrame.new(math.random(-4, 4), 4, -4)
	connections[ingredient] = ingredient.handle.Touched:Connect(function(otherPart)
		pick(otherPart, ingredient)
	end)
end

-- When a player drops an ingredient, destroy it because "Handle" comes to the workspace, and clone a new one instead.
workspace.ChildAdded:Connect(function (child)
	if child:IsA("Tool") and child.Name ~= "Blaster" then
		local handle = child:FindFirstChild("Handle")
		if handle then
			local ingredient = ingredients:FindFirstChild(child.Name):Clone()
			drop(ingredient, handle.CFrame)
			game:GetService("RunService").Heartbeat:Wait()
			child:Destroy()	
		end
	end
end)

-- Add Died Event for each Character.
local function onCharacterAdded(character, player)
	local humanoid = character:WaitForChild("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			local characterCFrame = character.HumanoidRootPart.CFrame
			local tool = character:FindFirstChildWhichIsA("Tool")
			if tool and tool.Name ~= "Blaster" then
				tool.Handle.Name = "handle"
				drop(tool, characterCFrame)
			end
			local backpack = player.Backpack
			for _, child in pairs(backpack:GetChildren()) do
				if child:IsA("Tool") and child.Name ~= "Blaster" then
					child.Handle.Name = "handle"
					drop(child, characterCFrame)
				end
			end
		end)
	end
end

local function onPlayerAdded(player)
	-- Check if they already spawned in
	if player.Character then
		onCharacterAdded(player.Character, player)
	end
	-- Listen for the player (re)spawning 
	player.CharacterAdded:Connect(function(character)
		onCharacterAdded(character, player)
	end)
end

-- Iterate over each player already connected
-- to the game using a generic for-loop
for i, player in pairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
-- Listen for newly connected players
Players.PlayerAdded:Connect(onPlayerAdded)