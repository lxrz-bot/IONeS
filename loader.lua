print("IONeS script cargado.")

-- Puedes pegar aquí el resto del código completo que quieras ejecutar
--[[ 
    ███████╗ ██████╗ ███╗   ██╗███████╗███████╗
    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔════╝
    █████╗  ██║   ██║██╔██╗ ██║█████╗  ███████╗
    ██╔══╝  ██║   ██║██║╚██╗██║██╔══╝  ╚════██║
    ███████╗╚██████╔╝██║ ╚████║███████╗███████║
    ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝
             IONES - PRIVATE SCRIPT LOADER
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

print("IONeS Loader ejecutado.")

-- SKY: Reemplaza el cielo, paredes y suelo con tu imagen .png
local function sky(imgURL)
    local sky = Instance.new("Sky")
    sky.SkyboxBk = imgURL
    sky.SkyboxDn = imgURL
    sky.SkyboxFt = imgURL
    sky.SkyboxLf = imgURL
    sky.SkyboxRt = imgURL
    sky.SkyboxUp = imgURL
    sky.Name = "iONeS_SKY"
    Workspace:ClearAllChildren()  -- limpia decoraciones anteriores si quieres
    game.Lighting:ClearAllChildren()
    sky.Parent = game.Lighting
end

-- FLY: Volar con velocidad personalizada
local function fly(speed)
    speed = tonumber(speed) or 100
    local flying = true
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = player.Character:FindFirstChild("HumanoidRootPart")

    RunService.RenderStepped:Connect(function()
        if flying then
            local dir = Vector3.new()
            if mouse.W then dir += Workspace.CurrentCamera.CFrame.LookVector end
            if mouse.S then dir -= Workspace.CurrentCamera.CFrame.LookVector end
            if mouse.A then dir -= Workspace.CurrentCamera.CFrame.RightVector end
            if mouse.D then dir += Workspace.CurrentCamera.CFrame.RightVector end
            bv.Velocity = dir.Unit * speed
        end
    end)
end

-- SPAM CHAT: iONeS ON TOP
local function spamChat()
    while true do
        wait(0.2)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("iONeS ON TOP", "All")
    end
end

-- GRIFF TOOL
local function griff()
    local tool = Instance.new("Tool")
    tool.Name = "iONeS_ButtonTool"
    tool.RequiresHandle = false
    tool.CanBeDropped = true

    tool.Activated:Connect(function()
        local part = Instance.new("Part")
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(5,5,5)
        part.Anchored = true
        part.Material = Enum.Material.Slate
        part.BrickColor = BrickColor.new("Dark stone grey")
        part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, -10)
        part.Parent = Workspace
    end)

    local bombsEnabled = false
    local function addBomb()
        local bomb = Instance.new("Part")
        bomb.Size = Vector3.new(3,3,3)
        bomb.Anchored = false
        bomb.BrickColor = BrickColor.new("Bright red")
        bomb.Material = Enum.Material.Neon
        bomb.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
        bomb.Parent = Workspace
        local explosion = Instance.new("Explosion", Workspace)
        explosion.Position = bomb.Position
        wait(0.2)
        bomb:Destroy()
    end

    tool.Equipped:Connect(function()
        print("[iONeS] Tool equipada.")
        player:GetMouse().KeyDown:Connect(function(k)
            if k == "b" then
                bombsEnabled = not bombsEnabled
                if bombsEnabled then
                    print("[iONeS] Bombas ACTIVADAS")
                    while bombsEnabled do
                        addBomb()
                        wait(1)
                    end
                else
                    print("[iONeS] Bombas DESACTIVADAS")
                end
            end
        end)
    end)

    tool.Parent = player.Backpack
end

-- COMANDOS EJECUTABLES DESDE CONSOLA
getgenv().iONeS = {
    sky = sky,             -- iONeS.sky("https://tuimagen.png")
    fly = fly,             -- iONeS.fly(150)
    spam = spamChat,       -- iONeS.spam()
    griff = griff          -- iONeS.griff()
}
