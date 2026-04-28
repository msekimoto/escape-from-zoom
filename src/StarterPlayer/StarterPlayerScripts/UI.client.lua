local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local objectiveCompleted = remotes:WaitForChild("ObjectiveCompleted")
local gameWon = remotes:WaitForChild("GameWon")

objectiveCompleted.OnClientEvent:Connect(function(done, total)
	print("Objetivos: "..done.."/"..total)
end)

gameWon.OnClientEvent:Connect(function(playerName)
	print(playerName.." venceu!")
end)