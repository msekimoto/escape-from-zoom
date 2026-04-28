local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local currentCamera = workspace.CurrentCamera

local CharacterConfig = require(ReplicatedStorage.Shared.CharacterConfig)

local SelectCharacter = ReplicatedStorage
	:WaitForChild("CharacterRemotes")
	:WaitForChild("SelectCharacter")

local Characters3D = ReplicatedStorage:WaitForChild("Characters3D")

local characters = {
	"Leon",
	"Elly",
	"Porinha",
	"Momo",
	"Snapper",
	"Grumblet",
}

local characterDescriptions = {
	Leon = "Forte e corajoso. Ideal para distrair guardas e abrir caminho.",
	Elly = "Pesada e poderosa. Perfeita para quebrar obstáculos.",
	Porinha = "Pequena e ágil. Boa para suporte e sobrevivência.",
	Momo = "Rápido e esperto. Excelente para escalar e explorar.",
	Snapper = "Resistente e sorrateiro. Ótimo perto da água.",
	Grumblet = "Barulhento e reclamão. Especialista em causar confusão.",
}

local selectedCharacterName = nil
local previewModel = nil
local previewWorld = nil
local previewIdleTrack = nil
local previewRotation = 0
local previewTime = 0
local previewConnection = nil
local previewFocusPosition = Vector3.new(0, 4, 0)
local previewCameraDistance = 14
local previewCameraHeight = 4

local originalCameraType = currentCamera.CameraType
local originalCameraSubject = currentCamera.CameraSubject
local blurEffect = nil
local colorEffect = nil
local depthEffect = nil

local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local function createStroke(parent, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Transparency = transparency or 0
	stroke.Parent = parent
	return stroke
end

local function createLabel(parent, text, size, color, font)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	label.TextSize = size
	label.Font = font or Enum.Font.GothamBold
	label.TextWrapped = true
	label.Parent = parent
	return label
end

local function createButton(parent, text, backgroundColor, textColor)
	local button = Instance.new("TextButton")
	button.Text = text
	button.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
	button.TextSize = 18
	button.Font = Enum.Font.GothamBold
	button.AutoButtonColor = true
	button.BackgroundColor3 = backgroundColor
	button.Parent = parent
	createCorner(button, 14)
	createStroke(button, Color3.fromRGB(255, 255, 255), 1, 0.82)
	return button
end

local function enableCinematicCamera()
	originalCameraType = currentCamera.CameraType
	originalCameraSubject = currentCamera.CameraSubject

	currentCamera.CameraType = Enum.CameraType.Scriptable
	currentCamera.CFrame = CFrame.new(Vector3.new(0, 14, 26), Vector3.new(0, 7, 0))

	blurEffect = Instance.new("BlurEffect")
	blurEffect.Name = "CharacterSelectionBlur"
	blurEffect.Size = 14
	blurEffect.Parent = Lighting

	colorEffect = Instance.new("ColorCorrectionEffect")
	colorEffect.Name = "CharacterSelectionColor"
	colorEffect.Brightness = -0.04
	colorEffect.Contrast = 0.22
	colorEffect.Saturation = -0.18
	colorEffect.TintColor = Color3.fromRGB(205, 225, 212)
	colorEffect.Parent = Lighting

	depthEffect = Instance.new("DepthOfFieldEffect")
	depthEffect.Name = "CharacterSelectionDepth"
	depthEffect.FarIntensity = 0.45
	depthEffect.FocusDistance = 18
	depthEffect.InFocusRadius = 18
	depthEffect.NearIntensity = 0.08
	depthEffect.Parent = Lighting
end

local function disableCinematicCamera()
	currentCamera.CameraType = originalCameraType
	currentCamera.CameraSubject = originalCameraSubject

	if blurEffect then
		blurEffect:Destroy()
		blurEffect = nil
	end

	if colorEffect then
		colorEffect:Destroy()
		colorEffect = nil
	end

	if depthEffect then
		depthEffect:Destroy()
		depthEffect = nil
	end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CharacterSelectionGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

enableCinematicCamera()

local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(3, 6, 8)
overlay.BackgroundTransparency = 0.02
overlay.Parent = screenGui

local vignette = Instance.new("Frame")
vignette.Name = "Vignette"
vignette.Size = UDim2.fromScale(1, 1)
vignette.BackgroundTransparency = 1
vignette.Parent = overlay

local container = Instance.new("Frame")
container.Name = "Container"
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.fromScale(0.5, 0.5)
container.Size = UDim2.fromScale(0.9, 0.82)
container.BackgroundColor3 = Color3.fromRGB(12, 19, 24)
container.BackgroundTransparency = 0.03
container.Parent = overlay
createCorner(container, 28)
createStroke(container, Color3.fromRGB(74, 116, 91), 2, 0.08)

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 28)
padding.PaddingBottom = UDim.new(0, 28)
padding.PaddingLeft = UDim.new(0, 32)
padding.PaddingRight = UDim.new(0, 32)
padding.Parent = container

