local MinX = -100
local MaxX = 100
local MinZ = -100
local MaxZ = 100
local y = -0.5

math.randomseed(tick())
while true do
	wait(0.5)
	local x = math.random(MinX, MaxX)
	local z = math.random(MinZ, MaxZ)
	while (x *x + z * z < 25) do
		x = math.random(MinX, MaxX)
		z = math.random(MinZ, MaxZ)
	end
	script.Parent.CFrame = CFrame.new(x, y, z)
end