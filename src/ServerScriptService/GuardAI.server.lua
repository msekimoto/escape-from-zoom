local guard = script.Parent
local humanoid = guard:WaitForChild("Humanoid")
local root = guard:WaitForChild("HumanoidRootPart")

local Players = game:GetService("Players")

while task.wait(0.4) do
	local target
	local minDist = 50

	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local dist = (char.HumanoidRootPart.Position - root.Position).Magnitude
			if dist < minDist then
				minDist = dist
				target = char
			end
		end
	end

	if target then
		humanoid:MoveTo(target.HumanoidRootPart.Position)

		if minDist < 4 then
			local hum = target:FindFirstChild("Humanoid")
			if hum then hum:TakeDamage(20) end
		end
	end
end