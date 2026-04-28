local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotesFolder = ReplicatedStorage:FindFirstChild("GameRemotes") or Instance.new("Folder")
remotesFolder.Name = "GameRemotes"
remotesFolder.Parent = ReplicatedStorage

local objectiveUpdated = remotesFolder:FindFirstChild("ObjectiveUpdated") or Instance.new("RemoteEvent")
objectiveUpdated.Name = "ObjectiveUpdated"
objectiveUpdated.Parent = remotesFolder

local gameFinished = remotesFolder:FindFirstChild("GameFinished") or Instance.new("RemoteEvent")
gameFinished.Name = "GameFinished"
gameFinished.Parent = remotesFolder

local objectivesFolder = workspace:WaitForChild("Objectives")
local exitGate = workspace:WaitForChild("ExitGate")

local total = 0
local completed = 0
local finished = false

local function broadcast()
	objectiveUpdated:FireAllClients(completed, total)
end

local function openExitGate()
	exitGate.CanCollide = false
	exitGate.Transparency = 0.65
	exitGate.Color = Color3.fromRGB(80, 255, 140)
end

for _, obj in ipairs(objectivesFolder:GetChildren()) do
	if obj:IsA("BasePart") then
		total += 1
		local prompt = obj:FindFirstChildOfClass("ProximityPrompt")

		if prompt then
			prompt.Triggered:Connect(function(player)
				if obj:GetAttribute("Completed") then return end

				obj:SetAttribute("Completed", true)
				completed += 1
				obj.Color = Color3.fromRGB(90, 255, 140)
				obj.Material = Enum.Material.Neon
				prompt.Enabled = false

				broadcast()

				if completed >= total then
					openExitGate()
				end
			end)
		end
	end
end

exitGate.Touched:Connect(function(hit)
	if finished or exitGate.CanCollide then return end

	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	finished = true
	gameFinished:FireAllClients("Victory", player.Name .. " abriu caminho para a fuga!")
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		objectiveUpdated:FireClient(player, completed, total)
	end)
end)

broadcast()
