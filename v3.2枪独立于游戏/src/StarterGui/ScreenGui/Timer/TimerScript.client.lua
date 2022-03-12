local ReplicatedStorage = game:GetService("ReplicatedStorage")
local timerText = ReplicatedStorage.Values.TimerText

local timer = script.Parent

local function changeTime()
	timer.Text = timerText.Value
end

timerText:GetPropertyChangedSignal("Value"):Connect(changeTime)