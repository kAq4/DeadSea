local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

getgenv().MJ = getgenv().MJ or {}
MJ.InfiniteJump = false

UIS.JumpRequest:Connect(function()

    if not MJ.InfiniteJump then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end

end)

return {
    Name = "Infinite Jump",
    Category = "Movement",
    Enabled = false,

    Toggle = function(state)
        MJ.InfiniteJump = state
    end
}