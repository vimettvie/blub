--[[
    UILibrary для Roblox (Luau)
    Загрузка через loadstring:

    local Library = loadstring(game:HttpGet("URL_ДО_ФАЙЛА"))()

    Пример использования — в самом низу файла (закомментирован).
]]

local UILibrary = {}
UILibrary.__index = UILibrary

-- ===== СЕРВИСЫ =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ===== ЦВЕТОВАЯ ТЕМА (можно поменять под себя) =====
local Theme = {
    Background   = Color3.fromRGB(45, 48, 46),
    Sidebar      = Color3.fromRGB(50, 53, 51),
    Accent       = Color3.fromRGB(140, 190, 170),
    ElementBg    = Color3.fromRGB(60, 63, 61),
    Text         = Color3.fromRGB(235, 235, 235),
    SubText      = Color3.fromRGB(180, 180, 180),
    Stroke       = Color3.fromRGB(90, 95, 92),
}

-- ===== ХЕЛПЕРЫ =====
local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function corner(radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
end

local function stroke(color, thickness)
    return create("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
    })
end

local function tween(inst, props, time)
    TweenService:Create(inst, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local function makeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ===== СОЗДАНИЕ ОКНА =====
function UILibrary:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "заголовок"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift

    -- удаляем старый гуи если есть
    local existing = CoreGui:FindFirstChild("UILibraryScreenGui")
    if existing then existing:Destroy() end

    local screenGui = create("ScreenGui", {
        Name = "UILibraryScreenGui",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    local ok = pcall(function() screenGui.Parent = CoreGui end)
    if not ok then screenGui.Parent = PlayerGui end

    -- размытие фона (реальный блюр 3д-мира)
    local blur = create("BlurEffect", {
        Name = "UILibraryBlur",
        Size = 0,
        Parent = Lighting,
    })

    local main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 560, 0, 340),
        Position = UDim2.new(0.5, -280, 0.5, -170),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.08,
        Parent = screenGui,
    }, { corner(12), stroke(Theme.Stroke, 1) })

    -- лёгкий градиент поверх для "стеклянного" вида
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200,200,200)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0.97),
        }),
        Rotation = 90,
        Parent = main,
    })

    -- топ-бар для перетаскивания + заголовок
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.15,
        Parent = main,
    }, { corner(12) })

    -- перекрываем правый скругление сайдбара, чтобы был ровный шов
    create("Frame", {
        Size = UDim2.new(0, 12, 1, 0),
        Position = UDim2.new(1, -12, 0, 0),
        BackgroundColor3 = Theme.Sidebar,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Parent = sidebar,
    })

    local titleLabel = create("TextLabel", {
        Text = windowTitle,
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sidebar,
    })

    makeDraggable(main, titleLabel)
    makeDraggable(main, sidebar)

    local tabList = create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, -16, 1, -60),
        Position = UDim2.new(0, 8, 0, 55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar,
    }, { create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }) })

    local content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -158, 1, -16),
        Position = UDim2.new(0, 158, 0, 8),
        BackgroundTransparency = 1,
        Parent = main,
    })

    local subTabBar = create("ScrollingFrame", {
        Name = "SubTabBar",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.ElementBg,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollingDirection = Enum.ScrollingDirection.X,
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = content,
    }, {
        corner(8),
        create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
        }),
    })

    local pagesHolder = create("Frame", {
        Name = "Pages",
        Size = UDim2.new(1, 0, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 1,
        Parent = content,
    })

    -- показ / скрытие окна
    local visible = true
    local function setVisible(state)
        visible = state
        main.Visible = state
        tween(blur, { Size = state and 16 or 0 }, 0.25)
    end
    setVisible(true)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == toggleKey and not gameProcessed then
            setVisible(not visible)
        end
    end)

    local Window = {}
    local tabs = {}
    local firstTab = true

    -- ===== ВКЛАДКА =====
    function Window:CreateTab(name)
        local tabButton = create("TextButton", {
            Text = name,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Theme.ElementBg,
            BackgroundTransparency = firstTab and 0 or 0.3,
            AutoButtonColor = false,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = firstTab and Theme.Accent or Theme.SubText,
            Parent = tabList,
        }, { corner(8) })

        local tabContainer = create("Frame", {
            Name = name .. "_Container",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = firstTab,
            Parent = pagesHolder,
        })

        local ownSubTabBar = subTabBar -- общий бар сверху, привязываем кнопки динамически
        local subTabButtonsFolder = create("Folder", { Name = name .. "_SubButtons", Parent = ownSubTabBar })

        local Tab = {}
        local subTabs = {}
        local firstSubTab = true

        local function selectTab()
            for _, t in ipairs(tabs) do
                t.Container.Visible = false
                t.Button.BackgroundTransparency = 0.3
                t.Button.TextColor3 = Theme.SubText
                for _, child in ipairs(t.SubButtonsFolder:GetChildren()) do
                    child.Visible = false
                end
            end
            tabContainer.Visible = true
            tabButton.BackgroundTransparency = 0
            tabButton.TextColor3 = Theme.Accent
            for _, child in ipairs(subTabButtonsFolder:GetChildren()) do
                child.Visible = true
            end
        end

        tabButton.MouseButton1Click:Connect(selectTab)

        table.insert(tabs, {
            Button = tabButton,
            Container = tabContainer,
            SubButtonsFolder = subTabButtonsFolder,
        })

        if firstTab then
            selectTab()
        end
        firstTab = false

        -- ===== САБВКЛАДКА =====
        function Tab:CreateSubTab(subName)
            local subButton = create("TextButton", {
                Text = subName,
                Size = UDim2.new(0, math.max(70, #subName * 8 + 24), 1, -8),
                BackgroundColor3 = Theme.Sidebar,
                BackgroundTransparency = firstSubTab and 0 or 0.4,
                AutoButtonColor = false,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = firstSubTab and Theme.Accent or Theme.SubText,
                Visible = firstTab == false and false or true, -- скорректируется selectTab-ом
                Parent = subTabButtonsFolder,
            }, { corner(6) })
            subButton.Visible = tabContainer.Visible

            local page = create("ScrollingFrame", {
                Name = subName .. "_Page",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 3,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible = firstSubTab,
                Parent = tabContainer,
            }, {
                create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }),
                create("UIPadding", { PaddingRight = UDim.new(0, 8) }),
            })

            local SubTab = {}
            local pages = { page }
            local buttons = { subButton }

            local function selectSubTab()
                for _, p in ipairs(pages) do p.Visible = false end
                for _, b in ipairs(buttons) do
                    b.BackgroundTransparency = 0.4
                    b.TextColor3 = Theme.SubText
                end
                page.Visible = true
                subButton.BackgroundTransparency = 0
                subButton.TextColor3 = Theme.Accent
            end
            subButton.MouseButton1Click:Connect(selectSubTab)

            -- регистрируем в общем списке кнопок вкладки, чтобы переключение вкладок скрывало чужие сабы
            table.insert(subTabs, { Button = subButton, Page = page, Select = selectSubTab })
            -- обновляем замыкание selectSubTab для соседних сабов той же вкладки
            for _, other in ipairs(subTabs) do
                table.insert(pages, other.Page)
                table.insert(buttons, other.Button)
            end

            if firstSubTab then selectSubTab() end
            firstSubTab = false

            -- ===== ЭЛЕМЕНТЫ =====

            function SubTab:CreateLabel(text)
                return create("TextLabel", {
                    Text = text,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = page,
                })
            end

            function SubTab:CreateCheckbox(text, default, callback)
                default = default or false
                callback = callback or function() end

                local holder = create("TextButton", {
                    Text = "",
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.ElementBg,
                    BackgroundTransparency = 0.15,
                    AutoButtonColor = false,
                    Parent = page,
                }, { corner(8) })

                local label = create("TextLabel", {
                    Text = text,
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = holder,
                })

                local box = create("Frame", {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -32, 0.5, -10),
                    BackgroundColor3 = default and Theme.Accent or Theme.Sidebar,
                    Parent = holder,
                }, { corner(6), stroke(Theme.Stroke, 1) })

                local checked = default
                local function refresh()
                    tween(box, { BackgroundColor3 = checked and Theme.Accent or Theme.Sidebar }, 0.15)
                end

                holder.MouseButton1Click:Connect(function()
                    checked = not checked
                    refresh()
                    callback(checked)
                end)

                return {
                    Set = function(_, value)
                        checked = value
                        refresh()
                        callback(checked)
                    end,
                    Get = function() return checked end,
                }
            end

            function SubTab:CreateColorPicker(text, default, callback)
                default = default or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end

                local h, s, v = Color3.toHSV(default)

                local holder = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = Theme.ElementBg,
                    BackgroundTransparency = 0.15,
                    ClipsDescendants = false,
                    Parent = page,
                }, { corner(8) })

                create("TextLabel", {
                    Text = text,
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = holder,
                })

                local swatch = create("TextButton", {
                    Text = "",
                    Size = UDim2.new(0, 26, 0, 20),
                    Position = UDim2.new(1, -38, 0.5, -10),
                    BackgroundColor3 = default,
                    AutoButtonColor = false,
                    Parent = holder,
                }, { corner(6), stroke(Theme.Stroke, 1) })

                -- панель выбора цвета (изначально скрыта)
                local picker = create("Frame", {
                    Size = UDim2.new(0, 200, 0, 170),
                    Position = UDim2.new(1, -200, 1, 6),
                    BackgroundColor3 = Theme.Background,
                    Visible = false,
                    ZIndex = 10,
                    Parent = holder,
                }, { corner(10), stroke(Theme.Stroke, 1) })

                local svBox = create("ImageButton", {
                    Size = UDim2.new(1, -20, 0, 110),
                    Position = UDim2.new(0, 10, 0, 10),
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    Image = "",
                    AutoButtonColor = false,
                    ZIndex = 11,
                    Parent = picker,
                }, { corner(6) })

                -- белый градиент слева направо (насыщенность)
                create("UIGradient", {
                    Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1),
                    }),
                    Parent = svBox,
                })
                -- чёрный градиент сверху вниз (яркость)
                local blackOverlay = create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(0,0,0),
                    BackgroundTransparency = 1,
                    ZIndex = 11,
                    Parent = svBox,
                }, { corner(6) })
                create("UIGradient", {
                    Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(1, 0),
                    }),
                    Rotation = 90,
                    Parent = blackOverlay,
                })

                local svCursor = create("Frame", {
                    Size = UDim2.new(0, 8, 0, 8),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(s, 0, 1 - v, 0),
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0,
                    ZIndex = 12,
                    Parent = svBox,
                }, { corner(4), stroke(Color3.fromRGB(0,0,0), 1) })

                local hueSlider = create("Frame", {
                    Size = UDim2.new(1, -20, 0, 16),
                    Position = UDim2.new(0, 10, 0, 128),
                    ZIndex = 11,
                    Parent = picker,
                }, { corner(6) })

                create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0, 1, 1)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(1/6, 1, 1)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(2/6, 1, 1)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromHSV(3/6, 1, 1)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(4/6, 1, 1)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(5/6, 1, 1)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1, 1, 1)),
                    }),
                    Parent = hueSlider,
                })

                local hueCursor = create("Frame", {
                    Size = UDim2.new(0, 4, 1, 4),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(h, 0, 0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0,
                    ZIndex = 12,
                    Parent = hueSlider,
                }, { corner(2), stroke(Color3.fromRGB(0,0,0), 1) })

                local function updateColor()
                    local color = Color3.fromHSV(h, s, v)
                    swatch.BackgroundColor3 = color
                    svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    callback(color)
                end

                local draggingSV, draggingHue = false, false

                svBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSV = true
                    end
                end)
                hueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        draggingHue = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSV = false
                        draggingHue = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseMovement
                        and input.UserInputType ~= Enum.UserInputType.Touch then return end

                    if draggingSV then
                        local abs = svBox.AbsolutePosition
                        local size = svBox.AbsoluteSize
                        local relX = math.clamp((input.Position.X - abs.X) / size.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - abs.Y) / size.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                        updateColor()
                    elseif draggingHue then
                        local abs = hueSlider.AbsolutePosition
                        local size = hueSlider.AbsoluteSize
                        local relX = math.clamp((input.Position.X - abs.X) / size.X, 0, 1)
                        h = relX
                        hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
                        updateColor()
                    end
                end)

                swatch.MouseButton1Click:Connect(function()
                    picker.Visible = not picker.Visible
                end)

                return {
                    Set = function(_, color)
                        h, s, v = Color3.toHSV(color)
                        svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                        hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
                        updateColor()
                    end,
                    Get = function() return Color3.fromHSV(h, s, v) end,
                }
            end

            return SubTab
        end

        return Tab
    end

    Window.SetVisible = setVisible
    Window.Gui = screenGui

    return Window
end

return UILibrary

--[[
    ===== ПРИМЕР ИСПОЛЬЗОВАНИЯ =====

    local Library = loadstring(game:HttpGet("URL_ДО_ЭТОГО_ФАЙЛА"))()

    local Window = Library:CreateWindow({
        Title = "Мой Хаб",
        ToggleKey = Enum.KeyCode.RightShift,
    })

    local MainTab = Window:CreateTab("Главная")
    local GeneralSub = MainTab:CreateSubTab("Общее")

    GeneralSub:CreateLabel("Настройки")

    GeneralSub:CreateCheckbox("Включить фичу", false, function(value)
        print("Чекбокс:", value)
    end)

    GeneralSub:CreateColorPicker("Цвет ESP", Color3.fromRGB(255, 0, 0), function(color)
        print("Выбран цвет:", color)
    end)

    local VisualsTab = Window:CreateTab("Визуал")
    local ColorsSub = VisualsTab:CreateSubTab("Цвета")
    ColorsSub:CreateCheckbox("Радужный режим", false, function(v) end)
]]
