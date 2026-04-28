local ReplicatedStorage = game:GetService("ReplicatedStorage")
local exitGate = workspace:WaitForChild("ExitGate")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local gameWon = remotes:WaitForChild("GameWon")

exitGate.Touched:Connect(function(hit)
	local character = hit.Parent
	local player = game.Players:GetPlayerFromCharacter(character)

	if player and exitGate.CanCollide == false then
		gameWon:FireAllClients(player.Name)
	end
end)