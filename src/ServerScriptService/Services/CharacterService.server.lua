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

	print("Aplicando personagem:", player.Name, characterName, skinName)
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

	-- Caminho mais confiável: força respawn para aplicar o visual após o avatar Roblox terminar de carregar.
	player:LoadCharacter()
end)

Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("Character", player:GetAttribute("Character") or "Momo")
	player:SetAttribute("Skin", player:GetAttribute("Skin") or "Default")

	player.CharacterAdded:Connect(function()
		-- Espera o Roblox carregar o avatar padrão antes de esconder/substituir.
		task.wait(1.5)
		applyCharacter(player)
	end)
end)
