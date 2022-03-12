local Texture = script.Parent.Texture
local Bubble = script.Parent.Bubble
local Frame = 0

spawn(function()
	while wait() do
		Texture.OffsetStudsU = Frame
		Texture.OffsetStudsV = Frame*2
		Texture.StudsPerTileU = 4 + (2 * math.cos(Frame))
		Texture.StudsPerTileV = 4 + (2 * math.cos(Frame))
		Frame = Frame + 0.005
	end
end)

spawn(function()
	while wait(math.random(1, 3)) do
		local myBub = Bubble:Clone()
		local angle = math.random(-math.pi, math.pi)
		local radius = math.random(0, 160) * 0.01
		myBub.Parent = script.Parent
		myBub.StudsOffsetWorldSpace = Vector3.new(-1, radius * math.cos(angle), radius * math.sin(angle))
		myBub.Enabled = true
		spawn(function()
			for i = 1, 50 do
				wait()
				myBub.StudsOffsetWorldSpace = myBub.StudsOffsetWorldSpace + Vector3.new(0.05, 0, 0)
			end
			for i = 1, 3 do
				wait()
				myBub.Size = UDim2.new(1 + i/3, 0, 1 + i/3, 0)
				myBub.Img.ImageTransparency = myBub.Img.ImageTransparency + 0.334
			end
			myBub:Destroy()
		end)
	end
end)