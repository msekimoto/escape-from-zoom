local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local VisualEffects = {}

local function part(name, shape, size, color, cframe, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Shape = shape or Enum.PartType.Ball
	p.Size = size
	p.Color = color
	p.Material = material or Enum.Material.Neon
	p.CFrame = cframe
	p.Anchored = true
	p.CanCollide = false
	p.Transparency = 0.15
	p.Parent = workspace
	return p
end

function VisualEffects.Pulse(position, color, radius, duration)
	local pulse = part("AbilityPulse", Enum.PartType.Ball, Vector3.new(1, 1, 1), color, CFrame.new(position), Enum.Material.Neon)
	local light = Instance.new("PointLight")
	light.Color = color
	light.Range = radius
	light.Brightness = 2
	light.Parent = pulse

	local tween = TweenService:Create(
		pulse,
		TweenInfo.new(duration or 0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Size = Vector3.new(radius, radius, radius), Transparency = 1 }
	)
	tween:Play()
	Debris:AddItem(pulse, duration or 0.45)
end

function VisualEffects.Ring(position, color, radius, duration)
	local ring = part("AbilityRing", Enum.PartType.Cylinder, Vector3.new(0.25, 1, 1), color, CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90)), Enum.Material.Neon)
	local tween = TweenService:Create(
		ring,
		TweenInfo.new(duration or 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = Vector3.new(0.25, radius, radius), Transparency = 1 }
	)
	tween:Play()
	Debris:AddItem(ring, duration or 0.5)
end

function VisualEffects.Trail(root, color, duration)
	local a0 = Instance.new("Attachment")
	a0.Position = Vector3.new(0, 1, 0)
	a0.Parent = root

	local a1 = Instance.new("Attachment")
	a1.Position = Vector3.new(0, -1, 0)
	a1.Parent = root

	local trail = Instance.new("Trail")
	trail.Name = "AbilityTrail"
	trail.Attachment0 = a0
	trail.Attachment1 = a1
	trail.Color = ColorSequence.new(color)
	trail.Lifetime = 0.28
	trail.MinLength = 0.1
	trail.LightEmission = 0.8
	trail.Parent = root

	Debris:AddItem(trail, duration)
	Debris:AddItem(a0, duration)
	Debris:AddItem(a1, duration)
end

function VisualEffects.Billboard(position, text, color, duration)
	local anchor = part("FloatingTextAnchor", Enum.PartType.Ball, Vector3.new(0.2, 0.2, 0.2), color, CFrame.new(position), Enum.Material.Neon)
	anchor.Transparency = 1

	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromScale(5, 1.5)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	gui.Parent = anchor

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextScaled = true
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = color
	label.TextStrokeTransparency = 0.25
	label.Parent = gui

	Debris:AddItem(anchor, duration or 1.2)
end

function VisualEffects.Sparkles(parent, color, duration)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "AbilitySparkles"
	emitter.Color = ColorSequence.new(color)
	emitter.LightEmission = 0.8
	emitter.Rate = 35
	emitter.Lifetime = NumberRange.new(0.35, 0.65)
	emitter.Speed = NumberRange.new(4, 8)
	emitter.SpreadAngle = Vector2.new(360, 360)
	emitter.Parent = parent
	Debris:AddItem(emitter, duration or 1)
end

return VisualEffects
