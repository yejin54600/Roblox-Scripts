-- لوحة استكشاف الملفات - نسخة محسنة ومضادة للتعليق (Anti-Lag)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton") -- زر الإغلاق الجديد
local SearchBox = Instance.new("TextBox")
local RefreshBtn = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- إعدادات اللوحة الرئيسية
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "OptimizedExplorer"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 420, 0, 480)
MainFrame.Active = true
MainFrame.Draggable = true

-- العنوان
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 40) -- ترك مساحة لزر الإكس
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "مستكشف الملفات الخفيف والمطور"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold

-- زر إغلاق السكريبت بالكامل (X)
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "✖"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16

-- شريط البحث
SearchBox.Parent = MainFrame
SearchBox.Size = UDim2.new(0.65, -15, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 45)
SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SearchBox.PlaceholderText = "اكتب هنا للبحث بدون تعليق..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 14

-- زر التحديث
RefreshBtn.Parent = MainFrame
RefreshBtn.Size = UDim2.new(0.35, -10, 0, 35)
RefreshBtn.Position = UDim2.new(0.65, 5, 0, 45)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
RefreshBtn.Text = "تحديث وفحص"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14

-- قائمة التمرير
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Position = UDim2.new(0, 10, 0, 90)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- مصفوفة لتخزين السكريبتات التي تم العثور عليها لتجنب فحص اللعبة مراراً وتكراراً
local cachedScripts = {}

-- وظيفة الفحص الأساسية (تُستدعى فقط عند التشغيل أو الضغط على تحديث)
local function updateDatabase()
    cachedScripts = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            table.insert(cachedScripts, v)
        end
    end
end

-- وظيفة عرض وتصفية السكريبتات على الواجهة بدون تعليق الماب
local function renderList(filterText)
    -- تنظيف العناصر الظاهرة فقط
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    filterText = filterText and filterText:lower() or ""

    for _, v in pairs(cachedScripts) do
        -- التحقق من وجود السكريبت (لأنه قد يكون حُذف أثناء اللعب)
        if v and v.Parent then 
            if filterText == "" or v.Name:lower():find(filterText) then
                
                local ScriptFrame = Instance.new("Frame")
                local ScriptName = Instance.new("TextLabel")
                local DisableBtn = Instance.new("TextButton")
                local DeleteBtn = Instance.new("TextButton")

                ScriptFrame.Size = UDim2.new(1, -10, 0, 38)
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

                -- زر الإيقاف
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
                end

                -- زر الحذف
                DeleteBtn.Size = UDim2.new(0.22, 0, 0.7, 0)
                DeleteBtn.Position = UDim2.new(0.76, 0, 0.15, 0)
                DeleteBtn.Text = "حذف ✖"
                DeleteBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                DeleteBtn.Font = Enum.Font.SourceSansBold
                DeleteBtn.TextSize = 12
                DeleteBtn.Parent = ScriptFrame

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

-- تصفية القائمة فوراً عند كتابة أي حرف بدون أي لاق
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderList(SearchBox.Text)
end)

-- تحديث قاعدة البيانات عند الضغط على زر التحديث
RefreshBtn.MouseButton1Click:Connect(function()
    RefreshBtn.Text = "جاري الفحص..."
    task.wait(0.1)
    updateDatabase()
    renderList(SearchBox.Text)
    RefreshBtn.Text = "تحديث وفحص"
end)

-- تشغيل زر الإغلاق لإطفاء السكريبت بالكامل وحذفه من اللعبة
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- التشغيل الأول للسكريبت
updateDatabase()
renderList("")
