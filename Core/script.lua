--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

--------------------------------------------------
-- AUTO REINJECT
--------------------------------------------------

if not getgenv().DeadSeaInjected then
    getgenv().DeadSeaInjected = true
else
    MJ.AutoChest = true
end

--------------------------------------------------
-- UI
--------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
Name="DeadSea",
LoadingTitle="by MJ906 Team",
LoadingSubtitle="Private Edition",
Theme="Ocean",
ToggleUIKeybind="N"
})

--------------------------------------------------
-- GLOBAL SETTINGS
--------------------------------------------------

getgenv().MJ = {

ESP=false,
Transparency=0.5,

ClickFling=false,
FlingAura=false,
LoopFling=false,
OrbitFling=false,

SilentAim=false,
FOV=150,

Spin=false,
AutoToxic=false,

Speed=false,
WalkSpeed=16,

Fly=false,
InfiniteJump=false,

Godmode=false,
AntiFling=false,

PingSpoof=false,
Ping=0,

AdminDetector=false,
AutoServerHop=false,

Target=nil

}

--------------------------------------------------
-- ANTI AFK
--------------------------------------------------

LocalPlayer.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0,0),Camera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0),Camera.CFrame)
end)

--------------------------------------------------
-- PLAYER LIST
--------------------------------------------------

local function PlayerList()

local t={}

for _,p in pairs(Players:GetPlayers()) do
if p~=LocalPlayer then
table.insert(t,p.Name)
end
end

return t
end

--------------------------------------------------
-- VISUAL TAB
--------------------------------------------------

local Visual = Window:CreateTab("Visual","eye")

Visual:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(v)
        MJ.ESP = v
    end
})

Visual:CreateToggle({
    Name = "Name ESP",
    CurrentValue = false,
    Callback = function(v)
        MJ.NameESP = v
    end
})

Visual:CreateToggle({
    Name = "Distance ESP",
    CurrentValue = false,
    Callback = function(v)
        MJ.DistanceESP = v
    end
})

Visual:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Callback = function(v)
        MJ.Tracers = v
    end
})

Visual:CreateToggle({
    Name = "Rainbow ESP",
    CurrentValue = false,
    Callback = function(v)
        MJ.RainbowESP = v
    end
})

