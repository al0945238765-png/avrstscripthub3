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
-- PLAYER TAB
--------------------------------------------------

local PlayerTab = Window:Tab({
    Title = Lang[CurrentLang].Player,
    Icon = "user",
})

local SystemEnabled = false
local SpeedInput = 40
local JumpInput = 50
local InfiniteJump = false

local FlyEnabled = false
local BodyVelocity
local BodyGyro

--------------------------------------------------
-- INFO TAB (FIRST PAGE)
--------------------------------------------------

local InfoTab = Window:Tab({
    Title = "ℹ️ ข้อมูล",
    Icon = "info",
})

InfoTab:Button({
    Title = "💬 Join Discord",
    Callback = function()

        if setclipboard then
            setclipboard("https://discord.gg/d4RK49MsJ")
        end

        WindUI:Notify({
            Title = "Discord",
            Content = "ลิงก์ถูกคัดลอกแล้ว",
            Duration = 3
        })
    end
})

InfoTab:Paragraph({
    Title = "AVRST Shop",
    Content = "ยินดีต้อนรับสู่สคริปต์ AVRST Shop"
})

InfoTab:Paragraph({
    Title = "วิธีใช้",
    Content = "1. เปิดระบบ Player\n2. ปรับ Speed / Jump\n3. ใช้งานฟีเจอร์ต่างๆ"
})

InfoTab:Paragraph({
    Title = "ผู้พัฒนา",
    Content = "Script by AVRST Shop"
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
-- เปิดระบบ
--------------------------------------------------

PlayerTab:Toggle({
    Title = "🟢 เปิดระบบ",
    Default = false,
    Callback = function(v)

        SystemEnabled = v

        if v then
            WindUI:Notify({
                Title = "System Enabled",
                Content = "ระบบ Player เปิดแล้ว",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "System Disabled",
                Content = "ระบบ Player ปิดอยู่",
                Duration = 3
            })
        end

    end
})

--------------------------------------------------
-- วิ่งเร็ว
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

        if not SystemEnabled then
            WindUI:Notify({
                Title = "System Off",
                Content = "ต้องเปิดระบบก่อน",
                Duration = 3
            })
            return
        end

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
-- โดดสูง
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

        if not SystemEnabled then
            WindUI:Notify({
                Title = "System Off",
                Content = "ต้องเปิดระบบก่อน",
                Duration = 3
            })
            return
        end

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
            hum.UseJumpPower = true
            hum.JumpPower = 50
        end

    end
})

--------------------------------------------------
-- กระโดดไม่จำกัด
--------------------------------------------------

PlayerTab:Toggle({
    Title = "🪄 กระโดดไม่จำกัด",
    Default = false,
    Callback = function(v)
        InfiniteJump = v
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()

    if InfiniteJump and SystemEnabled then

        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end

    end

end)

PlayerTab:Toggle({
    Title = "✈️ บิน",
    Default = false,
    Callback = function(v)

        if not SystemEnabled then
            WindUI:Notify({
                Title = "System Off",
                Content = "ต้องเปิดระบบก่อน",
                Duration = 3
            })
            return
        end

        FlyEnabled = v

        local char = plr.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if v then

            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end

            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
            BodyVelocity.Parent = hrp

            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
            BodyGyro.Parent = hrp

            WindUI:Notify({
                Title = "Fly Enabled",
                Content = "หันกล้องไปทางที่ต้องการบิน",
                Duration = 4
            })

        else

            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end

        end

    end
})

--------------------------------------------------
-- FLY MOVEMENT
--------------------------------------------------

local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()

    if FlyEnabled and BodyVelocity and BodyGyro then

        local char = plr.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local cam = workspace.CurrentCamera

        BodyGyro.CFrame = cam.CFrame
        BodyVelocity.Velocity = cam.CFrame.LookVector * 60

    end

end)

--------------------------------------------------
-- APPLY AGAIN WHEN RESPAWN
--------------------------------------------------

plr.CharacterAdded:Connect(function(char)

    local hum = char:WaitForChild("Humanoid")

    FlyEnabled = false
    BodyVelocity = nil
    BodyGyro = nil

    if SystemEnabled then
        hum.WalkSpeed = SpeedInput
        hum.UseJumpPower = true
        hum.JumpPower = JumpInput
    end

end)-- DASHBOARD
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

-- ปิดสคริป
Settings:Button({
    Title = Lang[CurrentLang].Unload,
    Callback = function()
        WindUI:Destroy()
    end
})

-- Join Discord
Settings:Button({
    Title = "💬 Join Discord",
    Callback = function()

        setclipboard("https://discord.gg/Fktbh2vJp")

        WindUI:Notify({
            Title = "Discord Link Copied",
            Content = "Discord link copied to clipboard!",
            Duration = 3
        })

    end
})

-- เปลี่ยนภาษา
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

-- Theme
Settings:Dropdown({
    Title = "🎨 UI Theme",
    Values = {"Dark","Light"},
    Callback = function(v)
        Window:SetTheme(v)
    end
})
