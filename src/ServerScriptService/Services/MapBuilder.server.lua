local Lighting = game:GetService("Lighting")

local MapBuilder = {}

local function setupAtmosphere()
	Lighting.ClockTime = 21
	Lighting.Brightness = 1.5
	Lighting.Ambient = Color3.fromRGB(60, 50, 82)
	Lighting.OutdoorAmbient = Color3.fromRGB(35, 32, 48)
	Lighting.FogColor = Color3.fromRGB(42, 38, 64)
	Lighting.FogStart = 45
	Lighting.FogEnd = 210

	local atmosphere = Lighting:FindFirstChild("ZooAtmosphere") or Instance.new("Atmosphere")
	atmosphere.Name = "ZooAtmosphere"
	atmosphere.Density = 0.38
	atmosphere.Offset = 0.2
	atmosphere.Color = Color3.fromRGB(138, 120, 190)
	atmosphere.Decay = Color3.fromRGB(45, 40, 70)
	atmosphere.Glare = 0.15
	atmosphere.Haze = 2.2
	atmosphere.Parent = Lighting
end

local function createFolder(name, parent)
	local existing = parent:FindFirstChild(name)
	if existing then existing:Destroy() end
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function part(name, size, position, color, parent, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = position
	p.Anchored = true
	p.Color = color
	p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

local function neonPart(name, size, position, color, parent)
	local p = part(name, size, position, color, parent, Enum.Material.Neon)
	local light = Instance.new("PointLight")
	light.Color = color
	light.Brightness = 1.7
	light.Range = 18
	light.Parent = p
	return p
end

local function sign(name, text, position, parent, color)
	local board = part(name, Vector3.new(14, 5.5, 0.5), position, Color3.fromRGB(42, 35, 58), parent, Enum.Material.SmoothPlastic)
	neonPart(name .. "GlowTop", Vector3.new(14.5, 0.25, 0.6), position + Vector3.new(0, 2.9, -0.05), color or Color3.fromRGB(255, 116, 195), parent)
	neonPart(name .. "GlowBottom", Vector3.new(14.5, 0.25, 0.6), position + Vector3.new(0, -2.9, -0.05), color or Color3.fromRGB(255, 116, 195), parent)

	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.LightInfluence = 0
	gui.Parent = board

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255, 242, 210)
	label.Font = Enum.Font.FredokaOne
	label.Parent = gui
	return board
end

local function fence(name, position, size, parent)
	local base = part(name, size, position, Color3.fromRGB(54, 50, 70), parent, Enum.Material.Metal)
	base.Transparency = 0.15
	return base
end

local function objective(name, position, parent, accent)
	local obj = neonPart(name, Vector3.new(4, 4, 4), position, accent or Color3.fromRGB(255, 210, 85), parent)
	obj.Shape = Enum.PartType.Ball
	obj:SetAttribute("Completed", false)

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Consertar"
	prompt.ObjectText = name
	prompt.HoldDuration = 1.5
	prompt.MaxActivationDistance = 12
	prompt.Parent = obj
	return obj
end

local function cartoonTree(parent, x, z)
	part("SquishyTreeTrunk", Vector3.new(2.2, 7, 2.2), Vector3.new(x, 2.5, z), Color3.fromRGB(86, 55, 48), parent, Enum.Material.Wood)
	local top = part("RoundTreeTop", Vector3.new(8, 8, 8), Vector3.new(x, 8, z), Color3.fromRGB(37, 110, 78), parent, Enum.Material.SmoothPlastic)
	top.Shape = Enum.PartType.Ball
end

local function createGuard(name, position, parent)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent

	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(2, 2, 1)
	root.Position = position
	root.Anchored = false
	root.CanCollide = true
	root.Transparency = 1
	root.Parent = model

	local body = Instance.new("Part")
	body.Name = "GuardBody"
	body.Shape = Enum.PartType.Ball
	body.Size = Vector3.new(2.6, 3.2, 1.4)
	body.Position = position + Vector3.new(0, 1.4, 0)
	body.Anchored = false
	body.CanCollide = false
	body.Color = Color3.fromRGB(72, 68, 92)
	body.Material = Enum.Material.SmoothPlastic
	body.Parent = model

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Shape = Enum.PartType.Ball
	head.Size = Vector3.new(1.5, 1.5, 1.5)
	head.Position = position + Vector3.new(0, 3.3, 0)
	head.Anchored = false
	head.CanCollide = false
	head.Color = Color3.fromRGB(24, 22, 32)
	head.Parent = model

	local eye1 = Instance.new("Part")
	eye1.Name = "GlowEyeL"
	eye1.Shape = Enum.PartType.Ball
	eye1.Size = Vector3.new(0.18, 0.18, 0.18)
	eye1.Position = position + Vector3.new(-0.25, 3.45, -0.7)
	eye1.Anchored = false
	eye1.CanCollide = false
	eye1.Color = Color3.fromRGB(255, 74, 104)
	eye1.Material = Enum.Material.Neon
	eye1.Parent = model

	local eye2 = eye1:Clone()
	eye2.Name = "GlowEyeR"
	eye2.Position = position + Vector3.new(0.25, 3.45, -0.7)
	eye2.Parent = model

	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = 10
	humanoid.Parent = model

	for _, p in ipairs({body, head, eye1, eye2}) do
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = root
		weld.Part1 = p
		weld.Parent = p
	end

	model.PrimaryPart = root
	return model
end

