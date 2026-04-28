local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SkinConfig = require(ReplicatedStorage.Shared.SkinConfig)

local CharacterBuilder = {}

local function clearOldParts(character)
	for _, item in ipairs(character:GetChildren()) do
		if item:GetAttribute("GeneratedCharacterPart") or item:GetAttribute("ImportedCharacterModel") then
			item:Destroy()
		end
	end
end

local function hideDefaultAvatar(character)
	for _, item in ipairs(character:GetDescendants()) do
		if item:IsA("BasePart") and item.Name ~= "HumanoidRootPart" and not item:GetAttribute("GeneratedCharacterPart") then
			item.Transparency = 1
			item.CanCollide = false
		elseif item:IsA("Decal") then
			item.Transparency = 1
		end
	end

	for _, accessory in ipairs(character:GetChildren()) do
		if accessory:IsA("Accessory") then
			accessory:Destroy()
		end
	end
end

local function createPart(name, shape, size, color, character, offset)
	local part = Instance.new("Part")
	part.Name = name
	part.Shape = shape or Enum.PartType.Block
	part.Size = size
	part.Color = color
	part.Material = Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Anchored = false
	part.CanCollide = false
	part.Massless = true
	part:SetAttribute("GeneratedCharacterPart", true)
	part.Parent = character

	part.CFrame = character.PrimaryPart.CFrame * CFrame.new(offset)

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = character.PrimaryPart
	weld.Part1 = part
	weld.Parent = part

	return part
end

local function buildPorinha(character, skin)
	createPart("PorinhaBody", Enum.PartType.Ball, Vector3.new(2.2, 2.4, 1.6), skin.PrimaryColor, character, Vector3.new(0, 0.2, 0))
	createPart("PorinhaHead", Enum.PartType.Ball, Vector3.new(1.8, 1.6, 1.6), skin.SecondaryColor, character, Vector3.new(0, 2, 0))
	createPart("PorinhaSnout", Enum.PartType.Ball, Vector3.new(0.7, 0.5, 0.6), Color3.fromRGB(255, 170, 190), character, Vector3.new(0, 1.9, -0.9))
	createPart("PorinhaEarL", Enum.PartType.Ball, Vector3.new(0.4, 0.7, 0.2), skin.PrimaryColor, character, Vector3.new(-0.6, 2.6, 0))
	createPart("PorinhaEarR", Enum.PartType.Ball, Vector3.new(0.4, 0.7, 0.2), skin.PrimaryColor, character, Vector3.new(0.6, 2.6, 0))
	createPart("PorinhaDress", Enum.PartType.Block, Vector3.new(2.4, 1.2, 1.8), Color3.fromRGB(255, 120, 180), character, Vector3.new(0, -0.6, 0))
	createPart("PorinhaDressStripe", Enum.PartType.Block, Vector3.new(2.4, 0.2, 1.85), Color3.fromRGB(255, 200, 220), character, Vector3.new(0, -0.3, 0))
	createPart("PorinhaEyeL", Enum.PartType.Ball, Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(0, 0, 0), character, Vector3.new(-0.3, 2.1, -0.7))
	createPart("PorinhaEyeR", Enum.PartType.Ball, Vector3.new(0.2, 0.2, 0.2), Color3.fromRGB(0, 0, 0), character, Vector3.new(0.3, 2.1, -0.7))
end

local function buildFallback(character, characterName, skin)
	if characterName == "Porinha" then
		buildPorinha(character, skin)
		return
	end

	createPart(characterName .. "Body", Enum.PartType.Ball, Vector3.new(2, 2, 1.3), skin.PrimaryColor, character, Vector3.new(0, 0.15, 0))
	createPart(characterName .. "Head", Enum.PartType.Ball, Vector3.new(1.55, 1.45, 1.45), skin.SecondaryColor, character, Vector3.new(0, 1.95, 0))
end

-- 🔥 AUTO SCALE
local function scaleModelToHeight(model, targetHeight)
	local _, size = model:GetBoundingBox()
	local currentHeight = size.Y

	if currentHeight == 0 then return end

	local scale = targetHeight / currentHeight

	model:ScaleTo(scale)
end

local CHARACTER_SCALES = {
	Porinha = 5.2,
	Leon = 6,
	Elly = 6.5,
	Momo = 5,
	Snapper = 5.3,
	Grumblet = 4.8
}


local function tryAttachImportedModel(player, characterName)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return false end

	local modelsFolder = ReplicatedStorage:FindFirstChild("CharacterModels")
	if not modelsFolder then
		warn("CharacterModels não encontrado em ReplicatedStorage")
		return false
	end

	local sourceModel = modelsFolder:FindFirstChild(characterName)
	if not sourceModel or not sourceModel:IsA("Model") then
		warn("Modelo não encontrado:", characterName)
		return false
	end

	local clone = sourceModel:Clone()
	clone.Name = characterName .. "Model"
	clone:SetAttribute("ImportedCharacterModel", true)
	clone.Parent = character

	local modelRoot = clone.PrimaryPart or clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChildWhichIsA("BasePart", true)
	if not modelRoot then
		warn("Modelo importado sem BasePart:", characterName)
		clone:Destroy()
		return false
	end

	local target = CHARACTER_SCALES[characterName] or 5.5
	scaleModelToHeight(clone, target)

	clone.PrimaryPart = modelRoot
	clone:PivotTo(root.CFrame)

	for _, item in ipairs(clone:GetDescendants()) do
		if item:IsA("BasePart") then
			item.Anchored = false
			item.CanCollide = false
			item.Massless = true

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = root
			weld.Part1 = item
			weld.Parent = item
		end
	end

	print("Modelo importado aplicado:", characterName)
	return true
end

function CharacterBuilder.Build(player, characterName, skinName)
	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	print("CharacterBuilder.Build:", player.Name, characterName, skinName)
	character.PrimaryPart = root
	clearOldParts(character)
	hideDefaultAvatar(character)

	if tryAttachImportedModel(player, characterName) then
		return
	end

	local config = SkinConfig[characterName]
	if not config then return end

	local skin = config[skinName] or config.Default
	buildFallback(character, characterName, skin)
	print("Fallback procedural aplicado:", characterName)
end

return CharacterBuilder
