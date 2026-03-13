local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

getgenv().MJ = getgenv().MJ or {}

MJ.SilentAim = false
MJ.FOV = 150

local Mouse = game.Players.LocalPlayer:GetMouse()

local Circle = Drawing.new("Circle")
Circle.Thickness = 2
Circle.Filled = false
Circle.Color = Color3.fromRGB(255,255,255)

RunService.RenderStepped:Connect(function()

    Circle.Position = Vector2.new(Mouse.X,Mouse.Y+36)
    Circle.Radius = MJ.FOV
    Circle.Visible = MJ.SilentAim

end)

return {
    Name = "Silent Aim",
    Category = "Combat",
    Enabled = false,

    Toggle = function(state)
        MJ.SilentAim = state
    end,

    Slider = {
        Name = "FOV",
        Min = 50,
        Max = 400,
        Increment = 10,
        Default = 150,

        Callback = function(v)
            MJ.FOV = v
        end
    }
}