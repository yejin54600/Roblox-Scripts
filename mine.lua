-- لوحة التحكم واستكشاف الملفات الشغالة
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- إعدادات اللوحة الرئيسية
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "ScriptScanner"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

-- العنوان
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "مستكشف وموقف الملفات الشغالة"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold

-- قائمة التمرير لعرض السكريبتات
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 8

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- وظيفة إضافة السكريبتات للقائمة
local function scanScripts()
    -- تنظيف القائمة القديمة
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    -- البحث عن الملفات في المكان الذي تظهر فيه للمشغل (Game Characters, PlayerGui, etc)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            -- إنشاء سطر لكل سكريبت يتم العثور عليه
            local ScriptFrame = Instance.new("Frame")
            local ScriptName = Instance.new("TextLabel")
            local ActionBtn = Instance.new("TextButton")

            ScriptFrame.Size = UDim2.new(1, -10, 0, 35)
            ScriptFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ScriptFrame.Parent = ScrollingFrame

            ScriptName.Size = UDim2.new(0.7, 0, 1, 0)
            ScriptName.Text = " [" .. v.ClassName .. "] " .. v.Name
            ScriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
            ScriptName.TextXAlignment = Enum.TextXAlignment.Left
            ScriptName.BackgroundTransparency = 1
            ScriptName.Font = Enum.Font.SourceSans
            ScriptName.TextSize = 14
            ScriptName.Parent = ScriptFrame

            ActionBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
            ActionBtn.Position = UDim2.new(0.72, 0, 0.1, 0)
            ActionBtn.Font = Enum.Font.SourceSansBold
            ActionBtn.TextSize = 12
            ActionBtn.Parent = ScriptFrame

            -- التحقق من حالة السكريبت وتلوين الزر
            if v:IsA("LocalScript") then
                if v.Disabled then
                    ActionBtn.Text = "معطل"
                    ActionBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                else
                    ActionBtn.Text = "إيقاف"
                    ActionBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
                    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            else
                -- موديول سكريبت لا يمكن تعطيله مباشرة بالـ Disabled ولكن يمكننا محاولة تدميره
                ActionBtn.Text = "حذف"
                ActionBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 50)
                ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            -- عند الضغط على الزر
            ActionBtn.MouseButton1Click:Connect(function()
                if v:IsA("LocalScript") then
                    v.Disabled = true
                    ActionBtn.Text = "تم الإيقاف"
                    ActionBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                elseif v:IsA("ModuleScript") then
                    v:Destroy()
                    ScriptFrame:Destroy()
                end
            end)
        end
    end
    -- تحديث حجم القائمة لتستوعب السكريبتات
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

-- تشسغيل الفحص فور تشغيل السكريبت
scanScripts()
