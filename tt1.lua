-- لوحة استكشاف وإدارة ملفات ومكونات اللعبة المتقدمة
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SearchBox = Instance.new("TextBox")
local RefreshBtn = Instance.new("TextButton")
local ClearLagBtn = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- إعدادات اللوحة الرئيسية
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "AdvancedExplorer"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 480)
MainFrame.Active = true
MainFrame.Draggable = true

-- العنوان
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "مستكشف وإدارة ملفات اللعبة المطور"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold

-- شريط البحث
SearchBox.Parent = MainFrame
SearchBox.Size = UDim2.new(0.5, -10, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 45)
SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SearchBox.PlaceholderText = "ابحث عن سكريبت هنا..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 14

-- زر التحديث
RefreshBtn.Parent = MainFrame
RefreshBtn.Size = UDim2.new(0.23, -5, 0, 35)
RefreshBtn.Position = UDim2.new(0.5, 5, 0, 45)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
RefreshBtn.Text = "تحديث القائمة"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14

-- زر تنظيف الـ Lag
ClearLagBtn.Parent = MainFrame
ClearLagBtn.Size = UDim2.new(0.23, -5, 0, 35)
ClearLagBtn.Position = UDim2.new(0.75, 5, 0, 45)
ClearLagBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 0)
ClearLagBtn.Text = "تنظيف الـ Lag"
ClearLagBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearLagBtn.Font = Enum.Font.SourceSansBold
ClearLagBtn.TextSize = 14

-- قائمة التمرير
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Position = UDim2.new(0, 10, 0, 90)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 8

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- وظيفة فحص وتحديث الملفات
local function scanScripts(filterText)
    -- تنظيف القائمة القديمة
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    filterText = filterText and filterText:lower() or ""

    -- البحث في جميع الأماكن المتاحة للجهاز
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            -- تصفية البحث بناءً على النص المدخل
            if filterText == "" or v.Name:lower():find(filterText) then
                
                local ScriptFrame = Instance.new("Frame")
                local ScriptName = Instance.new("TextLabel")
                local DisableBtn = Instance.new("TextButton")
                local DeleteBtn = Instance.new("TextButton")

                ScriptFrame.Size = UDim2.new(1, -10, 0, 40)
                ScriptFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ScriptFrame.Parent = ScrollingFrame

                ScriptName.Size = UDim2.new(0.5, 0, 1, 0)
                ScriptName.Text = " [" .. v.ClassName:sub(1,5) .. "] " .. v.Name
                ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
                ScriptName.TextXAlignment = Enum.TextXAlignment.Left
                ScriptName.BackgroundTransparency = 1
                ScriptName.Font = Enum.Font.SourceSans
                ScriptName.TextSize = 13
                ScriptName.Parent = ScriptFrame

                -- زر الإيقاف (لـ LocalScript فقط)
                DisableBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
                DisableBtn.Position = UDim2.new(0.52, 0, 0.15, 0)
                DisableBtn.Font = Enum.Font.SourceSansBold
                DisableBtn.TextSize = 12
                DisableBtn.Parent = ScriptFrame

                if v:IsA("LocalScript") then
                    if v.Disabled then
                        DisableBtn.Text = "معطل"
                        DisableBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    else
                        DisableBtn.Text = "إيقاف"
                        DisableBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                        DisableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                else
                    DisableBtn.Text = "موديول"
                    DisableBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    DisableBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                    DisableBtn.Active = false
                end

                -- زر الحذف الكامل (يعمل على النوعين)
                DeleteBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
                DeleteBtn.Position = UDim2.new(0.76, 0, 0.15, 0)
                DeleteBtn.Text = "حذف ✖"
                DeleteBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                DeleteBtn.Font = Enum.Font.SourceSansBold
                DeleteBtn.TextSize = 12
                DeleteBtn.Parent = ScriptFrame

                -- تشغيل أزرار التحكم
                DisableBtn.MouseButton1Click:Connect(function()
                    if v:IsA("LocalScript") then
                        v.Disabled = true
                        DisableBtn.Text = "تم"
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

-- تشغيل البحث عند تغيير النص في شريط البحث
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    scanScripts(SearchBox.Text)
end)

-- تشغيل زر التحديث
RefreshBtn.MouseButton1Click:Connect(function()
    scanScripts(SearchBox.Text)
end)

-- تشغيل زر إزالة الـ Lag (حذف الأجسام والمقذوفات غير الضرورية محلياً)
ClearLagBtn.MouseButton1Click:Connect(function()
    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) and (obj.Name == "Part" or obj.Parent:IsA("Debris")) then
            pcall(function() obj:Destroy() end)
            count = count + 1
        end
    end
    ClearLagBtn.Text = "تم تنظيف (" .. count .. ")"
    task.wait(2)
    ClearLagBtn.Text = "تنظيف الـ Lag"
end)

-- التشغيل المبدئي عند التفعيل
scanScripts()
