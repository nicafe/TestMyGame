local Players = game:GetService("Players")


local function onPlayerAdded(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Value = 0
	kills.Parent = leaderstats
	
	local ingredients = Instance.new("IntValue")
	ingredients.Name = "Ingredients"
	ingredients.Value = 0
	ingredients.Parent = leaderstats
	
	local dishes = Instance.new("IntValue")
	dishes.Name = "Dishes"
	dishes.Value = 0
	dishes.Parent = leaderstats
	
	local points = Instance.new("IntValue")
	points.Name = "Points"
	points.Value = 0
	points.Parent = leaderstats
end

Players.PlayerAdded:Connect(onPlayerAdded)