Visual:CreateSlider({
    Name = "ESP Transparency",
    Range = {0,1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Callback = function(v)
        MJ.Transparency = v
    end
})

--------------------------------------------------
-- ESP SYSTEM
--------------------------------------------------

RunService.RenderStepped:Connect(function()

for _,p in pairs(Players:GetPlayers()) do

    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

        local hrp = p.Character.HumanoidRootPart
        local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

        local h = p.Character:FindFirstChild("MJESP")

        if not h then
            h = Instance.new("Highlight")
            h.Name = "MJESP"
            h.Parent = p.Character
        end

        h.Enabled = MJ.ESP
        h.FillTransparency = MJ.Transparency

        if MJ.RainbowESP then
            h.FillColor = Color3.fromHSV(tick()%5/5,1,1)
        else
            h.FillColor = Color3.fromRGB(255,0,0)
        end

        local tag = hrp:FindFirstChild("MJTag")

        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = "MJTag"
            tag.Size = UDim2.new(0,100,0,40)
            tag.StudsOffset = Vector3.new(0,3,0)
            tag.Parent = hrp

            local text = Instance.new("TextLabel")
            text.Name = "Label"
            text.Size = UDim2.new(1,0,1,0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.new(1,1,1)
            text.TextStrokeTransparency = 0
            text.Parent = tag
        end

        local label = tag.Label

        if MJ.NameESP or MJ.DistanceESP then
            tag.Enabled = true

            local txt = ""

            if MJ.NameESP then
                txt = p.Name
            end

            if MJ.DistanceESP then
                txt = txt.." ["..math.floor(dist).."]"
            end

            label.Text = txt
        else
            tag.Enabled = false
        end

    end

end

end)

--------------------------------------------------
-- TRACERS lol 
--------------------------------------------------

local Tracers = {}

RunService.RenderStepped:Connect(function()

for _,p in pairs(Players:GetPlayers()) do

    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then

        local hrp = p.Character.HumanoidRootPart
        local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

        if not Tracers[p] then
            local line = Drawing.new("Line")
            line.Thickness = 1
            line.Color = Color3.fromRGB(255,255,255)
            line.Visible = false
            Tracers[p] = line
        end

        local line = Tracers[p]

        if MJ.Tracers and visible then
            line.Visible = true
            line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            line.To = Vector2.new(pos.X,pos.Y)
        else
            line.Visible = false
        end

    end

end

end)

Players.PlayerRemoving:Connect(function(p)
    if Tracers[p] then
        Tracers[p]:Remove()
        Tracers[p] = nil
    end
end)


-- Ultimate Fling Module: Always Invisible + Strong Fling
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--UI
local FlingTab = Window:CreateTab("Fling","refresh-cw")

-- Config
local Flinging = false
local FlingDuration = 2
local FlingSpeed = 9000
local FlingCooldown = 1.5
local AutoFlingRange = 15
local NukeDistance = 1000

-- MJ Settings
MJ = MJ or {}
MJ.ClickFling = MJ.ClickFling or false
MJ.LoopFling = MJ.LoopFling or false
MJ.FlingAura = MJ.FlingAura or false
MJ.CrashFling = MJ.CrashFling or false
MJ.AutoCrashFling = MJ.AutoCrashFling or false
MJ.Target = MJ.Target or nil

-- Make your character always invisible & untouchable
local function MakeAlwaysInvisible(char)
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end

-- Setup invisibility on spawn and respawn
local function SetupInvisibility()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    MakeAlwaysInvisible(char)
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        MakeAlwaysInvisible(newChar)
    end)
end
SetupInvisibility()

-- Get nearest player
local function GetNearestPlayer(range)
    local nearest
    local shortest = range
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local dist = (targetHRP.Position - myHRP.Position).Magnitude
            if dist < shortest then
                shortest = dist
                nearest = player
            end
        end
    end
    return nearest
end

-- Fling function
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local Flinging = false

-- Settings
local FlingDuration = 1        -- How long the fling lasts (seconds)
local FlingSpeed = 2000        -- Base fling speed
local NukeDistance = 5000      -- For crazy fling
local MJ = {CrashFling = false} -- Toggle for crazy fling

local function Fling(target)
    if Flinging or not target or target == LocalPlayer then return end

    local myChar = LocalPlayer.Character
    local targetChar = target.Character
    if not myChar or not targetChar then return end

    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not myHRP or not targetHRP then return end

    Flinging = true
    local oldCFrame = myHRP.CFrame
    local startTime = time()

    -- Calculate fling direction once
    local direction = (targetHRP.Position - myHRP.Position).Unit

    while targetHRP and time() - startTime < FlingDuration do
        targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP then break end

        if MJ.CrashFling then
            -- CRAZY fling: chaotic and server-crashy
            myHRP.CFrame = targetHRP.CFrame - direction * 2
            targetHRP.AssemblyLinearVelocity = direction * NukeDistance
            targetHRP.AssemblyAngularVelocity = Vector3.new(
                math.random(-20000,20000),
                math.random(-20000,20000),
                math.random(-20000,20000)
            )
        else
            -- NORMAL fling: fun and controlled
            myHRP.CFrame = targetHRP.CFrame + Vector3.new(0,0,0.5)
            local verticalBoost = math.random(2000, 4000)
            targetHRP.AssemblyLinearVelocity = direction * FlingSpeed + Vector3.new(0, verticalBoost, 0)
            targetHRP.AssemblyAngularVelocity = Vector3.new(
                math.random(-5000,5000),
                math.random(8000,12000),
                math.random(-5000,5000)
            )
        end

        RunService.Heartbeat:Wait()
    end

    -- Cleanup: reset velocities and position
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero
    myHRP.CFrame = oldCFrame
    Flinging = false
end

-- Click fling
Mouse.Button1Down:Connect(function()
    if not MJ.ClickFling then return end
    local mouseTarget = Mouse.Target
    if not mouseTarget then return end
    local model = mouseTarget:FindFirstAncestorOfClass("Model")
    local player = Players:GetPlayerFromCharacter(model)
    if player then Fling(player) end
end)

-- Auto / Loop fling
RunService.Heartbeat:Connect(function()
    if Flinging then return end
    if MJ.FlingAura or MJ.LoopFling then
        local target = GetNearestPlayer(AutoFlingRange)
        if target then Fling(target) end
    end
end)

-- Auto Server Crash Fling (all nearby players)
spawn(function()
    while true do
        task.wait(0.5)
        if not MJ.AutoCrashFling then continue end
        if not LocalPlayer.Character or Flinging then continue end

        local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end

        local targets = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = player.Character.HumanoidRootPart
                local dist = (targetHRP.Position - myHRP.Position).Magnitude
                if dist <= AutoFlingRange then
                    table.insert(targets, player)
                end
            end
        end

        for _, target in ipairs(targets) do
            Fling(target)
        end
    end
end)

--------------------------------------------------
-- COMBAT TAB
--------------------------------------------------

local Combat = Window:CreateTab("Combat","target")

Combat:CreateToggle({
Name="Silent Aim",
CurrentValue=false,
Callback=function(v)
MJ.SilentAim=v
end
})

Combat:CreateSlider({
Name="FOV",
Range={50,400},
Increment=10,
CurrentValue=150,
Callback=function(v)
MJ.FOV=v
end
})

Combat:CreateToggle({
Name="Hitbox Expander",
CurrentValue=false,
Callback=function(v)
MJ.Hitbox=v
end
})

Combat:CreateSlider({
Name="Hitbox Size",
Range={5,25},
Increment=1,
CurrentValue=1,
Callback=function(v)
HitboxSize=v
end
})

--------------------------------------------------
-- PROXY HITBOX EXPANDER
--------------------------------------------------

local Hitboxes = {}
local HitboxSize = 12

RunService.Heartbeat:Connect(function()

    if not MJ.Hitbox then
    
        -- remove hitboxes when disabled
        for _,v in pairs(Hitboxes) do
            if v then v:Destroy() end
        end
        table.clear(Hitboxes)
        return
        
    end

    for _,plr in ipairs(Players:GetPlayers()) do

        if plr ~= LocalPlayer and plr.Character then

            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")

            if hrp then

                if not Hitboxes[plr] then

                    local part = Instance.new("Part")
                    part.Name = "MJHitbox"
                    part.Size = Vector3.new(HitboxSize,HitboxSize,HitboxSize)
                    part.Transparency = 0.7
                    part.Color = Color3.fromRGB(255,0,0)
                    part.Material = Enum.Material.Neon
                    part.CanCollide = false
                    part.Massless = true
                    part.Parent = workspace

                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = part
                    weld.Part1 = hrp
                    weld.Parent = part

                    part.CFrame = hrp.CFrame

                    Hitboxes[plr] = part

                else
                    Hitboxes[plr].Size = Vector3.new(HitboxSize,HitboxSize,HitboxSize)
                end

            end

        end

    end

end)

--------------------------------------------------
-- FOV CIRCLE
--------------------------------------------------

local Circle=Drawing.new("Circle")
Circle.Thickness=2
Circle.Filled=false
Circle.Color=Color3.fromRGB(255,255,255)

RunService.RenderStepped:Connect(function()

Circle.Position=Vector2.new(Mouse.X,Mouse.Y+36)
Circle.Radius=MJ.FOV
Circle.Visible=MJ.SilentAim

end)

--------------------------------------------------
-- MOVEMENT TAB
--------------------------------------------------

local Movement = Window:CreateTab("Movement","zap")

Movement:CreateToggle({
Name="Speed",
CurrentValue=false,
Callback=function(v)
MJ.Speed=v
end
})

Movement:CreateSlider({
Name="WalkSpeed",
Range={16,600},
Increment=2,
CurrentValue=16,
Callback=function(v)
MJ.WalkSpeed=v
end
})

Movement:CreateToggle({
Name="Infinite Jump",
CurrentValue=false,
Callback=function(v)
MJ.InfiniteJump=v
end
})

--------------------------------------------------
-- SPEED SYSTEM
--------------------------------------------------

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    if not MJ.Speed then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hrp and hum then
        local moveDir = hum.MoveDirection

        if moveDir.Magnitude > 0 then
            local vel = hrp.Velocity
            hrp.Velocity = Vector3.new(
                moveDir.X * MJ.WalkSpeed,
                vel.Y,
                moveDir.Z * MJ.WalkSpeed
            )
        end
    end
end)
--------------------------------------------------
-- infinitejump fr
--------------------------------------------------