local title = createLabel(container, "ESCOLHA SEU ANIMAL", 34, Color3.fromRGB(241, 246, 239), Enum.Font.GothamBlack)
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 44)
title.Position = UDim2.fromOffset(0, 0)

local subtitle = createLabel(container, "Zoológico fechado. Luzes baixas. Escolha quem vai liderar a fuga.", 18, Color3.fromRGB(168, 191, 176), Enum.Font.Gotham)
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 34)
subtitle.Position = UDim2.fromOffset(0, 48)

local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.BackgroundTransparency = 1
leftPanel.Position = UDim2.fromOffset(0, 100)
leftPanel.Size = UDim2.new(0.58, -18, 1, -100)
leftPanel.Parent = container

local rightPanel = Instance.new("Frame")
rightPanel.Name = "PreviewPanel"
rightPanel.BackgroundColor3 = Color3.fromRGB(7, 12, 16)
rightPanel.Position = UDim2.new(0.58, 18, 0, 100)
rightPanel.Size = UDim2.new(0.42, -18, 1, -100)
rightPanel.Parent = container
createCorner(rightPanel, 22)
createStroke(rightPanel, Color3.fromRGB(116, 154, 128), 2, 0.2)

local grid = Instance.new("Frame")
grid.Name = "CharacterGrid"
grid.BackgroundTransparency = 1
grid.Size = UDim2.fromScale(1, 1)
grid.Parent = leftPanel

local layout = Instance.new("UIGridLayout")
layout.CellPadding = UDim2.fromOffset(16, 16)
layout.CellSize = UDim2.new(0.48, 0, 0.31, 0)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = grid

local previewPadding = Instance.new("UIPadding")
previewPadding.PaddingTop = UDim.new(0, 22)
previewPadding.PaddingBottom = UDim.new(0, 22)
previewPadding.PaddingLeft = UDim.new(0, 22)
previewPadding.PaddingRight = UDim.new(0, 22)
previewPadding.Parent = rightPanel

local previewTitle = createLabel(rightPanel, "Selecione um personagem", 28, Color3.fromRGB(255, 232, 180), Enum.Font.GothamBlack)
previewTitle.Name = "PreviewTitle"
previewTitle.Size = UDim2.new(1, 0, 0, 38)
previewTitle.Position = UDim2.fromOffset(0, 0)

local viewport = Instance.new("ViewportFrame")
viewport.Name = "CharacterViewport"
viewport.BackgroundColor3 = Color3.fromRGB(4, 8, 11)
viewport.BackgroundTransparency = 0
viewport.Position = UDim2.fromOffset(0, 52)
viewport.Size = UDim2.new(1, 0, 0.58, 0)
viewport.LightColor = Color3.fromRGB(255, 232, 190)
viewport.Ambient = Color3.fromRGB(18, 28, 35)
viewport.Parent = rightPanel
createCorner(viewport, 20)
createStroke(viewport, Color3.fromRGB(255, 232, 180), 1, 0.56)

local viewportCamera = Instance.new("Camera")
viewportCamera.Name = "PreviewCamera"
viewportCamera.FieldOfView = 34
viewportCamera.Parent = viewport
viewport.CurrentCamera = viewportCamera

local previewDescription = createLabel(rightPanel, "Escolha um card ao lado para visualizar o modelo 3D.", 15, Color3.fromRGB(209, 222, 214), Enum.Font.Gotham)
previewDescription.Name = "PreviewDescription"
previewDescription.Position = UDim2.new(0, 0, 0.68, 0)
previewDescription.Size = UDim2.new(1, 0, 0, 62)

local previewAbilities = createLabel(rightPanel, "", 15, Color3.fromRGB(132, 218, 162), Enum.Font.GothamBold)
previewAbilities.Name = "PreviewAbilities"
previewAbilities.Position = UDim2.new(0, 0, 0.79, 0)
previewAbilities.Size = UDim2.new(1, 0, 0, 56)

local playButton = createButton(rightPanel, "JOGAR", Color3.fromRGB(78, 122, 82), Color3.fromRGB(255, 255, 255))
playButton.Name = "PlayButton"
playButton.AnchorPoint = Vector2.new(0.5, 1)
playButton.Position = UDim2.new(0.5, 0, 1, 0)
playButton.Size = UDim2.new(1, 0, 0, 54)
playButton.Visible = false

