local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SkinConfig = require(ReplicatedStorage.Shared.SkinConfig)

local CharacterBuilder = {}

local function clearOldParts(character)
	for _, item in ipairs(character:GetChildren()) do
		if item:GetAttribute("GeneratedCharacterPart") then
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

local function addFace(character, skin)
	createPart("LeftEye", Enum.PartType.Ball, Vector3.new(0.18, 0.18, 0.18), Color3.fromRGB(20, 20, 24), character, Vector3.new(-0.32, 2.18, -0.72))
	createPart("RightEye", Enum.PartType.Ball, Vector3.new(0.18, 0.18, 0.18), Color3.fromRGB(20, 20, 24), character, Vector3.new(0.32, 2.18, -0.72))
	createPart("Nose", Enum.PartType.Ball, Vector3.new(0.22, 0.16, 0.14), skin.AccentColor, character, Vector3.new(0, 1.95, -0.82))
end

local function buildBase(character, skin, bodyScale)
	local bodySize = Vector3.new(1.9, 2.1, 1.15) * bodyScale
	createPart("CartoonBody", Enum.PartType.Ball, bodySize, skin.PrimaryColor, character, Vector3.new(0, 0.05, 0))
	createPart("CartoonHead", Enum.PartType.Ball, Vector3.new(1.45, 1.35, 1.35), skin.SecondaryColor, character, Vector3.new(0, 1.85, -0.05))
	createPart("Belly", Enum.PartType.Ball, Vector3.new(1.15, 1.25, 0.22), skin.SecondaryColor, character, Vector3.new(0, 0.05, -0.62))
	addFace(character, skin)
end

local function buildMomo(character, skin)
	buildBase(character, skin, 0.9)
	createPart("LeftMonkeyEar", Enum.PartType.Ball, Vector3.new(0.48, 0.48, 0.2), skin.PrimaryColor, character, Vector3.new(-0.82, 1.93, -0.05))
	createPart("RightMonkeyEar", Enum.PartType.Ball, Vector3.new(0.48, 0.48, 0.2), skin.PrimaryColor, character, Vector3.new(0.82, 1.93, -0.05))
	createPart("BananaBadge", Enum.PartType.Ball, Vector3.new(0.36, 0.18, 0.14), skin.AccentColor, character, Vector3.new(0, 0.65, -0.78))
	createPart("CurlyTail", Enum.PartType.Ball, Vector3.new(0.34, 0.34, 0.34), skin.PrimaryColor, character, Vector3.new(0, 0.35, 0.85))
end

local function buildPorinha(character, skin)
	buildBase(character, skin, 0.95)
	createPart("PigSnout", Enum.PartType.Ball, Vector3.new(0.58, 0.34, 0.32), skin.AccentColor, character, Vector3.new(0, 1.9, -0.93))
	createPart("LeftPigEar", Enum.PartType.Ball, Vector3.new(0.34, 0.52, 0.16), skin.PrimaryColor, character, Vector3.new(-0.56, 2.48, -0.05))
	createPart("RightPigEar", Enum.PartType.Ball, Vector3.new(0.34, 0.52, 0.16), skin.PrimaryColor, character, Vector3.new(0.56, 2.48, -0.05))
	createPart("HeartCheek", Enum.PartType.Ball, Vector3.new(0.16, 0.16, 0.08), skin.AccentColor, character, Vector3.new(0.48, 1.98, -0.86))
end

local function buildLeon(character, skin)
	buildBase(character, skin, 1.0)
	createPart("Mane", Enum.PartType.Ball, Vector3.new(1.85, 1.75, 1.15), skin.PrimaryColor, character, Vector3.new(0, 1.83, 0.02))
	createPart("FacePatch", Enum.PartType.Ball, Vector3.new(1.12, 1.0, 0.42), skin.SecondaryColor, character, Vector3.new(0, 1.92, -0.62))
	createPart("CrownGem", Enum.PartType.Ball, Vector3.new(0.28, 0.28, 0.18), skin.AccentColor, character, Vector3.new(0, 2.65, -0.18))
	createPart("TailTip", Enum.PartType.Ball, Vector3.new(0.36, 0.36, 0.36), skin.SecondaryColor, character, Vector3.new(0, 0.45, 0.9))
end

local function buildElly(character, skin)
	buildBase(character, skin, 1.12)
	createPart("Trunk", Enum.PartType.Ball, Vector3.new(0.42, 0.78, 0.38), skin.PrimaryColor, character, Vector3.new(0, 1.55, -0.98))
	createPart("LeftBigEar", Enum.PartType.Ball, Vector3.new(0.78, 0.96, 0.18), skin.SecondaryColor, character, Vector3.new(-0.88, 1.86, -0.05))
	createPart("RightBigEar", Enum.PartType.Ball, Vector3.new(0.78, 0.96, 0.18), skin.SecondaryColor, character, Vector3.new(0.88, 1.86, -0.05))
	createPart("CircusMark", Enum.PartType.Ball, Vector3.new(0.32, 0.32, 0.1), skin.AccentColor, character, Vector3.new(0, 0.78, -0.76))
end

local function buildSnapper(character, skin)
	buildBase(character, skin, 0.98)
	createPart("LongSnout", Enum.PartType.Block, Vector3.new(0.95, 0.35, 0.62), skin.SecondaryColor, character, Vector3.new(0, 1.9, -0.95))
	createPart("LeftTooth", Enum.PartType.Block, Vector3.new(0.12, 0.22, 0.08), Color3.fromRGB(255, 255, 235), character, Vector3.new(-0.28, 1.68, -1.27))
	createPart("RightTooth", Enum.PartType.Block, Vector3.new(0.12, 0.22, 0.08), Color3.fromRGB(255, 255, 235), character, Vector3.new(0.28, 1.68, -1.27))
	createPart("Tail", Enum.PartType.Block, Vector3.new(0.48, 0.34, 0.92), skin.PrimaryColor, character, Vector3.new(0, 0.25, 0.9))
end

local function buildGrumblet(character, skin)
	buildBase(character, skin, 0.82)
	createPart("Beak", Enum.PartType.Block, Vector3.new(0.5, 0.28, 0.38), skin.AccentColor, character, Vector3.new(0, 1.92, -0.96))
	createPart("LeftWing", Enum.PartType.Ball, Vector3.new(0.42, 0.88, 0.2), skin.PrimaryColor, character, Vector3.new(-0.95, 0.45, -0.05))
	createPart("RightWing", Enum.PartType.Ball, Vector3.new(0.42, 0.88, 0.2), skin.SecondaryColor, character, Vector3.new(0.95, 0.45, -0.05))
	createPart("HeadFeather", Enum.PartType.Ball, Vector3.new(0.28, 0.48, 0.18), skin.AccentColor, character, Vector3.new(0, 2.55, -0.05))
end

local builders = {
	Momo = buildMomo,
	Porinha = buildPorinha,
	Leon = buildLeon,
	Elly = buildElly,
	Snapper = buildSnapper,
	Grumblet = buildGrumblet,
}

function CharacterBuilder.Build(player, characterName, skinName)
	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	character.PrimaryPart = root
	clearOldParts(character)
	hideDefaultAvatar(character)

	local config = SkinConfig[characterName]
	if not config then return end

	local skin = config[skinName] or config.Default
	local builder = builders[characterName]

	if builder then
		builder(character, skin)
	else
		buildBase(character, skin, 1)
	end
end

return CharacterBuilder