UIS.JumpRequest:Connect(function()
    if not MJ.InfiniteJump then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--------------------------------------------------
-- NETWORK TAB
--------------------------------------------------

local Network = Window:CreateTab("Network","activity")

Network:CreateToggle({
Name="Ping Spoofer",
CurrentValue=false,
Callback=function(v)

MJ.PingSpoof=v

if not v then
settings().Network.IncomingReplicationLag=0
end

end
})

Network:CreateSlider({
Name="Fake Ping",
Range={0,5000},
Increment=10,
CurrentValue=0,
Callback=function(v)

MJ.Ping=v

if MJ.PingSpoof then
settings().Network.IncomingReplicationLag=v/1000
end

end
})

--------------------------------------------------
-- PROTECTION TAB
--------------------------------------------------

local Protect = Window:CreateTab("Protection","lock")

Protect:CreateToggle({
Name="Godmode",
CurrentValue=false,
Callback=function(v)
MJ.Godmode=v
end
})

Protect:CreateToggle({
Name="Anti Fling",
CurrentValue=true,
Callback=function(v)
MJ.AntiFling=v
end
})

Protect:CreateToggle({
Name="Anti Hit",
CurrentValue=false,
Callback=function(v)
MJ.AntiHit=v
end
})

Protect:CreateToggle({
Name="Anti Drag",
CurrentValue=false,
Callback=function(v)
MJ.AntiDrag=v
end
})

--------------------------------------------------
-- SAFE ANTI DRAG
--------------------------------------------------

local DragClasses = {
    Weld = true,
    WeldConstraint = true,
    AlignPosition = true,
    AlignOrientation = true,
    BodyPosition = true,
    BodyGyro = true,
    BodyVelocity = true
}

RunService.Heartbeat:Connect(function()

    if not MJ.AntiDrag then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- remove drag constraints attached to your character
    for _,v in ipairs(hrp:GetChildren()) do
        if DragClasses[v.ClassName] then
            v:Destroy()
        end
    end

    -- cancel extreme drag velocity
    local vel = hrp.AssemblyLinearVelocity

    if vel.Magnitude > 120 then
        hrp.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

end)



local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    if not MJ.Godmode then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
end)