function MapBuilder.Build()
	setupAtmosphere()

	local map = createFolder("Map", workspace)
	local objectives = createFolder("Objectives", workspace)
	local guards = createFolder("Guards", workspace)

	part("DarkZooGround", Vector3.new(220, 1, 220), Vector3.new(0, -1, 0), Color3.fromRGB(44, 78, 65), map, Enum.Material.Grass)

	-- Muros externos com vibe parque fechado/abandonado
	part("NorthWall", Vector3.new(220, 18, 4), Vector3.new(0, 8, -110), Color3.fromRGB(58, 52, 78), map, Enum.Material.Brick)
	part("SouthWall", Vector3.new(220, 18, 4), Vector3.new(0, 8, 110), Color3.fromRGB(58, 52, 78), map, Enum.Material.Brick)
	part("WestWall", Vector3.new(4, 18, 220), Vector3.new(-110, 8, 0), Color3.fromRGB(58, 52, 78), map, Enum.Material.Brick)
	part("EastWall", Vector3.new(4, 18, 220), Vector3.new(110, 8, 0), Color3.fromRGB(58, 52, 78), map, Enum.Material.Brick)

	neonPart("NorthNeonRail", Vector3.new(210, 0.35, 0.35), Vector3.new(0, 17.5, -107.5), Color3.fromRGB(120, 96, 255), map)
	neonPart("SouthNeonRail", Vector3.new(210, 0.35, 0.35), Vector3.new(0, 17.5, 107.5), Color3.fromRGB(255, 96, 168), map)

	part("MainPath", Vector3.new(18, 0.25, 190), Vector3.new(0, -0.35, 0), Color3.fromRGB(124, 104, 126), map, Enum.Material.SmoothPlastic)
	part("CrossPath", Vector3.new(190, 0.25, 18), Vector3.new(0, -0.3, 0), Color3.fromRGB(124, 104, 126), map, Enum.Material.SmoothPlastic)

	-- Áreas com cores fortes e fofas, mas escuras
	part("SavannahZone", Vector3.new(55, 0.35, 55), Vector3.new(-58, -0.2, -58), Color3.fromRGB(156, 122, 64), map, Enum.Material.Sand)
	part("JungleZone", Vector3.new(55, 0.35, 55), Vector3.new(58, -0.2, -58), Color3.fromRGB(32, 100, 74), map, Enum.Material.Grass)
	part("AquariumZone", Vector3.new(55, 0.35, 55), Vector3.new(-58, -0.2, 58), Color3.fromRGB(42, 102, 145), map, Enum.Material.SmoothPlastic)
	part("ReptileZone", Vector3.new(55, 0.35, 55), Vector3.new(58, -0.2, 58), Color3.fromRGB(67, 88, 62), map, Enum.Material.Ground)

	-- Cercas internas
	fence("SavannahFence", Vector3.new(-58, 2, -28), Vector3.new(58, 4, 1), map)
	fence("JungleFence", Vector3.new(58, 2, -28), Vector3.new(58, 4, 1), map)
	fence("AquariumFence", Vector3.new(-58, 2, 28), Vector3.new(58, 4, 1), map)
	fence("ReptileFence", Vector3.new(58, 2, 28), Vector3.new(58, 4, 1), map)

	sign("EntranceSign", "ESCAPE FROM ZOOM", Vector3.new(0, 8, 96), map, Color3.fromRGB(255, 99, 178))
	sign("SavannahSign", "SAVANA", Vector3.new(-58, 4, -86), map, Color3.fromRGB(255, 198, 88))
	sign("JungleSign", "SELVA", Vector3.new(58, 4, -86), map, Color3.fromRGB(97, 255, 163))
	sign("AquariumSign", "AQUARIO", Vector3.new(-58, 4, 30), map, Color3.fromRGB(89, 214, 255))
	sign("ReptileSign", "REPTILARIO", Vector3.new(58, 4, 30), map, Color3.fromRGB(160, 255, 120))

	for i = 1, 24 do
		cartoonTree(map, math.random(-95, 95), math.random(-95, 95))
	end

	objective("SavannahGenerator", Vector3.new(-58, 3, -58), objectives, Color3.fromRGB(255, 198, 88))
	objective("JunglePanel", Vector3.new(58, 3, -58), objectives, Color3.fromRGB(97, 255, 163))
	objective("AquariumPump", Vector3.new(-58, 3, 58), objectives, Color3.fromRGB(89, 214, 255))
	objective("ReptileLock", Vector3.new(58, 3, 58), objectives, Color3.fromRGB(160, 255, 120))

	local exitGate = part("ExitGate", Vector3.new(24, 14, 3), Vector3.new(0, 6, 111), Color3.fromRGB(72, 42, 58), workspace, Enum.Material.Metal)
	exitGate.Transparency = 0.05
	exitGate.CanCollide = true
	neonPart("ExitGateGlow", Vector3.new(25, 0.5, 0.5), Vector3.new(0, 13.5, 109.2), Color3.fromRGB(255, 68, 120), workspace)

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "PlayerSpawn"
	spawn.Size = Vector3.new(10, 1, 10)
	spawn.Position = Vector3.new(0, 1, 85)
	spawn.Anchored = true
	spawn.Color = Color3.fromRGB(118, 255, 181)
	spawn.Material = Enum.Material.Neon
	spawn.Parent = map

	createGuard("Guard_01", Vector3.new(0, 2, 0), guards)
	createGuard("Guard_02", Vector3.new(-35, 2, 25), guards)
	createGuard("Guard_03", Vector3.new(35, 2, -25), guards)
end

MapBuilder.Build()

return MapBuilder
