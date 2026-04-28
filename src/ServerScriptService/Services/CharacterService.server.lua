local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterConfig = require(ReplicatedStorage.Shared.CharacterConfig)
local CharacterBuilder = require(script.Parent:WaitForChild("CharacterBuilder"))

local Remotes = ReplicatedStorage:WaitForChild("CharacterRemotes")
local SelectCharacter = Remotes:WaitForChild("SelectCharacter")

local CharacterService = {}

local function applyCharacter(player)
	local characterName = player:GetAttribute("SelectedCharacter") or player:GetAttribute("Character") or "Momo"
	local skinName = player:GetAttribute("SelectedSkin") or player:GetAttribute("Skin") or "Default"

	if not CharacterConfig[characterName] then
		warn("Personagem não existe no CharacterConfig:", characterName)
		return
	end

	print("Aplicando personagem:", player.Name, characterName, skinName)
	CharacterBuilder.Build(player, characterName, skinName)
end

SelectCharacter.OnServerEvent:Connect(function(player, characterName)
	if typeof(characterName) ~= "string" then
		warn("Nome de personagem inválido recebido de:", player.Name)
		return
	end

	if not CharacterConfig[characterName] then
		warn("Personagem não existe no CharacterConfig:", characterName)
		return
	end

	player:SetAttribute("SelectedCharacter", characterName)
	player:SetAttribute("SelectedSkin", "Default")
	player:SetAttribute("Character", characterName)
	player:SetAttribute("Skin", "Default")

	print(player.Name .. " escolheu " .. characterName)

	-- Força respawn para aplicar o visual depois que o Roblox carregar o avatar padrão.
	player:LoadCharacter()
end)

Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("SelectedCharacter", player:GetAttribute("SelectedCharacter") or "Momo")
	player:SetAttribute("SelectedSkin", player:GetAttribute("SelectedSkin") or "Default")

	player.CharacterAdded:Connect(function()
		task.wait(1.5)
		applyCharacter(player)
	end)
end)

return CharacterService
