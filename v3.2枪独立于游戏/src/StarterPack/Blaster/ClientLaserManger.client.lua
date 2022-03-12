local Players = game:GetService("Players")
local blaster = script.Parent
local LaserRenderer = require(blaster:WaitForChild("LaserRenderer"))

local function createPlayerLaser(playerWhoShot, toolHandle, endPostion)
	if playerWhoShot ~= Players.LocalPlayer then
		LaserRenderer.createLaser(toolHandle, endPostion)
	end
end

blaster.LaserFired.OnClientEvent:Connect(createPlayerLaser)