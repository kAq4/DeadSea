local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

getgenv().MJ = getgenv().MJ or {}
MJ.ClickFling = false

local function Fling(target)

    local myChar = LocalPlayer.Character
    local targetChar = target.Character

    if not myChar or not targetChar then return end

    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

    if not myHRP or not targetHRP then return end

    local old = myHRP.CFrame
    local start = tick()

    while tick() - start < 2 do

        myHRP.CFrame = targetHRP.CFrame
        myHRP.AssemblyAngularVelocity = Vector3.new(0,9000,0)
        myHRP.AssemblyLinearVelocity = Vector3.new(9000,0,9000)

        RunService.Heartbeat:Wait()

    end

    myHRP.AssemblyAngularVelocity = Vector3.zero
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.CFrame = old

end

Mouse.Button1Down:Connect(function()

    if not MJ.ClickFling then return end

    if Mouse.Target then

        local model = Mouse.Target:FindFirstAncestorOfClass("Model")
        local player = Players:GetPlayerFromCharacter(model)

        if player then
            Fling(player)
        end

    end

end)

return {
    Name = "Click Fling",
    Category = "Combat",
    Enabled = false,

    Toggle = function(state)
        MJ.ClickFling = state
    end
}