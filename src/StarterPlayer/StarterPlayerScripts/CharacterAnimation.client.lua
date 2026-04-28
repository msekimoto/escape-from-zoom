local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local time = 0
local originalC0 = {}

local function getOriginalC0(weld)
	if not originalC0[weld] then
		originalC0[weld] = weld.C0
	end
	return originalC0[weld]
end

local function clearCacheForCharacter(character)
	for weld in pairs(originalC0) do
		if not weld:IsDescendantOf(character) then
			originalC0[weld] = nil
		end
	end
end

RunService.RenderStepped:Connect(function(dt)
	time += dt

	local character = player.Character
	if not character then return end

	clearCacheForCharacter(character)

	local root = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid then return end

	local speed = root.AssemblyLinearVelocity.Magnitude
	local isMoving = humanoid.MoveDirection.Magnitude > 0.05 and speed > 1

	local idleBob = math.sin(time * 2) * 0.035
	local walkBob = isMoving and math.abs(math.sin(time * 8)) * 0.12 or 0
	local sway = isMoving and math.sin(time * 6) * 0.045 or math.sin(time * 1.5) * 0.018
	local lean = isMoving and -0.08 or 0

	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("Weld") and descendant.Name == "CharacterVisualWeld" then
			local baseC0 = getOriginalC0(descendant)
			descendant.C0 = baseC0
				* CFrame.new(0, idleBob + walkBob, 0)
				* CFrame.Angles(lean, 0, sway)
		end
	end
end)
