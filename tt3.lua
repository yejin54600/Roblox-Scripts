-- Advanced Explorer - English Anti-Lag Version
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local SearchBox = Instance.new("TextBox")
local RefreshBtn = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- UI Main Frame Setup
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "OptimizedExplorerEn"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 480)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Header
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "  Script Explorer & Manager"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button (X)
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16

-- Search Box
SearchBox.Parent = MainFrame
SearchBox.Size = UDim2.new(0.65, -15, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 45)
SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SearchBox.PlaceholderText = "Search script name..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 14

-- Refresh Button
RefreshBtn.Parent = MainFrame
RefreshBtn.Size = UDim2.new(0.35, -10, 0, 35)
RefreshBtn.Position = UDim2.new(0.65, 5, 0, 45)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
RefreshBtn.Text = "Refresh"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14

-- Scrolling List
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Position = UDim2.new(0, 10, 0, 90)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Cache array to prevent continuous scanning lag
local cachedScripts = {}

-- Main Scan Function
local function updateDatabase()
    cachedScripts = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            table.insert(cachedScripts, v)
        end
    end
end

-- Render and Filter Function
local function renderList(filterText)
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    filterText = filterText and filterText:lower() or ""

    for _, v in pairs(cachedScripts) do
        if v and v.Parent then 
            if filterText == "" or v.Name:lower():find(filterText) then
                
                local ScriptFrame = Instance.new("Frame")
                local ScriptName = Instance.new("TextLabel")
                local DisableBtn = Instance.new("TextButton")
                local DeleteBtn = Instance.new("TextButton")

                ScriptFrame.Size = UDim2.new(1, -10, 0, 38)
                ScriptFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ScriptFrame.Parent = ScrollingFrame

                local classType = v:IsA("LocalScript") and "[Local]" or "[Mod]"
                ScriptName.Size = UDim2.new(0.5, 0, 1, 0)
                ScriptName.Text = " " .. classType .. " " .. v.Name
                ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
                ScriptName.TextXAlignment = Enum.TextXAlignment.Left
                ScriptName.BackgroundTransparency = 1
                ScriptName.Font = Enum.Font.SourceSans
                ScriptName.TextSize = 13
                ScriptName.Parent = ScriptFrame

                -- Disable Button Setup
                DisableBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
                DisableBtn.Position = UDim2.new(0.52, 0, 0.15, 0)
                DisableBtn.Font = Enum.Font.SourceSansBold
                DisableBtn.TextSize = 12
                DisableBtn.Parent = ScriptFrame

                if v:IsA("LocalScript") then
                    if v.Disabled then
                        DisableBtn.Text = "Disabled"
                        DisableBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    else
                        DisableBtn.Text = "Disable"
                        DisableBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        DisableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                else
                    DisableBtn.Text = "Module"
                    DisableBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    DisableBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                end

                -- Delete Button Setup
                DeleteBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
                DeleteBtn.Position = UDim2.new(0.76, 0, 0.15, 0)
                DeleteBtn.Text = "Delete"
                DeleteBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                DeleteBtn.Font = Enum.Font.SourceSansBold
                DeleteBtn.TextSize = 12
                DeleteBtn.Parent = ScriptFrame

                -- Button Actions
                DisableBtn.MouseButton1Click:Connect(function()
                    if v:IsA("LocalScript") then
                        v.Disabled = true
                        DisableBtn.Text = "Done"
                        DisableBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    end
                end)

                DeleteBtn.MouseButton1Click:Connect(function()
                    pcall(function() v:Destroy() end)
                    ScriptFrame:Destroy()
                end)
            end
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- Anti-Lag Real-time Search Connection
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderList(SearchBox.Text)
end)

-- Refresh Button Connection
RefreshBtn.MouseButton1Click:Connect(function()
    RefreshBtn.Text = "Scanning..."
    task.wait(0.1)
    updateDatabase()
    renderList(SearchBox.Text)
    RefreshBtn.Text = "Refresh"
end)

-- Close Button Connection
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Initial Execution
updateDatabase()
renderList("")
