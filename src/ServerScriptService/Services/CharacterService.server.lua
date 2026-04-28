local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterBuilder = require(script.Parent.CharacterBuilder)

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

local function applyCharacter(player)
	local characterName = player:GetAttribute("Character") or "Momo"
	local skinName = player:GetAttribute("Skin") or "Default"

	CharacterBuilder.Build(player, characterName, skinName)
end

selectRemote.OnServerEvent:Connect(function(player, characterName)
	if not VALID_CHARACTERS[characterName] then
		warn("Personagem inválido:", characterName)
		return
	end

	player:SetAttribute("Character", characterName)
	player:SetAttribute("Skin", "Default")

	print(player.Name .. " escolheu " .. characterName)

	-- Muito importante: reconstrói o visual imediatamente após a escolha.
	if player.Character then
		applyCharacter(player)
	end
end)

Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("Character", "Momo")
	player:SetAttribute("Skin", "Default")

	player.CharacterAdded:Connect(function()
		-- Espera o avatar padrão carregar completamente antes de esconder/substituir.
		task.wait(1.5)
		applyCharacter(player)
	end)
end)
