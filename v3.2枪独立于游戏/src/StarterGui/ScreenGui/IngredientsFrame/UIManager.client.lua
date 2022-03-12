local ReplicatedStoreage = game:GetService("ReplicatedStorage")
local uiEvent = ReplicatedStoreage.Events.UIEvent

local function processClientEvent(params)
	local frame
	if params.status == "renew" then
		for i = 1, params.number do
			frame = script.Parent:FindFirstChild("Frame"..i)
			frame.ImageLabel.Image = "rbxassetid://"..params.frames[i].image
			frame.ImageLabel.ImageTransparency = 0
			frame.TextLabel.Text = params.frames[i].name
			frame.TextLabel.TextTransparency = 0
		end
	elseif params.status == "remove" then
		frame = script.Parent:FindFirstChild("Frame"..params.index)
		frame.ImageLabel.ImageTransparency = 0.6
		frame.TextLabel.TextTransparency = 0.7
	elseif params.status == "reset" then
		for i = 1, params.number do
			frame = script.Parent:FindFirstChild("Frame"..i)
			frame.ImageLabel.Image = ""
			frame.TextLabel.Text = ""
		end
	end
end

uiEvent.OnClientEvent:Connect(processClientEvent)
