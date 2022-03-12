local ContextActionService = game:GetService("ContextActionService")
local character = script.Parent

local function onAction(actionName, inputState, inputObject)
	if actionName == "DESTROY_ACTION" and inputState == Enum.UserInputState.Begin then		
		local tool = character:FindFirstChildWhichIsA("Tool")
		if tool and tool.Name ~= "Blaster" then
			tool:Destroy()
		end
	elseif actionName == "KILL_CHARACTER" and inputState == Enum.UserInputState.Begin then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Health = 0
		end
	end
end

ContextActionService:BindAction("DESTROY_ACTION", onAction, true, Enum.KeyCode.Q)
-- The following "KILL_CHARACTER" is for test purpose.
ContextActionService:BindAction("KILL_CHARACTER", onAction, true, Enum.KeyCode.Equals)