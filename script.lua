local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============================================================================
-- MAIN WINDOW
-- ============================================================================

local Window = Rayfield:CreateWindow({
   Name = "Westbound Rage + Visuals Premium",
   Icon = 0,
   LoadingTitle = "Loading..",
   LoadingSubtitle = "By decro | v1.0",
   ShowText = "Loading...",
   Theme = "Amethyst",

   ToggleUIKeybind = "L", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "WestboundCon",
      FileName = "Settings"
   },

   Discord = {
      Enabled = false,
   },

   KeySystem = true,
   KeySettings = {
      Title = "Westbound Premium Key",
      Subtitle = "Key System v1.0",
      Note = "Pay for acces.",
      FileName = "Empty.",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"thevissuuals"}
   }
})

-- ============================================================================
-- VISUAL TAB
-- ============================================================================

local VisualTab = Window:CreateTab("  Visual  ", 4483362458)

-- ----------------------------------------------------------------------------
-- Camera Section
-- ----------------------------------------------------------------------------

local FOVSection = VisualTab:CreateSection("Camera")

local FOVSlider = VisualTab:CreateSlider({
    Name = "FOV",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
})

-- ----------------------------------------------------------------------------
-- ESP Section
-- ----------------------------------------------------------------------------

local ESPSection = VisualTab:CreateSection("ESP")

local ESPToggle = VisualTab:CreateToggle({ 
    Name = "ESP",
    CurrentValue = false,
    Callback = function(Value)
        _G.ESPEnabled = Value
        
        -- Function to create ESP for a player
        local function createESP(player)
            if not player.Character then return end
            
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            -- Create highlight effect
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
            
            -- Create billboard GUI for name and distance
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_Name"
            billboard.AlwaysOnTop = true
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.Adornee = humanoidRootPart
            billboard.Parent = humanoidRootPart
            
            -- Player name label
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Name = "NameLabel"
            nameLabel.BackgroundTransparency = 1
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = billboard
            
            -- Distance label
            local distanceLabel = Instance.new("TextLabel")
            distanceLabel.Name = "DistanceLabel"
            distanceLabel.BackgroundTransparency = 1
            distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distanceLabel.TextStrokeTransparency = 0
            distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            distanceLabel.TextSize = 12
            distanceLabel.Font = Enum.Font.Gotham
            distanceLabel.Parent = billboard
            
            -- Update distance in real-time
            local function updateDistance()
                while _G.ESPEnabled and character and humanoidRootPart do
                    local localChar = game.Players.LocalPlayer.Character
                    if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                        local distance = (humanoidRootPart.Position - localChar.HumanoidRootPart.Position).Magnitude
                        distanceLabel.Text = math.floor(distance) .. " studs"
                    end
                    wait(0.1)
                end
            end
            
            spawn(updateDistance)
        end
        
        -- Function to remove ESP from a player
        local function removeESP(player)
            if player.Character then
                local character = player.Character
                if character:FindFirstChild("HumanoidRootPart") then
                    local espName = character.HumanoidRootPart:FindFirstChild("ESP_Name")
                    if espName then
                        espName:Destroy()
                    end
                end
                local highlight = character:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
        
        -- Enable/disable ESP for all players
        if Value then
            -- Add ESP to existing players
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    if player.Character then
                        createESP(player)
                    end
                    player.CharacterAdded:Connect(function(character)
                        if _G.ESPEnabled then
                            wait(1)
                            createESP(player)
                        end
                    end)
                end
            end
            
            -- Add ESP to new players
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    if _G.ESPEnabled then
                        wait(1)
                        createESP(player)
                    end
                end)
            end)
            
            print("ESP Enabled")
        else
            -- Remove ESP from all players
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
            
            print("ESP Disabled")
        end
    end,
})

-- X-Ray in ESP Section
local XRayToggle = VisualTab:CreateToggle({
    Name = "X-Ray",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            -- Make all parts semi-transparent
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 0.5 then
                    part.LocalTransparencyModifier = 0.5
                end
            end
            print("X-Ray Enabled")
        else
            -- Restore original transparency
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 0
                end
            end
            print("X-Ray Disabled")
        end
    end
})

