--------------------------------------------------
-- AVRST CYBER PREMIUM UI
--------------------------------------------------

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer
repeat task.wait() until plr.Character

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

--------------------------------------------------
-- COLOR THEME
--------------------------------------------------

local CYBER_BLUE = Color3.fromRGB(37, 99, 235)
local CYBER_PURPLE = Color3.fromRGB(147, 51, 234)

--------------------------------------------------
-- WINDOW
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
-- TABS
--------------------------------------------------

local InfoTab = Window:Tab({Title="ℹ️ ข้อมูล"})
local PlayerTab = Window:Tab({Title="👤 โปรไฟล์"})
local ScriptTab = Window:Tab({Title="⚡ Player"})

--------------------------------------------------
-- INFO TAB
--------------------------------------------------

InfoTab:Paragraph({
    Title = "AVRST Shop",
    Content = "Premium Automation Script"
})

InfoTab:Button({
    Title = "💬 Join Discord",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/yourlink")
        end
    end
})

--------------------------------------------------
-- PLAYER PROFILE
--------------------------------------------------

local userId = plr.UserId
local name = plr.DisplayName
local username = plr.Name

local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local avatar = Players:GetUserThumbnailAsync(userId,thumbType,thumbSize)

PlayerTab:Image({
    Url = avatar
})

PlayerTab:Paragraph({
    Title = "👤 "..name,
    Content = "Username : "..username
})

PlayerTab:Paragraph({
    Title = "🆔 User ID",
    Content = tostring(userId)
})

PlayerTab:Paragraph({
    Title = "🎮 Team",
    Content = plr.Team and plr.Team.Name or "None"
})

--------------------------------------------------
-- PLAYER FUNCTIONS
--------------------------------------------------

local speed = 16
local jump = 50
local infiniteJump = false
local flying = false

--------------------------------------------------
-- SPEED
--------------------------------------------------

ScriptTab:Input({
    Title="⛸️ วิ่งเร็ว",
    Placeholder="ใส่ค่า Speed",
    Callback=function(v)
        speed = tonumber(v) or 16
    end
})

ScriptTab:Button({
    Title="กดใช้ Speed",
    Callback=function()
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speed
        end
    end
})

ScriptTab:Button({
    Title="รีเซ็ต Speed",
    Callback=function()
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
        end
    end
})

--------------------------------------------------
-- JUMP
--------------------------------------------------

ScriptTab:Input({
    Title="🦵 โดดสูง",
    Placeholder="ใส่ค่า Jump",
    Callback=function(v)
        jump = tonumber(v) or 50
    end
})

ScriptTab:Button({
    Title="กดใช้ Jump",
    Callback=function()
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = jump
        end
    end
})

ScriptTab:Button({
    Title="รีเซ็ต Jump",
    Callback=function()
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = 50
        end
    end
})

--------------------------------------------------
-- INFINITE JUMP
--------------------------------------------------

ScriptTab:Toggle({
    Title="🪄 กระโดดไม่จำกัด",
    Callback=function(state)
        infiniteJump = state
    end
})

UIS.JumpRequest:Connect(function()
    if infiniteJump then
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--------------------------------------------------
-- FLY
--------------------------------------------------

ScriptTab:Toggle({
    Title="🕊️ บิน",
    Callback=function(state)
        flying = state
        
        local char = plr.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if flying then
            
            if not root:FindFirstChild("BodyVelocity") then
                local body = Instance.new("BodyVelocity")
                body.MaxForce = Vector3.new(100000,100000,100000)
                body.Velocity = Vector3.new(0,50,0)
                body.Parent = root
            end
            
        else
            
            local bv = root:FindFirstChild("BodyVelocity")
            if bv then
                bv:Destroy()
            end
            
        end
    end
})

--------------------------------------------------
-- SAVE SETTINGS / LOAD
--------------------------------------------------

WindUI:Notify({
    Title="AVRST",
    Content="Script Loaded",
    Duration=3
})
