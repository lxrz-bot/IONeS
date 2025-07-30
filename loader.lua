print("IONeS script cargado.")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- Esperar a que el personaje esté cargado completamente
local function waitForCharacter()
    if not player.Character or not player.Character.Parent then
        player.CharacterAdded:Wait()
    end
    while not player.Character:FindFirstChild("HumanoidRootPart") do
        wait()
    end
    return player.Character
end

local character = waitForCharacter()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

print("IONeS Loader ejecutado.")

-- Función para cambiar el cielo (no limpiar todo el workspace)
local function sky(imgURL)
    local sky = Instance.new("Sky")
    sky.SkyboxBk = imgURL
    sky.SkyboxDn = imgURL
    sky.SkyboxFt = imgURL
    sky.SkyboxLf = imgURL
    sky.SkyboxRt = imgURL
    sky.SkyboxUp = imgURL
    sky.Name = "iONeS_SKY"

    -- Si ya existe un skybox personalizado, eliminarlo antes
    local oldSky = Lighting:FindFirstChild("iONeS_SKY")
    if oldSky then oldSky:Destroy() end

    sky.Parent = Lighting
end

-- Función para volar con teclas WSAD
local function fly(speed)
    speed = tonumber(speed) or 100
    local flying = true
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = humanoidRootPart

    local keysPressed = {w=false, a=false, s=false, d=false}

    mouse.KeyDown:Connect(function(key)
        key = key:lower()
        if keysPressed[key] ~= nil then
            keysPressed[key] = true
        end
    end)

    mouse.KeyUp:Connect(function(key)
        key = key:lower()
        if keysPressed[key] ~= nil then
            keysPressed[key] = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if flying then
            local dir = Vector3.new(0,0,0)
            local camCFrame = Workspace.CurrentCamera.CFrame

            if keysPressed.w then dir = dir + camCFrame.LookVector end
            if keysPressed.s then dir = dir - camCFrame.LookVector end
            if keysPressed.a then dir = dir - camCFrame.RightVector end
            if keysPressed.d then dir = dir + camCFrame.RightVector end

            if dir.Magnitude > 0 then
                bv.Velocity = dir.Unit * speed
            else
                bv.Velocity = Vector3.new(0,0,0)
            end
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
    end)
end

-- Función para spam en el chat
local function spamChat()
    spawn(function()
        while true do
            wait(0.2)
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("iONeS ON TOP", "All")
        end
    end)
end

-- Función herramienta griff
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
        part.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -5, -10)
        part.Parent = Workspace
    end)

    local bombsEnabled = false
    local bombConnection

    tool.Equipped:Connect(function()
        print("[iONeS] Tool equipada.")
        bombConnection = mouse.KeyDown:Connect(function(k)
            if k == "b" then
                bombsEnabled = not bombsEnabled
                if bombsEnabled then
                    print("[iONeS] Bombas ACTIVADAS")
                    spawn(function()
                        while bombsEnabled do
                            local bomb = Instance.new("Part")
                            bomb.Size = Vector3.new(3,3,3)
                            bomb.Anchored = false
                            bomb.BrickColor = BrickColor.new("Bright red")
                            bomb.Material = Enum.Material.Neon
                            bomb.Position = humanoidRootPart.Position + Vector3.new(0,5,0)
                            bomb.Parent = Workspace

                            local explosion = Instance.new("Explosion")
                            explosion.Position = bomb.Position
                            explosion.Parent = Workspace

                            wait(0.2)
                            bomb:Destroy()
                            wait(1)
                        end
                    end)
                else
                    print("[iONeS] Bombas DESACTIVADAS")
                end
            end
        end)
    end)

    tool.Unequipped:Connect(function()
        if bombConnection then
            bombConnection:Disconnect()
        end
        bombsEnabled = false
    end)

    tool.Parent = player.Backpack
end

-- Exponer funciones globalmente para consola
getgenv().iONeS = {
    sky = sky,
    fly = fly,
    spam = spamChat,
    griff = griff
}

print("IONeS script listo.")