-- Tracers in ESP Section
local TracersToggle = VisualTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = false,
    Callback = function(Value)
        _G.TracersEnabled = Value
        
        if Value then
            spawn(function()
                while _G.TracersEnabled do
                    for _, player in pairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character then
                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                -- Create temporary beam
                                local beam = Instance.new("Beam")
                                beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                                beam.Width0 = 0.2
                                beam.Width1 = 0.2
                                beam.Attachment0 = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("Attachment")
                                beam.Attachment1 = root:FindFirstChildOfClass("Attachment")
                                beam.Parent = workspace
                                
                                -- Remove beam after short time
                                game:GetService("Debris"):AddItem(beam, 0.1)
                            end
                        end
                    end
                    wait(0.1)
                end
            end)
            print("Tracers Enabled")
        else
            print("Tracers Disabled")
        end
    end
})

-- ----------------------------------------------------------------------------
-- FPS Section
-- ----------------------------------------------------------------------------

local FPSSection = VisualTab:CreateSection("FPS")

local NoShadowsToggle = VisualTab:CreateToggle({
    Name = "No Shadows",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
            print("Shadows Disabled")
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = true
                end
            end
            print("Shadows Enabled")
        end
    end
})

-- ----------------------------------------------------------------------------
-- Sky Color Section (Fixed)
-- ----------------------------------------------------------------------------

local SkyColorSection = VisualTab:CreateSection("Sky Color")

-- Create Sky Color Dropdown
local SkyColorDropdown = VisualTab:CreateDropdown({
    Name = "Sky Color",
    Options = {"Blue", "Red", "Green", "Purple", "Yellow", "Orange", "Default"},
    CurrentOption = "Default",
    MultipleOptions = false,
    Callback = function(SelectedOption)
        local colorName
        if type(SelectedOption) == "table" then
            colorName = SelectedOption[1] or "Default"
        else
            colorName = SelectedOption
        end
        
        local ColorValue
        
        if colorName == "Blue" then
            ColorValue = Color3.fromRGB(100, 100, 255)
        elseif colorName == "Red" then
            ColorValue = Color3.fromRGB(255, 100, 100)
        elseif colorName == "Green" then
            ColorValue = Color3.fromRGB(100, 255, 100)
        elseif colorName == "Purple" then
            ColorValue = Color3.fromRGB(200, 100, 255)
        elseif colorName == "Yellow" then
            ColorValue = Color3.fromRGB(255, 255, 100)
        elseif colorName == "Orange" then
            ColorValue = Color3.fromRGB(255, 150, 50)
        else
            ColorValue = Color3.fromRGB(127, 127, 127) -- Default
        end
        
        game:GetService("Lighting").Ambient = ColorValue
        print("Sky color: " .. colorName)
    end,
})

-- ============================================================================
-- COMBAT TAB
-- ============================================================================

local CombatTab = Window:CreateTab("  Combat  ", 4483362458)

-- ----------------------------------------------------------------------------
-- Rage Section
-- ----------------------------------------------------------------------------

local RageSection = CombatTab:CreateSection("Rage")

_G.HeadSize = 10
_G.HitboxesEnabled = false

local HitboxesToggle = CombatTab:CreateToggle({
    Name = "Hitboxes",
    CurrentValue = false,
    Callback = function(Value)
        _G.HitboxesEnabled = Value
        
        if Value then
            spawn(function()
                while _G.HitboxesEnabled do
                    for i, v in next, game:GetService('Players'):GetPlayers() do
                        if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                            pcall(function()
                                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                                    v.Character.HumanoidRootPart.Transparency = 1
                                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                                    v.Character.HumanoidRootPart.Material = "Neon"
                                    v.Character.HumanoidRootPart.CanCollide = false
                                end
                            end)
                        end
                    end
                    game:GetService('RunService').RenderStepped:Wait()
                end
                
                for i, v in next, game:GetService('Players'):GetPlayers() do
                    if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                        pcall(function()
                            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                                v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                                v.Character.HumanoidRootPart.Transparency = 0
                                v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                                v.Character.HumanoidRootPart.Material = "Plastic"
                                v.Character.HumanoidRootPart.CanCollide = true
                            end
                        end)
                    end
                end
            end)
            print("Hitboxes Enabled")
        else
            print("Hitboxes Disabled")
        end
    end
})

local HeadSizeSlider = CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {5, 50},
    Increment = 1,
    Suffix = "Size",
    CurrentValue = 10,
    Callback = function(Value)
        _G.HeadSize = Value
    end
})
