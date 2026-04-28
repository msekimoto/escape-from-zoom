local ReplicatedStorage = game:GetService("ReplicatedStorage")
local objectivesFolder = workspace:WaitForChild("Objectives")
local exitGate = workspace:WaitForChild("ExitGate")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local objectiveCompleted = remotes:WaitForChild("ObjectiveCompleted")

local total = 0
local done = 0

for _, obj in ipairs(objectivesFolder:GetChildren()) do
	if obj:IsA("BasePart") then
		total += 1

		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Consertar"
		prompt.HoldDuration = 2
		prompt.Parent = obj

		prompt.Triggered:Connect(function(player)
			if obj:GetAttribute("Done") then return end
			
			obj:SetAttribute("Done", true)
			done += 1

			obj.Color = Color3.fromRGB(0,255,0)

			objectiveCompleted:FireAllClients(done, total)

			if done >= total then
				exitGate.CanCollide = false
				exitGate.Transparency = 0.6
			end
		end)
	end
end