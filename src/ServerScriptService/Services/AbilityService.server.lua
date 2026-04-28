local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AbilityConfig = require(ReplicatedStorage.Shared.AbilityConfig)

local AbilityService = {}
local cooldowns = {}

local DEFAULT_GUARD_SPEED = 16

local function getHumanoid(player)
	return player.Character and player.Character:FindFirstChildOfClass("Humanoid")
end

local function getRoot(player)
	return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function getGuardsFolder()
	return workspace:FindFirstChild("Guards")
end

local function getNearbyGuards(position, radius)
	local guards = {}
	local guardsFolder = getGuardsFolder()
	if not guardsFolder then
		return guards
	end

	for _, guard in ipairs(guardsFolder:GetChildren()) do
		local root = guard:FindFirstChild("HumanoidRootPart")
		local humanoid = guard:FindFirstChildOfClass("Humanoid")

		if root and humanoid and (root.Position - position).Magnitude <= radius then
			table.insert(guards, guard)
		end
	end

	return guards
end

local function temporarilySetGuardSpeed(guard, speed, duration)
	local humanoid = guard:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	humanoid.WalkSpeed = speed

	task.delay(duration, function()
		if humanoid and humanoid.Parent then
			humanoid.WalkSpeed = DEFAULT_GUARD_SPEED
		end
	end)
end

local function setCooldown(player, abilityName, cooldown)
	cooldowns[player] = cooldowns[player] or {}
	cooldowns[player][abilityName] = os.clock() + cooldown
end

local function isOnCooldown(player, abilityName)
	cooldowns[player] = cooldowns[player] or {}
	local expiresAt = cooldowns[player][abilityName]
	return expiresAt and os.clock() < expiresAt
end

function AbilityService.UseAbility(player, abilityName)
	local config = AbilityConfig[abilityName]
	if not config then return false end

	if isOnCooldown(player, abilityName) then
		return false
	end

	local humanoid = getHumanoid(player)
	local root = getRoot(player)
	if not humanoid or not root then return false end

	setCooldown(player, abilityName, config.Cooldown)

	if abilityName == "ClimbBoost" then
		local originalSpeed = humanoid.WalkSpeed
		local originalJumpPower = humanoid.JumpPower

		humanoid.WalkSpeed = originalSpeed + 8
		humanoid.JumpPower = originalJumpPower + 18

		task.delay(config.Duration, function()
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = originalSpeed
				humanoid.JumpPower = originalJumpPower
			end
		end)
	end

	if abilityName == "BananaDistraction" then
		local banana = Instance.new("Part")
		banana.Name = "BananaDistraction"
		banana.Size = Vector3.new(1, 1, 1)
		banana.Shape = Enum.PartType.Ball
		banana.Material = Enum.Material.Neon
		banana.Color = Color3.fromRGB(255, 232, 66)
		banana.Position = root.Position + root.CFrame.LookVector * 10
		banana.Anchored = true
		banana.CanCollide = false
		banana.Parent = workspace

		for _, guard in ipairs(getNearbyGuards(banana.Position, 35)) do
			local guardHumanoid = guard:FindFirstChildOfClass("Humanoid")
			if guardHumanoid then
				guardHumanoid:MoveTo(banana.Position)
			end
		end

		task.delay(config.Duration, function()
			if banana then banana:Destroy() end
		end)
	end

	if abilityName == "HealPulse" then
		for _, targetPlayer in ipairs(Players:GetPlayers()) do
			local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			local targetHumanoid = targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")

			if targetRoot and targetHumanoid and (targetRoot.Position - root.Position).Magnitude <= config.Radius then
				targetHumanoid.Health = math.min(targetHumanoid.MaxHealth, targetHumanoid.Health + config.HealAmount)
			end
		end
	end

	if abilityName == "ShieldBubble" then
		humanoid:SetAttribute("Shielded", true)

		task.delay(config.Duration, function()
			if humanoid and humanoid.Parent then
				humanoid:SetAttribute("Shielded", false)
			end
		end)
	end

	if abilityName == "RoarStun" then
		for _, guard in ipairs(getNearbyGuards(root.Position, config.Radius)) do
			temporarilySetGuardSpeed(guard, 0, config.Duration)
		end
	end

	if abilityName == "Dash" then
		root.AssemblyLinearVelocity = root.CFrame.LookVector * config.Power
	end

	if abilityName == "Stomp" then
		for _, guard in ipairs(getNearbyGuards(root.Position, config.Radius)) do
			temporarilySetGuardSpeed(guard, 6, config.Duration)
		end
	end

	if abilityName == "Knockback" then
		for _, guard in ipairs(getNearbyGuards(root.Position, config.Radius)) do
			local guardRoot = guard:FindFirstChild("HumanoidRootPart")
			if guardRoot then
				local direction = (guardRoot.Position - root.Position)
				if direction.Magnitude > 0 then
					guardRoot.AssemblyLinearVelocity = direction.Unit * config.Power
				end
			end
		end
	end

	if abilityName == "Bite" then
		for _, guard in ipairs(getNearbyGuards(root.Position, config.Range)) do
			temporarilySetGuardSpeed(guard, 0, config.Duration)
			break
		end
	end

	if abilityName == "WaterHide" then
		player.Character:SetAttribute("Hidden", true)

		task.delay(config.Duration, function()
			if player.Character then
				player.Character:SetAttribute("Hidden", false)
			end
		end)
	end

	if abilityName == "Scream" then
		for _, guard in ipairs(getNearbyGuards(root.Position, config.Radius)) do
			temporarilySetGuardSpeed(guard, 4, config.Duration)
		end
	end

	if abilityName == "SlowFeathers" then
		for _, guard in ipairs(getNearbyGuards(root.Position, config.Radius)) do
			temporarilySetGuardSpeed(guard, 8, config.Duration)
		end
	end

	return true
end

Players.PlayerRemoving:Connect(function(player)
	cooldowns[player] = nil
end)

return AbilityService
