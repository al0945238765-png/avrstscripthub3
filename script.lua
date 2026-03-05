--------------------------------------------------
-- AVRST CYBER PREMIUM UI
--------------------------------------------------

local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--------------------------------------------------
-- COLOR THEME
--------------------------------------------------

local CYBER_BLUE = Color3.fromRGB(37, 99, 235)
local CYBER_PURPLE = Color3.fromRGB(168, 85, 247)
local CYBER_PINK = Color3.fromRGB(236, 72, 153)
local CYBER_GREEN = Color3.fromRGB(34, 197, 94)
local CYBER_ORANGE = Color3.fromRGB(249, 115, 22)

--------------------------------------------------
-- LANGUAGE SYSTEM
--------------------------------------------------

local CurrentLang = "TH"

local Lang = {
    TH = {
        Dashboard = "แดชบอร์ด 📊",
        Farming = "ฟาร์ม 🌾",
        Player = "ผู้เล่น 🧍",
        Settings = "ตั้งค่า ⚙️",
        StatusTitle = "สถานะระบบ 🚀",
        StatusDesc = "AVRST โหลดสำเร็จ ✅\nสถานะ : ออนไลน์\nโหมด : ออโต้",
        Unload = "ปิดสคริปต์ ❌",

        FlyOn = "วิธีบิน:\n- หันกล้องไปทิศทางที่ต้องการ\n- ตัวละครจะบินไปตามกล้อง\n- ปิด Fly เพื่อหยุดบิน",
        FlyOff = "โหมดบินถูกปิดแล้ว"
    },

    EN = {
        Dashboard = "Dashboard 📊",
        Farming = "Farming 🌾",
        Player = "Player 🧍",
        Settings = "Settings ⚙️",
        StatusTitle = "System Status 🚀",
        StatusDesc = "AVRST Loaded Successfully ✅\nStatus : Online\nMode : Automation",
        Unload = "Unload Script ❌",

        FlyOn = "How to Fly:\n- Look in the direction you want\n- Character flies toward camera\n- Turn off Fly to stop",
        FlyOff = "Fly mode disabled"
    }
}

--------------------------------------------------
-- WINDOW
--------------------------------------------------

local Window = WindUI:CreateWindow({
    Title = "🚀 AVRST Shop",
     Icon = "rbxassetid://124918340198545",
    Author = "Premium Automation System",
    Folder = "AVRST_PRO",
    Size = UDim2.fromScale(0.42,0.55),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 190,
})

Window:Tag({
    Title = "⚡ AVRST v0.0.9 BETA",
    Color = CYBER_PURPLE,
})

--------------------------------------------------
-- DASHBOARD
--------------------------------------------------

local Dashboard = Window:Tab({
    Title = Lang[CurrentLang].Dashboard,
    Icon = "home",
})

Dashboard:Select()

Dashboard:Paragraph({
    Title = Lang[CurrentLang].StatusTitle,
    Desc = Lang[CurrentLang].StatusDesc
})

--------------------------------------------------
-- FARMING TAB
--------------------------------------------------

local Farming = Window:Tab({
    Title = Lang[CurrentLang].Farming,
    Icon = "cpu",
})

--------------------------------------------------
-- PLAYER TAB
--------------------------------------------------

local PlayerTab = Window:Tab({
    Title = Lang[CurrentLang].Player,
    Icon = "user",
})

local FlyEnabled = false
local BodyVelocity
local BodyGyro

local SpeedValue = 20
local JumpValue = 50

--------------------------------------------------
-- WALK SPEED
--------------------------------------------------

PlayerTab:Slider({
    Title = "⚡ WalkSpeed",
    Min = 16,
    Max = 99999,
    Default = 20,
    Rounding = 0,
    Callback = function(v)
        SpeedValue = v
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = v
        end
    end
})

--------------------------------------------------
-- JUMP POWER
--------------------------------------------------

PlayerTab:Slider({
    Title = "🦘 JumpPower",
    Min = 50,
    Max = 99999,
    Default = 50,
    Rounding = 0,
    Callback = function(v)
        JumpValue = v
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = v
        end
    end
})

--------------------------------------------------
-- RESET WHEN RESPAWN
--------------------------------------------------

plr.CharacterAdded:Connect(function(char)

    local hum = char:WaitForChild("Humanoid")

    hum.WalkSpeed = SpeedValue
    hum.UseJumpPower = true
    hum.JumpPower = JumpValue

    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end

    FlyEnabled = false

end)

--------------------------------------------------
-- FLY SYSTEM
--------------------------------------------------

PlayerTab:Toggle({
    Title = "✈️ Fly",
    Default = false,
    Callback = function(v)

        FlyEnabled = v

        local char = plr.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if v then

            WindUI:Notify({
                Title = "✈️ Fly Enabled",
                Content = Lang[CurrentLang].FlyOn,
                Duration = 6,
                Icon = "zap",
            })

            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end

            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            BodyVelocity.Parent = hrp

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
            BodyGyro.Parent = hrp

        else

            WindUI:Notify({
                Title = "🛑 Fly Disabled",
                Content = Lang[CurrentLang].FlyOff,
                Duration = 3,
                Icon = "x",
            })

            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end

        end

    end
})

game:GetService("RunService").RenderStepped:Connect(function()

    if FlyEnabled and BodyVelocity and BodyGyro and plr.Character then

        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local cam = workspace.CurrentCamera

        BodyGyro.CFrame = cam.CFrame
        BodyVelocity.Velocity = cam.CFrame.LookVector * 60

    end

end)

--------------------------------------------------
-- SETTINGS TAB
--------------------------------------------------

local Settings = Window:Tab({
    Title = Lang[CurrentLang].Settings,
    Icon = "settings",
})

Settings:Button({
    Title = Lang[CurrentLang].Unload,
    Callback = function()
        WindUI:Destroy()
    end
})

Settings:Button({
    Title = "🌍 Switch Language",
    Callback = function()

        if CurrentLang == "TH" then
            CurrentLang = "EN"
        else
            CurrentLang = "TH"
        end

        WindUI:Notify({
            Title = "🌍 Language Changed",
            Content = "Re-run script to refresh text",
            Duration = 3
        })

    end
})

Settings:Dropdown({
    Title = "🎨 UI Theme",
    Values = {"Dark","Light"},
    Callback = function(v)
        Window:SetTheme(v)
    end
})
