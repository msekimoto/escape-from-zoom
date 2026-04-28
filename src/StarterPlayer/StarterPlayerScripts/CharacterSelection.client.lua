-- CINEMATIC CHARACTER SELECTION + TRANSITION
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local SelectCharacter = ReplicatedStorage:WaitForChild("CharacterRemotes"):WaitForChild("SelectCharacter")
local Characters3D = ReplicatedStorage:WaitForChild("Characters3D")

local characters = { "Momo", "Porinha", "Leon", "Elly", "Snapper", "Grumblet" }

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "CharacterSelectionGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
frame.Parent = gui

local fade = Instance.new("Frame")
fade.Size = UDim2.fromScale(1,1)
fade.BackgroundColor3 = Color3.new(0,0,0)
fade.BackgroundTransparency = 1
fade.ZIndex = 10
fade.Parent = gui

-- CAMERA SETUP
camera.CameraType = Enum.CameraType.Scriptable
camera.CFrame = CFrame.new(0,8,20, 0,0,0)

-- PREVIEW MODEL
local preview

local function showPreview(name)
	if preview then preview:Destroy() end
	local model = Characters3D:FindFirstChild(name)
	if not model then return end

	preview = model:Clone()
	preview.Parent = workspace

	local root = preview:FindFirstChild("HumanoidRootPart")
	if root then
		preview.PrimaryPart = root
		preview:SetPrimaryPartCFrame(CFrame.new(0,0,0))
	end

	for _,p in ipairs(preview:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Anchored = p.Name == "HumanoidRootPart"
		end
	end
end

-- GRID
local grid = Instance.new("Frame")
grid.Size = UDim2.fromScale(0.7,0.5)
grid.Position = UDim2.fromScale(0.15,0.3)
grid.BackgroundTransparency = 1
grid.Parent = frame

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.fromScale(0.3,0.4)
layout.CellPadding = UDim2.fromScale(0.05,0.08)
layout.Parent = grid

local selected

for _,name in ipairs(characters) do
	local b = Instance.new("TextButton")
	b.Text = name
	b.Parent = grid
	b.MouseButton1Click:Connect(function()
		selected = name
		showPreview(name)
	end)
end

-- PLAY BUTTON
local play = Instance.new("TextButton")
play.Text = "JOGAR"
play.Size = UDim2.fromScale(0.2,0.08)
play.Position = UDim2.fromScale(0.4,0.85)
play.Parent = frame

local function tween(obj,t,props)
	local tw = TweenService:Create(obj,TweenInfo.new(t),props)
	tw:Play()
	return tw
end

play.MouseButton1Click:Connect(function()
	if not selected then return end

	-- ZOOM CAMERA
	tween(camera,0.8,{CFrame = CFrame.new(0,3,8,0,0,0)})
	task.wait(0.8)

	-- FADE OUT
	fade.BackgroundTransparency = 1
	fade.Visible = true
	tween(fade,0.5,{BackgroundTransparency = 0})
	task.wait(0.5)

	-- SPAWN
	SelectCharacter:FireServer(selected)

	-- RESTORE CAMERA
	camera.CameraType = Enum.CameraType.Custom

	-- FADE IN
	tween(fade,0.8,{BackgroundTransparency = 1})
	task.wait(0.8)

	gui:Destroy()
end)

-- ROTATION
RunService.RenderStepped:Connect(function(dt)
	if preview and preview.PrimaryPart then
		preview:SetPrimaryPartCFrame(preview.PrimaryPart.CFrame * CFrame.Angles(0,dt,0))
	end
end)