RunService.Heartbeat:Connect(function()
    if not MJ.AntiFling then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local velocity = hrp.Velocity.Magnitude

    -- detect fling velocity
    if velocity > 120 then
        
        -- freeze in air
        hrp.Anchored = true

        task.wait(0.5)

        -- unfreeze
        hrp.Anchored = false
        hrp.Velocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
end)

--------------------------------------------------
-- Bypassed ANTI FLING (keep y for bypassing)
--------------------------------------------------

local lastSafeXZ = nil
local flingCooldown = false

RunService.Heartbeat:Connect(function()

    if not MJ.AntiFling then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local velocity = hrp.AssemblyLinearVelocity.Magnitude

    -- save safe X/Z position
    if velocity < 60 then
        local pos = hrp.Position
        lastSafeXZ = Vector3.new(pos.X, 0, pos.Z)
    end

    -- detect fling velocity
    if velocity > 120 and not flingCooldown then

        flingCooldown = true

        -- freeze character
        hrp.Anchored = true

        -- remove physics forces
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        task.wait(0.25)

        -- restore X/Z but keep current Y
        if lastSafeXZ then
            local current = hrp.Position
            hrp.CFrame = CFrame.new(
                lastSafeXZ.X,
                current.Y,
                lastSafeXZ.Z
            )
        end

        task.wait(0.15)

        -- unfreeze
        hrp.Anchored = false

        -- cooldown to stop loops
        task.wait(1)

        flingCooldown = false
    end

end)

