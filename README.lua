-- ESP Educacional com Botão de Ativar/Desativar
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local espEnabled = false -- Estado inicial (desligado)
local espObjects = {}    -- Para armazenar todas as caixas criadas

-- Função que cria ESP no jogador
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        -- Evita duplicar
        if player.Character:FindFirstChild("ESP_Box") then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Box"
        billboard.Adornee = player.Character.HumanoidRootPart
        billboard.Size = UDim2.new(4, 0, 5, 0)
        billboard.AlwaysOnTop = true

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Verde
        frame.BackgroundTransparency = 1
        frame.Parent = billboard

        billboard.Parent = player.Character
        table.insert(espObjects, billboard)
    end
end

-- Função para ativar o ESP
local function enableESP()
    espEnabled = true
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESP(player)
        end
    end
end

-- Função para desativar o ESP
local function disableESP()
    espEnabled = false
    for _, esp in pairs(espObjects) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    espObjects = {}
end

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then
            createESP(player)
        end
    end)
end)

-- Criar GUI com botão
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_Controller"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("ImageButton")
button.Size = UDim2.new(0, 100, 0, 100)
button.Position = UDim2.new(0, 20, 0.8, 0) -- canto inferior esquerdo
button.Image = "rbxassetid://6031071057" -- ID de uma imagem padrão (pode trocar)
button.BackgroundTransparency = 1
button.Parent = screenGui

-- Alternar ESP quando clicar no botão
button.MouseButton1Click:Connect(function()
    if espEnabled then
        disableESP()
        button.ImageColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho quando desligado
    else
        enableESP()
        button.ImageColor3 = Color3.fromRGB(0, 255, 0) -- Verde quando ligado
    end
end)
