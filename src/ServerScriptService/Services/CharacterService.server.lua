local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage:WaitForChild("CharacterRemotes")
local selectRemote = remotesFolder:WaitForChild("SelectCharacter")

local VALID_CHARACTERS = {
	Momo = true,
	Porinha = true,
	Leon = true,
	Elly = true,
	Snapper = true,
	Grumblet = true
}

selectRemote.OnServerEvent:Connect(function(player, characterName)
	if VALID_CHARACTERS[characterName] then
		player:SetAttribute("Character", characterName)
		print(player.Name .. " escolheu " .. characterName)
	end
end)
