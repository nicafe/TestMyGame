local LaserRenderer = {}

local SHOT_DURATION = 0.15

function LaserRenderer.createLaser(toolHandle, endPosition)
	local startPosition = toolHandle.FirePoint.WorldPosition
	local laserDistance = (startPosition - endPosition).Magnitude
	local laserCFrame = CFrame.lookAt(startPosition, endPosition) * CFrame.new(0, 0, -laserDistance / 2)
	
	local laserPart = Instance.new("Part")
	laserPart.Size = Vector3.new(0.2, 0.2,laserDistance)
	laserPart.CFrame = laserCFrame
	laserPart.Anchored = true
	laserPart.CanCollide = false
	laserPart.Color = Color3.fromRGB(255, 0, 0)
	laserPart.Material = Enum.Material.Neon
	laserPart.Parent = workspace
	
	game.Debris:AddItem(laserPart, SHOT_DURATION)
	
	local shootingSound = toolHandle:FindFirstChild("Activate")
	if shootingSound then
		shootingSound:Play()
	end
end

return LaserRenderer