--------------------------------------------------
-- ADMIN DETECTOR
--------------------------------------------------

Players.PlayerAdded:Connect(function(p)

if MJ.AdminDetector then

Rayfield:Notify({
Title="Admin Joined",
Content=p.Name.." joined the server!",
Duration=6
})

if MJ.AutoServerHop then
TeleportService:Teleport(game.PlaceId)
end

end

end)

-- i hope this don't go public xD

--------------------------------------------------
-- ANTI HIT
--------------------------------------------------

local LastSafePos
local Cooldown = false

RunService.Heartbeat:Connect(function()

    if not MJ.AntiHit then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local velocity = hrp.AssemblyLinearVelocity.Magnitude

    -- save safe position
    if velocity < 60 then
        LastSafePos = hrp.Position
    end

    -- detect hit
    if velocity > 160 and not Cooldown then

        Cooldown = true

        -- cancel physics
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        -- teleport back
        if LastSafePos then
            hrp.CFrame = CFrame.new(LastSafePos)
        end

        task.wait(0.5)
        Cooldown = false

    end

end)

--------------------------------------------------
-- REAL ANTI HIT (Constant Offset + Movement Safe)
--------------------------------------------------

local OffsetA = CFrame.new(0.03,0,0.03)
local OffsetB = CFrame.new(-0.03,0,-0.03)

local Toggle = false

RunService.Heartbeat:Connect(function()

    if not MJ.AntiHit then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local vel = hrp.AssemblyLinearVelocity

    -- cancel spin forces
    hrp.AssemblyAngularVelocity = Vector3.zero

    -- cancel horizontal drag but keep vertical movement
    hrp.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)

    -- constant alternating offset (no drifting)
    if Toggle then
        hrp.CFrame = hrp.CFrame * OffsetA
    else
        hrp.CFrame = hrp.CFrame * OffsetB
    end

    Toggle = not Toggle

end)


--------------------------------------------------
-- AUTO CHEST TAB
--------------------------------------------------

local AutoChest = Window:CreateTab("Auto Chest","Box")
local VirtualInputManager = game:GetService("VirtualInputManager")

MJ.AutoChest = false
MJ.ChestESP = false

local ChestList = {}

--------------------------------------------------
-- CHEST SCANNER (runs every 2s, low lag)
--------------------------------------------------

local function ScanChests()

    table.clear(ChestList)

    for _,v in ipairs(workspace:GetDescendants()) do

        if v.Name == "Hitbox" and v:IsA("BasePart") then

            local model = v.Parent

            if model
            and model:FindFirstChild("Glow")
            and not v.Anchored
            and v.Size.Magnitude < 15 then

                table.insert(ChestList, v)

            end

        end

    end

end

task.spawn(function()

    while task.wait(2) do
        ScanChests()
    end

end)

--------------------------------------------------
-- GET CLOSEST CHEST
--------------------------------------------------

local function GetChest()

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closest
    local shortest = math.huge

    for _,chest in ipairs(ChestList) do

        local dist = (chest.Position - hrp.Position).Magnitude

        if dist < shortest then
            shortest = dist
            closest = chest
        end

    end

    return closest

end

--------------------------------------------------
-- CHEST ESP (very low lag)
--------------------------------------------------

