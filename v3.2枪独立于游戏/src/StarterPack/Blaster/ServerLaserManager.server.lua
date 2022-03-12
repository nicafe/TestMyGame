local blaster = script.Parent
local ServerStorage = game:GetService("ServerStorage")
local GameSetup = require(ServerStorage.Data.GameSetup) -- Game dependency for getting points according to the game rules.

local LASER_DAMAGE = 35
local MAX_HIT_PROXIMITY = 10

local function getPlayerToolHandle(player)
	local weapon = player.Character:FindFirstChildOfClass("Tool")
	if weapon then
		return weapon:FindFirstChild("Handle")
	end
end

local function isHitValid(playerFired, characterToDamage, hitPosition)
	local characterHitProximity = (characterToDamage.HumanoidRootPart.Position - hitPosition).Magnitude
	if characterHitProximity > MAX_HIT_PROXIMITY then
		return false
	end
	
	local toolHandle = getPlayerToolHandle(playerFired)
	if toolHandle then
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {playerFired.Character}
		local rayResult = workspace:Raycast(toolHandle.FirePoint.WorldPosition, hitPosition -toolHandle.FirePoint.WorldPosition, raycastParams)
		
		if rayResult and not rayResult.Instance:IsDescendantOf(characterToDamage) then
			return false
		end
	end
	
	return true
end

local function playerFiredLaser(playerFired, endPosition)
	local toolHandle = getPlayerToolHandle(playerFired)
	if toolHandle then
		blaster.LaserFired:FireAllClients(playerFired, toolHandle, endPosition)
	end
end


local function damageCharacter(playerFired, characterToDamage, hitPosition)
	local humanoid = characterToDamage:FindFirstChild("Humanoid")
	local validShot = isHitValid(playerFired, characterToDamage, hitPosition)
	if humanoid and validShot then
		humanoid:TakeDamage(LASER_DAMAGE)
		-- Game dependency for getting points according to the game rules.
		if humanoid.Health <= 0 then
			playerFired.leaderstats.Kills.Value += 1
			playerFired.leaderstats.Points.Value += GameSetup.KILLS_POINTS
		end
	end
end

blaster.DamageCharacter.onServerEvent:Connect(damageCharacter)
blaster.LaserFired.OnServerEvent:Connect(playerFiredLaser)