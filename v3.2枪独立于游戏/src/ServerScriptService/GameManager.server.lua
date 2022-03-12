local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uiEvent = ReplicatedStorage.Events.UIEvent
local timerText = ReplicatedStorage.Values.TimerText

local ServerStorage = game:GetService("ServerStorage")
local Ingredient = require(ServerStorage.Data.Ingredient)

local Players = game:GetService("Players")

-- Update Server's ScreenGUI is mainly for players' respawn
local timerTextLable = game:GetService("StarterGui").ScreenGui.Timer

local match = false

local function changeTimerText(timer)	
	local string = ""
	local osDate = os.date("!*t", timer)
	if timer >= 3600 then
		string = string..tostring(osDate.hour)..":"
	end
	string = string..tostring(osDate.min)..":"
	if osDate.sec < 10 then
		string =string.."0"
	end
	string = string..tostring(osDate.sec)
	timerText.Value = string
	-- Update Server's ScreenGUI is mainly for players' respawn
	timerTextLable.Text = string
end

local function restart(player)
	match = false
	Ingredient.reset()
	script.Parent.HandleIngredients.Disabled = true
	
	for _, child in pairs(workspace:GetChildren()) do
		if child.ClassName == "Tool" then
			child:Destroy()
		end
	end
	
	for _, player in pairs(Players:GetPlayers()) do
		player.leaderstats.Kills.Value = 0
		player.leaderstats.Ingredients.Value = 0
		player.leaderstats.Dishes.Value = 0
		player.leaderstats.Points.Value = 0
		player:LoadCharacter()
	end
	
	script.Parent.HandleIngredients.Disabled = false
	Ingredient.renew()
	
	local timer = 0
	changeTimerText(timer)
	local startTime = time()
	match = true
	
	while match do
		wait()
		if math.floor(time() - startTime) > timer then
			timer += 1
			changeTimerText(timer)
		end		
	end	
end

uiEvent.OnServerEvent:Connect(restart)