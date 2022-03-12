local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uiEvent = ReplicatedStorage.Events.UIEvent
local button = script.Parent


local function onButtonActivated()
	uiEvent:FireServer()
end

button.Activated:Connect(onButtonActivated)