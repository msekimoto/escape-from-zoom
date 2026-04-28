local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterConfig = require(ReplicatedStorage.Shared.CharacterConfig)

local Remotes = ReplicatedStorage:WaitForChild("CharacterRemotes")
local SelectCharacter = Remotes:WaitForChild("SelectCharacter")

local Characters3D = ReplicatedStorage:WaitForChild("Characters3D")

local CharacterService = {}

local function getSpawnCFrame(player)
	local character = player.Character

	if character then
		local root = character:FindFirstChild("HumanoidRootPart")

		if root then
			return root.CFrame
		end
	end

	return CFrame.new(0, 10, 0)
end

local function validateCharacterModel(characterName, model)
	if not model then
		warn("Modelo 3D não encontrado:", characterName)
		return false
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		warn("Modelo precisa ter Humanoid e HumanoidRootPart:", characterName)
		return false
	end

	return true
end

function CharacterService.SpawnCharacter(player, characterName)
	if typeof(characterName) ~= "string" then
		warn("Nome de personagem inválido recebido de:", player.Name)
		return
	end

	if not CharacterConfig[characterName] then
		warn("Personagem não existe no CharacterConfig:", characterName)
		return
	end

	local modelTemplate = Characters3D:FindFirstChild(characterName)

	if not validateCharacterModel(characterName, modelTemplate) then
		return
	end

	local oldCharacter = player.Character
	local spawnCFrame = getSpawnCFrame(player)

	local newCharacter = modelTemplate:Clone()
	newCharacter.Name = player.Name

	local root = newCharacter:FindFirstChild("HumanoidRootPart")
	newCharacter.PrimaryPart = root
	newCharacter:SetPrimaryPartCFrame(spawnCFrame)
	newCharacter.Parent = workspace

	player.Character = newCharacter
	player:SetAttribute("SelectedCharacter", characterName)

	if oldCharacter and oldCharacter ~= newCharacter then
		oldCharacter:Destroy()
	end
end

SelectCharacter.OnServerEvent:Connect(function(player, characterName)
	CharacterService.SpawnCharacter(player, characterName)
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		local selectedCharacter = player:GetAttribute("SelectedCharacter")

		if selectedCharacter then
			task.defer(function()
				CharacterService.SpawnCharacter(player, selectedCharacter)
			end)
		end
	end)
end)

return CharacterService
