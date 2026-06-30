-- Advanced Explorer with Item/Model Selection Tool
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
MainFrame.Name = "ModelManagerExplorer"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 480)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Header
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "  Model & Script Manager"
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
SearchBox.PlaceholderText = "Search item or model..."
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

-- Storage for objects and scripts
local customObjects = {}
local player = game.Players.LocalPlayer

-- Function to add objects to list manually or via scan
local function addObject(obj)
    if obj and obj.Parent and not table.find(customObjects, obj) then
        table.insert(customObjects, obj)
    end
end

-- Scan Initial Scripts & Local Models
local function updateDatabase()
    customObjects = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            table.insert(customObjects, v)
        end
    end
end

-- Render List on UI
local function renderList(filterText)
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    filterText = filterText and filterText:lower() or ""

    for i, v in pairs(customObjects) do
        if v and v.Parent then 
            if filterText == "" or v.Name:lower():find(filterText) then
                
                local ScriptFrame = Instance.new("Frame")
                local ScriptName = Instance.new("TextLabel")
                local ActionBtn = Instance.new("TextButton")
                local DeleteBtn = Instance.new("TextButton")

                ScriptFrame.Size = UDim2.new(1, -10, 0, 38)
                ScriptFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ScriptFrame.Parent = ScrollingFrame

                -- Identify Type
                local objType = "[Obj]"
                if v:IsA("LocalScript") then objType = "[Local]"
                elseif v:IsA("ModuleScript") then objType = "[Mod]"
                elseif v:IsA("Model") then objType = "[Model]" end

                ScriptName.Size = UDim2.new(0.5, 0, 1, 0)
                ScriptName.Text = " " .. objType .. " " .. v.Name
                ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
                ScriptName.TextXAlignment = Enum.TextXAlignment.Left
                ScriptName.BackgroundTransparency = 1
                ScriptName.Font = Enum.Font.SourceSans
                ScriptName.TextSize = 13
                ScriptName.Parent = ScriptFrame

                -- Action / Disable Button
                ActionBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
                ActionBtn.Position = UDim2.new(0.52, 0, 0.15, 0)
                ActionBtn.Font = Enum.Font.SourceSansBold
                ActionBtn.TextSize = 12
                ActionBtn.Parent = ScriptFrame

                if v:IsA("LocalScript") then
                    ActionBtn.Text = v.Disabled and "Disabled" or "Disable"
                    ActionBtn.BackgroundColor3 = v.Disabled and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(200, 50, 50)
                    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                elseif v:IsA("Model") or v:IsA("BasePart") then
                    ActionBtn.Text = "Unlist"
                    ActionBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    ActionBtn.Text = "Module"
                    ActionBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    ActionBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                end

                -- Delete Button
                DeleteBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
                DeleteBtn.Position = UDim2.new(0.76, 0, 0.15, 0)
                DeleteBtn.Text = "Delete"
                DeleteBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                DeleteBtn.Font = Enum.Font.SourceSansBold
                DeleteBtn.TextSize = 12
                DeleteBtn.Parent = ScriptFrame

                -- Core Logic Connections
                ActionBtn.MouseButton1Click:Connect(function()
                    if v:IsA("LocalScript") then
                        v.Disabled = true
                        ActionBtn.Text = "Done"
                        ActionBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    elseif ActionBtn.Text == "Unlist" then
                        table.remove(customObjects, i)
                        ScriptFrame:Destroy()
                    end
                end)

                DeleteBtn.MouseButton1Click:Connect(function()
                    pcall(function() v:Destroy() end)
                    table.remove(customObjects, i)
                    ScriptFrame:Destroy()
                end)
            end
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- CREATING THE SELECTION ITEM (TOOL)
local function giveSelectionTool()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    -- Check if tool already exists
    if backpack:FindFirstChild("Selection Tool") or (player.Character and player.Character:FindFirstChild("Selection Tool")) then return end

    local Tool = Instance.new("Tool")
    Tool.Name = "Selection Tool"
    Tool.RequiresHandle = false
    Tool.ToolTip = "Equip and click any Model/Part to add to the menu"
    
    Tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target then
            -- Find the top model if it belongs to one, otherwise grab the part
            local finalTarget = target:FindFirstAncestorOfClass("Model") or target
            
            addObject(finalTarget)
            renderList(SearchBox.Text)
            
            -- Visual feedback on Tool tip
            Tool.Name = "Added: " .. finalTarget.Name
            task.wait(1)
            Tool.Name = "Selection Tool"
        end
    end)
    
    Tool.Parent = backpack
end

-- Connections
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderList(SearchBox.Text)
end)

RefreshBtn.MouseButton1Click:Connect(function()
    RefreshBtn.Text = "Scanning..."
    task.wait(0.1)
    updateDatabase()
    giveSelectionTool()
    renderList(SearchBox.Text)
    RefreshBtn.Text = "Refresh"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    local tool = player.Backpack:FindFirstChild("Selection Tool") or (player.Character and player.Character:FindFirstChild("Selection Tool"))
    if tool then tool:Destroy() end
end)

-- Initial Loop/Run
updateDatabase()
giveSelectionTool()
renderList("")