task.spawn(function()

    while task.wait(2) do

        if not MJ.ChestESP then continue end

        for _,chest in ipairs(ChestList) do

            local model = chest.Parent

            if model and not model:FindFirstChild("ChestESP") then

                local h = Instance.new("Highlight")
                h.Name = "ChestESP"
                h.FillColor = Color3.fromRGB(255,255,0)
                h.FillTransparency = 0.3
                h.Parent = model

            end

        end

    end

end)

--------------------------------------------------
-- BREAK CHEST (grab → tp up → throw)
--------------------------------------------------

local function BreakChest()

    local chest = GetChest()
    local char = LocalPlayer.Character
    if not chest or not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- move to chest using velocity
    local direction = (chest.Position - hrp.Position).Unit

    hrp.AssemblyLinearVelocity = Vector3.new(
        direction.X * 120,
        0,
        direction.Z * 120
    )

    repeat task.wait()
    until (hrp.Position - chest.Position).Magnitude < 6

    hrp.AssemblyLinearVelocity = Vector3.zero

    -- look at chest
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, chest.Position)

    task.wait(0.15)

    -- MB1 grab
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)

    task.wait(0.2)

    -- go up using velocity
    hrp.AssemblyLinearVelocity = Vector3.new(0,150,0)

    task.wait(0.25)

    hrp.AssemblyLinearVelocity = Vector3.zero

    -- look down
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, chest.Position - Vector3.new(0,10,0))

    task.wait(0.1)

    -- MB2 throw
    VirtualInputManager:SendMouseButtonEvent(0,0,1,true,game,0)
    VirtualInputManager:SendMouseButtonEvent(0,0,1,false,game,0)

end

--------------------------------------------------
-- SERVER HOP
--------------------------------------------------

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local function ServerHop()

    Rayfield:Notify({
        Title = "DeadSea",
        Content = "No chests found. Server hopping...",
        Duration = 4,
        Image = "activity"
    })

    local servers = {}

    local req = game:HttpGet(
        "https://games.roblox.com/v1/games/17556820024/servers/Public?sortOrder=Asc&limit=100"
    )

    local data = HttpService:JSONDecode(req)

    for _,server in pairs(data.data) do
        if server.playing < server.maxPlayers
        and server.id ~= game.JobId then

            table.insert(servers, server.id)

        end
    end

    if #servers > 0 then

        TeleportService:TeleportToPlaceInstance(
            game.PlaceId,
            servers[math.random(1,#servers)],
            LocalPlayer
        )

    end

end
--------------------------------------------------
-- AUTO FARM LOOP
--------------------------------------------------

task.spawn(function()

    while task.wait(1.5) do

        if MJ.AutoChest then

            local chest = GetChest()

            if chest then
                BreakChest()
            else

                Rayfield:Notify({
                    Title = "DeadSea",
                    Content = "No chests found. Server hopping...",
                    Duration = 4,
                    Image = "activity"
                })

                task.wait(1)

                ServerHop()
                break

            end

        end

    end

end)

--------------------------------------------------
-- UI
--------------------------------------------------

AutoChest:CreateToggle({
Name = "Auto Chest Farm",
CurrentValue = false,
Callback = function(v)
MJ.AutoChest = v
end
})

AutoChest:CreateToggle({
Name = "Chest ESP",
CurrentValue = false,
Callback = function(v)
MJ.ChestESP = v
end
})

--------------------------------------------------
-- REINJECT AFTER TELEPORT
--------------------------------------------------

LocalPlayer.OnTeleport:Connect(function(State)

    if State == Enum.TeleportState.Started then

        queue_on_teleport([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/kAq4/DeadSea/refs/heads/main/Core/script.lua"))()
            getgenv().MJ.AutoChest = true
        ]])

    end

end)

-- i hope this don't go public xD FR FR DON"T LEAK THIS PART PLS, this is the only way to keep the auto farm working after teleport without users having to manually reinject :)
