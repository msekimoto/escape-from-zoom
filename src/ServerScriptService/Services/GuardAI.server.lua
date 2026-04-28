local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local guards = workspace:WaitForChild("Guards")

local function getClosestPlayer(pos)
	local closest = nil
	local dist = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and not char:GetAttribute("Hidden") then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				local d = (root.Position - pos).Magnitude
				if d < dist then
					dist = d
					closest = root
				end
			end
		end
	end

	return closest
end

RunService.Heartbeat:Connect(function()
	for _, guard in ipairs(guards:GetChildren()) do
		local root = guard:FindFirstChild("HumanoidRootPart")
		local hum = guard:FindFirstChildOfClass("Humanoid")

		if root and hum then
			local target = getClosestPlayer(root.Position)

			if target and (target.Position - root.Position).Magnitude < 60 then
				hum:MoveTo(target.Position)
			end
		end
	end
end)
