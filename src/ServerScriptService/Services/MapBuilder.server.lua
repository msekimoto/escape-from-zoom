local MapBuilder = {}

local function createFolder(name, parent)
	local existing = parent:FindFirstChild(name)
	if existing then
		existing:Destroy()
	end

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

local function sign(name, text, position, parent)
	local board = part(name, Vector3.new(12, 5, 0.5), position, Color3.fromRGB(52, 42, 35), parent, Enum.Material.Wood)

	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.Parent = board

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(255, 238, 190)
	label.Font = Enum.Font.FredokaOne
	label.Parent = gui

	return board
end

local function objective(name, position, parent)
	local obj = part(name, Vector3.new(4, 4, 4), position, Color3.fromRGB(255, 196, 70), parent, Enum.Material.Neon)
	obj:SetAttribute("Completed", false)

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText = "Consertar"
	prompt.ObjectText = name
	prompt.HoldDuration = 1.5
	prompt.MaxActivationDistance = 12
	prompt.Parent = obj

	return obj
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
	root.Color = Color3.fromRGB(60, 60, 70)
	root.Parent = model

	local body = Instance.new("Part")
	body.Name = "GuardBody"
	body.Size = Vector3.new(2.4, 3, 1.2)
	body.Position = position + Vector3.new(0, 1.4, 0)
	body.Anchored = false
	body.CanCollide = false
	body.Color = Color3.fromRGB(80, 80, 95)
	body.Material = Enum.Material.SmoothPlastic
	body.Parent = model

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Shape = Enum.PartType.Ball
	head.Size = Vector3.new(1.4, 1.4, 1.4)
	head.Position = position + Vector3.new(0, 3.2, 0)
	head.Anchored = false
	head.CanCollide = false
	head.Color = Color3.fromRGB(30, 30, 35)
	head.Parent = model

	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = 10
	humanoid.Parent = model

	local weld1 = Instance.new("WeldConstraint")
	weld1.Part0 = root
	weld1.Part1 = body
	weld1.Parent = body

	local weld2 = Instance.new("WeldConstraint")
	weld2.Part0 = root
	weld2.Part1 = head
	weld2.Parent = head

	model.PrimaryPart = root
	return model
end

function MapBuilder.Build()
	local map = createFolder("Map", workspace)
	local objectives = createFolder("Objectives", workspace)
	local guards = createFolder("Guards", workspace)

	part("ZooGround", Vector3.new(220, 1, 220), Vector3.new(0, -1, 0), Color3.fromRGB(80, 145, 88), map, Enum.Material.Grass)

	-- Muros externos
	part("NorthWall", Vector3.new(220, 16, 4), Vector3.new(0, 7, -110), Color3.fromRGB(185, 170, 145), map, Enum.Material.Brick)
	part("SouthWall", Vector3.new(220, 16, 4), Vector3.new(0, 7, 110), Color3.fromRGB(185, 170, 145), map, Enum.Material.Brick)
	part("WestWall", Vector3.new(4, 16, 220), Vector3.new(-110, 7, 0), Color3.fromRGB(185, 170, 145), map, Enum.Material.Brick)
	part("EastWall", Vector3.new(4, 16, 220), Vector3.new(110, 7, 0), Color3.fromRGB(185, 170, 145), map, Enum.Material.Brick)

	-- Caminhos principais
	part("MainPath", Vector3.new(18, 0.25, 190), Vector3.new(0, -0.4, 0), Color3.fromRGB(210, 196, 160), map, Enum.Material.Sand)
	part("CrossPath", Vector3.new(190, 0.25, 18), Vector3.new(0, -0.35, 0), Color3.fromRGB(210, 196, 160), map, Enum.Material.Sand)

	-- Áreas do zoológico
	part("SavannahZone", Vector3.new(55, 0.35, 55), Vector3.new(-58, -0.2, -58), Color3.fromRGB(206, 178, 92), map, Enum.Material.Sand)
	part("JungleZone", Vector3.new(55, 0.35, 55), Vector3.new(58, -0.2, -58), Color3.fromRGB(45, 122, 70), map, Enum.Material.Grass)
	part("AquariumZone", Vector3.new(55, 0.35, 55), Vector3.new(-58, -0.2, 58), Color3.fromRGB(64, 145, 205), map, Enum.Material.SmoothPlastic)
	part("ReptileZone", Vector3.new(55, 0.35, 55), Vector3.new(58, -0.2, 58), Color3.fromRGB(85, 110, 68), map, Enum.Material.Ground)

	sign("EntranceSign", "ESCAPE FROM ZOOM", Vector3.new(0, 8, 96), map)
	sign("SavannahSign", "SAVANA", Vector3.new(-58, 4, -86), map)
	sign("JungleSign", "SELVA", Vector3.new(58, 4, -86), map)
	sign("AquariumSign", "AQUARIO", Vector3.new(-58, 4, 30), map)
	sign("ReptileSign", "REPTILARIO", Vector3.new(58, 4, 30), map)

	-- Decoração simples
	for i = 1, 18 do
		local x = math.random(-95, 95)
		local z = math.random(-95, 95)
		part("TreeTrunk", Vector3.new(2, 8, 2), Vector3.new(x, 3, z), Color3.fromRGB(106, 72, 42), map, Enum.Material.Wood)
		part("TreeTop", Vector3.new(8, 8, 8), Vector3.new(x, 10, z), Color3.fromRGB(45, 130, 65), map, Enum.Material.Grass)
	end

	objective("SavannahGenerator", Vector3.new(-58, 3, -58), objectives)
	objective("JunglePanel", Vector3.new(58, 3, -58), objectives)
	objective("AquariumPump", Vector3.new(-58, 3, 58), objectives)
	objective("ReptileLock", Vector3.new(58, 3, 58), objectives)

	local exitGate = part("ExitGate", Vector3.new(24, 14, 3), Vector3.new(0, 6, 111), Color3.fromRGB(220, 60, 60), workspace, Enum.Material.Metal)
	exitGate.Transparency = 0.15
	exitGate.CanCollide = true

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "PlayerSpawn"
	spawn.Size = Vector3.new(10, 1, 10)
	spawn.Position = Vector3.new(0, 1, 85)
	spawn.Anchored = true
	spawn.Color = Color3.fromRGB(80, 255, 140)
	spawn.Material = Enum.Material.Neon
	spawn.Parent = map

	createGuard("Guard_01", Vector3.new(0, 2, 0), guards)
	createGuard("Guard_02", Vector3.new(-35, 2, 25), guards)
	createGuard("Guard_03", Vector3.new(35, 2, -25), guards)
end

MapBuilder.Build()

return MapBuilder
