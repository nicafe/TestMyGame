local Ingredient = {}

local items = {
	{name = "Egg", image = "8909579941"},
	{name = "Eggplant", image = "1628764143"},
	{name = "Potato", image = "284959307"},
	{name = "Tomato", image = "1617121350"}
}

local ReplicatedStoreage = game:GetService("ReplicatedStorage")
local uiEvent = ReplicatedStoreage.Events.UIEvent

local GameSetup = require(script.Parent.GameSetup)
local ingredientNeeded = {}
local numberToGo = 0

-- Update Server's ScreenGUI is mainly for players' respawn
local ingredientsFrame = game:GetService("StarterGui").ScreenGui.IngredientsFrame

function Ingredient.renew()
	local params = {}
	local frame
	for i = 1, GameSetup.INGREDIENTS_FOR_EACH_DISH do
		local rand = math.random(#items)
		ingredientNeeded[i] = items[rand].name
		params[i] = items[rand]
		-- Update Server's ScreenGUI is mainly for players' respawn
		frame = ingredientsFrame:FindFirstChild("Frame"..i)
		frame.ImageLabel.Image = "rbxassetid://"..params[i].image
		frame.ImageLabel.ImageTransparency = 0
		frame.TextLabel.Text = params[i].name
		frame.TextLabel.TextTransparency = 0
	end
	numberToGo = GameSetup.INGREDIENTS_FOR_EACH_DISH
	uiEvent:FireAllClients({frames = params, status ="renew", number = GameSetup.INGREDIENTS_FOR_EACH_DISH})
end

function Ingredient.remove(tool, player)
	local i = table.find(ingredientNeeded, tool.Name)
	if i then
		ingredientNeeded[i] = "none"
		-- -- Update Server's ScreenGUI is mainly for players' respawn
		local frame = ingredientsFrame:FindFirstChild("Frame"..i)
		frame.ImageLabel.ImageTransparency = 0.6
		frame.TextLabel.TextTransparency = 0.7
		
		uiEvent:FireAllClients({status = "remove", index = i})
		tool:Destroy()
		player.leaderstats.Ingredients.Value += 1
		player.leaderstats.Points.Value += GameSetup.INGREDIENTS_POINTS
		numberToGo -= 1
		
		if numberToGo == 0 then
			player.leaderstats.Dishes.Value += 1
			player.leaderstats.Points.Value += GameSetup.DISHES_POINTS
			wait(GameSetup.NEW_DISH_TIME)
			Ingredient.renew()
		end
	end
end

function Ingredient:reset()
	ingredientNeeded = {}
	numberToGo = 0
	uiEvent:FireAllClients({status = "reset", number = GameSetup.INGREDIENTS_FOR_EACH_DISH})
end

return Ingredient