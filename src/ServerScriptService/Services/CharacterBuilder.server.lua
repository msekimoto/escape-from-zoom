local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SkinConfig = require(ReplicatedStorage.Shared.SkinConfig)

local CharacterBuilder = {}

local function createPart(name, size, color, parent, offset)
	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.Color = color
	part.Anchored = false
	part.CanCollide = false
	part.Parent = parent

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = parent.PrimaryPart
	weld.Part1 = part
	weld.Parent = part

	part.Position = parent.PrimaryPart.Position + offset

	return part
end

function CharacterBuilder.Build(player, characterName, skinName)
	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	character.PrimaryPart = root

	local config = SkinConfig[characterName]
	if not config then return end

	local skin = config[skinName] or config.Default

	-- Corpo simples estilizado
	createPart("Body", Vector3.new(2,2,1), skin.PrimaryColor, character, Vector3.new(0,0,0))
	createPart("Head", Vector3.new(1.5,1.5,1.5), skin.SecondaryColor, character, Vector3.new(0,2,0))
	createPart("Accent", Vector3.new(1,1,1), skin.AccentColor, character, Vector3.new(0,1,1))
end

return CharacterBuilder
