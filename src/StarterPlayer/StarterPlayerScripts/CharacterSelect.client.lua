local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:WaitForChild("CharacterRemotes"):WaitForChild("SelectCharacter")

-- Seleção temporária para testar o fluxo antes de criar a UI.
task.wait(2)

local characters = { "Momo", "Porinha", "Leon", "Elly", "Snapper", "Grumblet" }
local chosen = characters[math.random(1, #characters)]

print("Escolhido:", chosen)
remote:FireServer(chosen)
