local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

getgenv().MJ = getgenv().MJ or {}

MJ.ESP = false
MJ.Transparency = 0.5

RunService.RenderStepped:Connect(function()

    if not MJ.ESP then return end

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

            local h = p.Character:FindFirstChild("MJESP")

            if not h then
                h = Instance.new("Highlight")
                h.Name = "MJESP"
                h.Parent = p.Character
            end

            h.Enabled = MJ.ESP
            h.FillTransparency = MJ.Transparency
            h.FillColor = Color3.fromRGB(255,0,0)

        end
    end

end)

return {
    Name = "ESP",
    Category = "Visual",
    Enabled = false,

    Toggle = function(state)
        MJ.ESP = state
    end,

    Slider = {
        Name = "Transparency",
        Min = 0,
        Max = 1,
        Increment = 0.1,
        Default = 0.5,

        Callback = function(v)
            MJ.Transparency = v
        end
    }
}