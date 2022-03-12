local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local tool = script.Parent
local LaserRenderer = require(tool:WaitForChild("LaserRenderer"))

local MAX_MOUSE_DISTANCE = 1000
local MAX_LASER_DISTANCE = 500
local FIRE_RATE = 0.3
local MOVE_SHOT_DELAY =0.2
local SHOT_MOVE_DELAY =0.2
local timeOfPreviousShot = 0

local function canShootWeapon()
	local currentTime = tick()
	if currentTime - timeOfPreviousShot < FIRE_RATE then
		return false
	else	
		return true
	end
end

local function getWorldMousePostion()
	local mouseLocation = UserInputService:GetMouseLocation()
	local screenToWorldRay = workspace.CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
	local directionVector = screenToWorldRay.Direction * MAX_MOUSE_DISTANCE
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {player.Character}
	local raycastResult = workspace:Raycast(screenToWorldRay.Origin, directionVector, raycastParams)
	
	if raycastResult then
		return raycastResult.Position
	else
		return screenToWorldRay.Origin + directionVector
	end
end

local function fireWeapon()
	local mouseLocation = getWorldMousePostion()
	
	--打枪的时候，Player也转向开枪方向
	local hrp = player.Character.HumanoidRootPart
	local playerOrientation = Vector3.new(mouseLocation.X, hrp.Position.Y, mouseLocation.Z)
	hrp.CFrame = CFrame.lookAt(hrp.Position, playerOrientation)
	--跑动中发的第一枪会等一会触发
	local humanoid = player.Character.Humanoid
	if hrp.Velocity.Magnitude > 0.1 then
		humanoid.WalkSpeed = 0
		wait(MOVE_SHOT_DELAY)
	end
	humanoid.WalkSpeed = 0

	local targetDirection = (mouseLocation - tool.Handle.FirePoint.WorldPosition).Unit
	local directionVector = targetDirection * MAX_LASER_DISTANCE
	local weaponRaycastParams = RaycastParams.new()
	weaponRaycastParams.FilterDescendantsInstances = {player.Character}
	local weaponRaycastResult = workspace:Raycast(tool.Handle.FirePoint.WorldPosition, directionVector, weaponRaycastParams)
	
	local hitPosition
	if weaponRaycastResult then
		hitPosition = weaponRaycastResult.Position
		
		local characterModel = weaponRaycastResult.Instance:FindFirstAncestorOfClass("Model")
		if characterModel then
			local humanoid = characterModel:FindFirstChild("Humanoid")
			if humanoid then				
				tool.DamageCharacter:FireServer(characterModel, hitPosition)
			end
		end
	else
		hitPosition = tool.Handle.FirePoint.WorldPosition + directionVector
	end
	
	timeOfPreviousShot = tick()
	tool.LaserFired:FireServer(hitPosition)
	LaserRenderer.createLaser(tool.Handle, hitPosition)	
	
	-- 打完枪会停一会才能继续跑
	while tick() - timeOfPreviousShot < SHOT_MOVE_DELAY do
		wait()
	end
	humanoid.WalkSpeed = 16
end

local function toolEquipped()
	tool.Handle.Equip:Play()
end

local function toolActivated()
	if canShootWeapon() then
		--tool.Handle.Activate:Play()
		fireWeapon()
	end
end

tool.Equipped:Connect(toolEquipped)
tool.Activated:Connect(toolActivated)