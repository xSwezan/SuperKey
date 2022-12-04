local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SuperKey = require(ReplicatedStorage.Packages.MainModule)

local Flashlight = SuperKey:CreateBinding{Enum.KeyCode.F, Enum.KeyCode.E, {Enum.KeyCode.H, Enum.KeyCode.J}}
Flashlight.InputDown:Connect(function()
	print("FLASHLIGHT trigger")
end)
Flashlight.InputUp:Connect(function()
	print("FLASHLIGHT release")
end)