local function createLightPart(parent, name, position, color, brightness, range)
	local lightPart = Instance.new("Part")
	lightPart.Name = name
	lightPart.Anchored = true
	lightPart.CanCollide = false
	lightPart.Transparency = 1
	lightPart.Size = Vector3.new(0.2, 0.2, 0.2)
	lightPart.CFrame = CFrame.new(position)
	lightPart.Parent = parent

	local light = Instance.new("PointLight")
	light.Color = color
	light.Brightness = brightness
	light.Range = range
	light.Shadows = true
	light.Parent = lightPart

	return lightPart
end

local function createPreviewStage()
	previewWorld = Instance.new("WorldModel")
	previewWorld.Name = "NightZooPreviewWorld"
	previewWorld.Parent = viewport

	local floor = Instance.new("Part")
	floor.Name = "WetConcreteFloor"
	floor.Anchored = true
	floor.CanCollide = false
	floor.Material = Enum.Material.Concrete
	floor.Color = Color3.fromRGB(21, 28, 27)
	floor.Size = Vector3.new(24, 0.35, 24)
	floor.CFrame = CFrame.new(0, -0.25, 0)
	floor.Parent = previewWorld

	local backFence = Instance.new("Part")
	backFence.Name = "ShadowFence"
	backFence.Anchored = true
	backFence.CanCollide = false
	backFence.Material = Enum.Material.Metal
	backFence.Color = Color3.fromRGB(13, 19, 20)
	backFence.Size = Vector3.new(18, 5, 0.25)
	backFence.CFrame = CFrame.new(0, 2.2, -6.5)
	backFence.Parent = previewWorld

	createLightPart(previewWorld, "WarmKeyLight", Vector3.new(-4.5, 7, 5), Color3.fromRGB(255, 210, 150), 3.6, 18)
	createLightPart(previewWorld, "ColdRimLight", Vector3.new(5, 5.5, -5), Color3.fromRGB(90, 160, 190), 2.8, 16)
	createLightPart(previewWorld, "LowDangerLight", Vector3.new(0, 1.4, 4.5), Color3.fromRGB(120, 32, 28), 1.2, 10)
end

local function stopPreviewAnimation()
	if previewIdleTrack then
		previewIdleTrack:Stop(0.2)
		previewIdleTrack:Destroy()
		previewIdleTrack = nil
	end
end

local function clearPreview()
	stopPreviewAnimation()

	if previewWorld then
		previewWorld:Destroy()
		previewWorld = nil
	end

	previewModel = nil
end

local function findIdleAnimation(model, characterName)
	local config = CharacterConfig[characterName]
	local configuredAnimationId = config and config.IdleAnimationId

	if configuredAnimationId then
		local animation = Instance.new("Animation")
		animation.AnimationId = configuredAnimationId
		return animation
	end

	local animation = model:FindFirstChild("IdleAnimation", true) or model:FindFirstChild("Idle", true)

	if animation and animation:IsA("Animation") then
		return animation
	end

	return nil
end

local function playPreviewIdleAnimation(model, characterName)
	local animation = findIdleAnimation(model, characterName)

	if not animation then
		return
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	local animator = nil

	if humanoid then
		animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
		animator.Parent = humanoid
	else
		local controller = model:FindFirstChildOfClass("AnimationController") or Instance.new("AnimationController")
		controller.Parent = model
		animator = controller:FindFirstChildOfClass("Animator") or Instance.new("Animator")
		animator.Parent = controller
	end

	previewIdleTrack = animator:LoadAnimation(animation)
	previewIdleTrack.Looped = true
	previewIdleTrack.Priority = Enum.AnimationPriority.Idle
	previewIdleTrack:Play(0.25)
end

local function fitPreviewCamera(model)
	local modelCFrame, modelSize = model:GetBoundingBox()
	local maxSize = math.max(modelSize.X, modelSize.Y, modelSize.Z)
	previewFocusPosition = modelCFrame.Position + Vector3.new(0, modelSize.Y * 0.1, 0)
	previewCameraDistance = math.clamp(maxSize * 1.9, 8, 22)
	previewCameraHeight = math.clamp(modelSize.Y * 0.25, 2, 8)

	viewportCamera.CFrame = CFrame.new(
		previewFocusPosition + Vector3.new(0, previewCameraHeight, previewCameraDistance),
		previewFocusPosition
	)
end

