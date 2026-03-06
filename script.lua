--------------------------------------------------
-- AVRST CYBER PREMIUM UI
--------------------------------------------------

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local CYBER_BLUE = Color3.fromRGB(37,99,235)

--------------------------------------------------
-- CREATE WINDOW
--------------------------------------------------

local Window = WindUI:CreateWindow({
    Title = "🚀 AVRST Shop",
    Icon = "rbxassetid://92450448348938",
    Author = "AVRST Premium Script",
    Folder = "AVRST_PRO",
    Size = UDim2.fromScale(0.42,0.55),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 190,
})

--------------------------------------------------
-- PLAYER INFO (BOTTOM LEFT)
--------------------------------------------------

if game.CoreGui:FindFirstChild("AVRST_PlayerInfo") then
    game.CoreGui.AVRST_PlayerInfo:Destroy()
end

local PlayerInfo = Instance.new("TextLabel")
PlayerInfo.Name = "AVRST_PlayerInfo"
PlayerInfo.Parent = game.CoreGui
PlayerInfo.Size = UDim2.new(0,260,0,45)
PlayerInfo.Position = UDim2.new(0,10,1,-55)

PlayerInfo.BackgroundTransparency = 0.2
PlayerInfo.BackgroundColor3 = Color3.fromRGB(20,20,20)

PlayerInfo.Text = "(ผู้เล่น: 🧑‍💼 "..plr.DisplayName..")\nไอดีผู้เล่น 🆔 "..plr.UserId
PlayerInfo.TextColor3 = CYBER_BLUE
PlayerInfo.TextScaled = true
PlayerInfo.Font = Enum.Font.GothamBold
PlayerInfo.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,8)
Corner.Parent = PlayerInfo

local Stroke = Instance.new("UIStroke")
Stroke.Color = CYBER_BLUE
Stroke.Thickness = 1.5
Stroke.Parent = PlayerInfo

--------------------------------------------------
-- TABS
--------------------------------------------------

local InfoTab = Window:Tab({
    Title = "ℹ️ ข้อมูล",
    Icon = "info",
})

local ProfileTab = Window:Tab({
    Title = "👤 โปรไฟล์",
    Icon = "user-circle",
})

local PlayerTab = Window:Tab({
    Title = "👤 Player",
    Icon = "user",
})

--------------------------------------------------
-- PROFILE TAB
--------------------------------------------------

ProfileTab:Paragraph({
    Title = "ชื่อผู้เล่น",
    Content = plr.Name
})

ProfileTab:Paragraph({
    Title = "Display Name",
    Content = plr.DisplayName
})

ProfileTab:Paragraph({
    Title = "User ID",
    Content = tostring(plr.UserId)
})

ProfileTab:Paragraph({
    Title = "อายุบัญชี",
    Content = tostring(plr.AccountAge).." วัน"
})

ProfileTab:Paragraph({
    Title = "Team",
    Content = plr.Team and plr.Team.Name or "ไม่มีทีม"
})

ProfileTab:Paragraph({
    Title = "ผู้เล่นในเซิร์ฟเวอร์",
    Content = tostring(#Players:GetPlayers())
})

--------------------------------------------------
-- INFO TAB
--------------------------------------------------

InfoTab:Paragraph({
    Title = "AVRST Shop",
    Content = "ยินดีต้อนรับสู่สคริปต์ AVRST Shop"
})

InfoTab:Paragraph({
    Title = "ผู้พัฒนา",
    Content = "Script by AVRST Shop"
})

InfoTab:Button({
    Title = "💬 Join Discord",
    Callback = function()

        if setclipboard then
            setclipboard("https://discord.gg/Fktbh2vJp")
        end

        WindUI:Notify({
            Title = "Discord",
            Content = "คัดลอกลิงก์ Discord แล้ว",
            Duration = 3
        })

    end
})

InfoTab:Button({
    Title = "🚀 ไปหน้า Player",
    Callback = function()

        Window:SelectTab(PlayerTab)

        WindUI:Notify({
            Title = "AVRST Shop",
            Content = "เข้าสู่หน้า Player แล้ว",
            Duration = 3
        })

    end
})

--------------------------------------------------
-- PLAYER SYSTEM
--------------------------------------------------

local SystemEnabled = false
local SpeedInput = 40
local JumpInput = 50
local InfiniteJump = false

local FlyEnabled = false
local BodyVelocity
local BodyGyro

--------------------------------------------------
-- เปิดระบบ
--------------------------------------------------

PlayerTab:Toggle({
    Title = "🟢 เปิดระบบ",
    Default = false,
    Callback = function(v)

        SystemEnabled = v

        WindUI:Notify({
            Title = "System",
            Content = v and "เปิดระบบแล้ว" or "ปิดระบบแล้ว",
            Duration = 3
        })

    end
})

--------------------------------------------------
-- SPEED
--------------------------------------------------

PlayerTab:Input({
    Title = "⛸️ วิ่งเร็ว",
    Default = "40",
    Placeholder = "ใส่ค่า Speed",
    Callback = function(v)
        SpeedInput = tonumber(v) or 40
    end
})

PlayerTab:Button({
    Title = "🔮 กดใช้ วิ่งเร็ว",
    Callback = function()

        if not SystemEnabled then return end

        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.WalkSpeed = SpeedInput
        end

    end
})

PlayerTab:Button({
    Title = "⭕ รีเซ็ต วิ่ง",
    Callback = function()

        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.WalkSpeed = 16
        end

    end
})

--------------------------------------------------
-- JUMP
--------------------------------------------------

PlayerTab:Input({
    Title = "🦵 โดดสูง",
    Default = "50",
    Placeholder = "ใส่ค่า Jump",
    Callback = function(v)
        JumpInput = tonumber(v) or 50
    end
})

PlayerTab:Button({
    Title = "🔮 กดใช้ โดดสูง",
    Callback = function()

        if not SystemEnabled then return end

        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = JumpInput
        end

    end
})

PlayerTab:Button({
    Title = "⭕ รีเซ็ต โดด",
    Callback = function()

        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.JumpPower = 50
        end

    end
})

--------------------------------------------------
-- INFINITE JUMP
--------------------------------------------------

PlayerTab:Toggle({
    Title = "🪄 กระโดดไม่จำกัด",
    Default = false,
    Callback = function(v)
        InfiniteJump = v
    end
})

UserInputService.JumpRequest:Connect(function()

    if InfiniteJump and SystemEnabled then

        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end

    end

end)

--------------------------------------------------
-- FLY
--------------------------------------------------

PlayerTab:Toggle({
    Title = "✈️ บิน",
    Default = false,
    Callback = function(v)

        if not SystemEnabled then return end

        FlyEnabled = v

        local char = plr.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if v then

            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            BodyVelocity.Parent = hrp

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
            BodyGyro.Parent = hrp

        else

            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end

        end

    end
})

RunService.RenderStepped:Connect(function()

    if FlyEnabled and BodyVelocity and BodyGyro then

        local cam = workspace.CurrentCamera

        BodyGyro.CFrame = cam.CFrame
        BodyVelocity.Velocity = cam.CFrame.LookVector * 60

    end

end)

--------------------------------------------------
-- RESPAWN FIX
--------------------------------------------------

plr.CharacterAdded:Connect(function(char)

    local hum = char:WaitForChild("Humanoid")

    if SystemEnabled then
        hum.WalkSpeed = SpeedInput
        hum.JumpPower = JumpInput
    end

end)