local function showCharacterPreview(characterName)
	selectedCharacterName = characterName
	clearPreview()
	createPreviewStage()

	local modelTemplate = Characters3D:FindFirstChild(characterName)

	previewTitle.Text = characterName
	previewDescription.Text = characterDescriptions[characterName] or "Personagem jogável."

	local config = CharacterConfig[characterName]
	local abilities = config and config.Abilities or {}
	previewAbilities.Text = "Habilidades: " .. table.concat(abilities, " / ")
	playButton.Visible = true

	if not modelTemplate then
		previewDescription.Text = "Modelo 3D não encontrado em ReplicatedStorage/Characters3D."
		return
	end

	previewModel = modelTemplate:Clone()
	previewModel.Name = characterName .. "Preview"
	previewModel.Parent = previewWorld

	local root = previewModel:FindFirstChild("HumanoidRootPart")
	if root then
		previewModel.PrimaryPart = root
		previewModel:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
	end

	for _, descendant in ipairs(previewModel:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
			descendant.CastShadow = true
			descendant.Anchored = descendant.Name == "HumanoidRootPart"
		end
	end

	previewRotation = 0
	previewTime = 0
	fitPreviewCamera(previewModel)
	playPreviewIdleAnimation(previewModel, characterName)
end

local function confirmCharacterSelection()
	if not selectedCharacterName then
		return
	end

	SelectCharacter:FireServer(selectedCharacterName)
	disableCinematicCamera()
	clearPreview()
	screenGui.Enabled = false
end

local function createCharacterCard(characterName, order)
	local config = CharacterConfig[characterName]
	local abilities = config and config.Abilities or {}

	local card = Instance.new("TextButton")
	card.Name = characterName .. "Card"
	card.LayoutOrder = order
	card.AutoButtonColor = true
	card.Text = ""
	card.BackgroundColor3 = Color3.fromRGB(25, 37, 43)
	card.Parent = grid
	createCorner(card, 18)
	createStroke(card, Color3.fromRGB(116, 154, 128), 1.5, 0.35)

	local cardPadding = Instance.new("UIPadding")
	cardPadding.PaddingTop = UDim.new(0, 14)
	cardPadding.PaddingBottom = UDim.new(0, 14)
	cardPadding.PaddingLeft = UDim.new(0, 14)
	cardPadding.PaddingRight = UDim.new(0, 14)
	cardPadding.Parent = card

	local nameLabel = createLabel(card, characterName, 24, Color3.fromRGB(255, 232, 180), Enum.Font.GothamBlack)
	nameLabel.Name = "CharacterName"
	nameLabel.Size = UDim2.new(1, 0, 0, 32)
	nameLabel.Position = UDim2.fromOffset(0, 0)

	local description = createLabel(card, characterDescriptions[characterName] or "Personagem jogável.", 14, Color3.fromRGB(205, 216, 209), Enum.Font.Gotham)
	description.Name = "Description"
	description.Size = UDim2.new(1, 0, 0, 50)
	description.Position = UDim2.fromOffset(0, 38)

	local abilityText = "Q/E: " .. table.concat(abilities, " / ")
	local abilitiesLabel = createLabel(card, abilityText, 13, Color3.fromRGB(132, 218, 162), Enum.Font.GothamBold)
	abilitiesLabel.Name = "Abilities"
	abilitiesLabel.Size = UDim2.new(1, 0, 0, 42)
	abilitiesLabel.Position = UDim2.fromOffset(0, 92)

	local buttonHint = createLabel(card, "Visualizar", 15, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold)
	buttonHint.Name = "ButtonHint"
	buttonHint.AnchorPoint = Vector2.new(0.5, 1)
	buttonHint.Position = UDim2.new(0.5, 0, 1, 0)
	buttonHint.Size = UDim2.new(1, 0, 0, 24)

	card.MouseButton1Click:Connect(function()
		showCharacterPreview(characterName)
	end)
end

playButton.MouseButton1Click:Connect(confirmCharacterSelection)

for index, characterName in ipairs(characters) do
	createCharacterCard(characterName, index)
end

showCharacterPreview(characters[1])

previewConnection = RunService.RenderStepped:Connect(function(deltaTime)
	if not screenGui.Enabled then
		return
	end

	previewTime += deltaTime

	if previewModel and previewModel.PrimaryPart then
		previewRotation += deltaTime * 0.55
		local subtleBreath = math.sin(previewTime * 1.5) * 0.04
		previewModel:SetPrimaryPartCFrame(CFrame.new(0, subtleBreath, 0) * CFrame.Angles(0, previewRotation, 0))

		local cameraSwayX = math.sin(previewTime * 0.45) * 0.55
		local cameraSwayY = math.sin(previewTime * 0.35) * 0.18
		viewportCamera.CFrame = CFrame.new(
			previewFocusPosition + Vector3.new(cameraSwayX, previewCameraHeight + cameraSwayY, previewCameraDistance),
			previewFocusPosition + Vector3.new(0, 0.35, 0)
		)
	end
end)

screenGui.Destroying:Connect(function()
	if previewConnection then
		previewConnection:Disconnect()
		previewConnection = nil
	end

	disableCinematicCamera()
	clearPreview()
end)
