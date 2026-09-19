local Kavo = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}
function Kavo:DraggingEnabled(frame, parent)
        
    parent = parent or frame
    
    -- stolen from wally or kiriot, kek
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end


local themes = {
    SchemeColor = Color3.fromRGB(74, 99, 135),
    Background = Color3.fromRGB(36, 37, 43),
    Header = Color3.fromRGB(28, 29, 34),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(32, 32, 38)
}
local themeStyles = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255,255,255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0,0,0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    BloodTheme = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    GrapeTheme = {
        SchemeColor = Color3.fromRGB(166, 71, 214),
        Background = Color3.fromRGB(64, 50, 71),
        Header = Color3.fromRGB(36, 28, 41),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(74, 58, 84)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background = Color3.fromRGB(26, 32, 58),
        Header = Color3.fromRGB(38, 45, 71),
        TextColor = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71)
    },
    Midnight = {
        SchemeColor = Color3.fromRGB(26, 189, 158),
        Background = Color3.fromRGB(44, 62, 82),
        Header = Color3.fromRGB(57, 81, 105),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(52, 74, 95)
    },
    Sentinel = {
        SchemeColor = Color3.fromRGB(230, 35, 69),
        Background = Color3.fromRGB(32, 32, 32),
        Header = Color3.fromRGB(24, 24, 24),
        TextColor = Color3.fromRGB(119, 209, 138),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Synapse = {
        SchemeColor = Color3.fromRGB(46, 48, 43),
        Background = Color3.fromRGB(13, 15, 12),
        Header = Color3.fromRGB(36, 38, 35),
        TextColor = Color3.fromRGB(152, 99, 53),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Serpent = {
        SchemeColor = Color3.fromRGB(0, 166, 58),
        Background = Color3.fromRGB(31, 41, 43),
        Header = Color3.fromRGB(22, 29, 31),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(22, 29, 31)
    }
}
local oldTheme = ""

local SettingsT = {

}

local Name = "KavoConfig.JSON"

pcall(function()

if not pcall(function() readfile(Name) end) then
writefile(Name, game:service'HttpService':JSONEncode(SettingsT))
end

Settings = game:service'HttpService':JSONEncode(readfile(Name))
end)

local LibName = tostring(math.random(1, 100))..tostring(math.random(1,50))..tostring(math.random(1, 100))

local guiVisible = true

function Kavo:ToggleUI()
    local gui = game.CoreGui[LibName]
    local mainFrame = gui:FindFirstChild("Main", true)
    local blur = game:GetService("Lighting"):FindFirstChild("KavoBlur")

    if guiVisible then
        guiVisible = false
        if mainFrame then
            game.TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(
                    0, mainFrame.AbsolutePosition.X + (mainFrame.AbsoluteSize.X / 2),
                    0, mainFrame.AbsolutePosition.Y + (mainFrame.AbsoluteSize.Y / 2)
                )
            }):Play()
        end
        task.delay(0.36, function()
            gui.Enabled = false
        end)
    else
        guiVisible = true
        gui.Enabled = true
        if mainFrame then
            local savedPos = mainFrame:GetAttribute("SavedPosition")
            local savedSize = mainFrame:GetAttribute("SavedSize")
            if savedPos and savedSize then
                mainFrame.Position = savedPos
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                game.TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = savedSize
                }):Play()
            end
        end
    end
end

-- =====================================================================
--  ФЛАГИ / ФОН (png, gif) / OVERLAY / SIZE
--  CreateLib("назва", "тема", "gif=url", "overlay=40%", "size=500x350")
-- =====================================================================
local AssetService = game:GetService("AssetService")

local FLAG_KEYS = {
    png = true, jpg = true, jpeg = true, gif = true, img = true, image = true,
    size = true, overlay = true, fit = true,
}

local function parseFlag(str)
    if type(str) ~= "string" then return nil end
    local key, value = str:match("^%s*(%w+)%s*=%s*(.-)%s*$")
    if key and FLAG_KEYS[key:lower()] then
        return key:lower(), value
    end
    return nil
end

-- Розбирає аргументи: прапорці (key=value) можуть стояти де завгодно,
-- решта аргументів: 1-й = назва, 2-й = тема (рядок або таблиця)
local function ParseCreateArgs(...)
    local n = select("#", ...)
    local args = {...}
    local flags = {}
    local name, theme
    local p = 0
    for i = 1, n do
        local v = args[i]
        local key, value = parseFlag(v)
        if key then
            if key == "png" or key == "jpg" or key == "jpeg" or key == "gif" or key == "img" then
                key = "image"
            end
            flags[key] = value
        else
            p = p + 1
            if p == 1 then
                name = v
            elseif p == 2 then
                theme = v
            end
        end
    end
    return name, theme, flags
end

local function httpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 0 then
        return res
    end
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local ok2, r = pcall(req, {Url = url, Method = "GET"})
        if ok2 and type(r) == "table" and type(r.Body) == "string" and #r.Body > 0 then
            return r.Body
        end
    end
    return nil
end

local function urlHash(str)
    local h = 5381
    for i = 1, #str do
        h = (h * 33 + string.byte(str, i)) % 4294967296
    end
    return tostring(h)
end

-- Статичне зображення (png/jpg): зберігаємо файл і беремо через getcustomasset
local function staticAsset(data, url)
    local ext = ".png"
    if data:sub(1, 2) == "\255\216" then ext = ".jpg" end
    local fileName = "KavoBG_" .. urlHash(url) .. ext
    writefile(fileName, data)
    local getAsset = getcustomasset or getsynasset
    if not getAsset then
        error("executor не підтримує getcustomasset")
    end
    return getAsset(fileName)
end

-- ---------------------------------------------------------------------
--  Декодер GIF (Roblox сам не вміє показувати gif, тому розкладаємо на кадри)
-- ---------------------------------------------------------------------
local function lzwDecode(stream, minCode, total)
    local byte, band, rshift, lshift = string.byte, bit32.band, bit32.rshift, bit32.lshift
    local out = table.create(total, 0)
    local outN = 0
    local clear = lshift(1, minCode)
    local eoi = clear + 1
    local codeSize = minCode + 1
    local nextCode = eoi + 1
    local prefix, suffix = {}, {}
    for i = 0, clear - 1 do suffix[i] = i end
    local stack = {}
    local bitBuf, bitCnt, sp, slen = 0, 0, 1, #stream
    local prev, prevFirst

    while outN < total do
        while bitCnt < codeSize and sp <= slen do
            bitBuf = bitBuf + lshift(byte(stream, sp), bitCnt)
            sp = sp + 1
            bitCnt = bitCnt + 8
        end
        if bitCnt < codeSize then break end
        local code = band(bitBuf, lshift(1, codeSize) - 1)
        bitBuf = rshift(bitBuf, codeSize)
        bitCnt = bitCnt - codeSize

        if code == eoi then
            break
        elseif code == clear then
            codeSize = minCode + 1
            nextCode = eoi + 1
            prev = nil
        elseif prev == nil then
            local v = suffix[code] or 0
            outN = outN + 1
            out[outN] = v
            prev = code
            prevFirst = v
        else
            if code > nextCode then break end
            local entry = code
            local sn = 0
            if code >= nextCode then
                sn = 1
                stack[1] = prevFirst
                entry = prev
            end
            local c = entry
            while c > eoi do
                sn = sn + 1
                stack[sn] = suffix[c]
                c = prefix[c]
            end
            sn = sn + 1
            stack[sn] = suffix[c]
            local firstByte = suffix[c]
            for i = sn, 1, -1 do
                outN = outN + 1
                out[outN] = stack[i]
            end
            if nextCode < 4096 then
                prefix[nextCode] = prev
                suffix[nextCode] = firstByte
                nextCode = nextCode + 1
                if nextCode >= lshift(1, codeSize) and codeSize < 12 then
                    codeSize = codeSize + 1
                end
            end
            prev = code
            prevFirst = firstByte
        end
    end
    return out
end

-- onSize(w, h) викликається один раз, onFrame({data = buffer RGBA, delay = сек}) — на кожен кадр
local function DecodeGif(data, onSize, onFrame)
    local byte, band, rshift, lshift = string.byte, bit32.band, bit32.rshift, bit32.lshift
    local pos, len = 1, #data

    local function u8()
        local v = byte(data, pos)
        pos = pos + 1
        return v or 0
    end
    local function u16()
        local a, b = byte(data, pos, pos + 1)
        pos = pos + 2
        return (a or 0) + (b or 0) * 256
    end
    local function skipBlocks()
        while pos <= len do
            local n = u8()
            if n == 0 then break end
            pos = pos + n
        end
    end
    local function readPalette(count)
        local pal = {}
        for i = 0, count - 1 do
            local r, g, b = byte(data, pos, pos + 2)
            pos = pos + 3
            pal[i] = (r or 0) + (g or 0) * 256 + (b or 0) * 65536 + 4278190080
        end
        return pal
    end

    if data:sub(1, 3) ~= "GIF" then return false end
    pos = 7
    local W, H = u16(), u16()
    local gflags = u8()
    u8(); u8()
    if W == 0 or H == 0 then return false end
    local globalPal
    if band(gflags, 0x80) ~= 0 then
        globalPal = readPalette(lshift(1, band(gflags, 7) + 1))
    end

    onSize(W, H)

    local frameBytes = W * H * 4
    local canvas = buffer.create(frameBytes)
    local maxFrames = math.min(300, math.max(1, math.floor(96 * 1024 * 1024 / frameBytes)))
    local count = 0
    local gDelay, gDispose, gTransp = 10, 0, nil
    local prevDispose, prevX, prevY, prevW, prevH = 0, 0, 0, 0, 0
    local saved
    local work = 0

    while pos <= len and count < maxFrames do
        local block = u8()
        if block == 0x3B then
            break
        elseif block == 0x21 then
            local label = u8()
            if label == 0xF9 then
                local size = u8()
                local pk = u8()
                local d = u16()
                local ti = u8()
                pos = pos + math.max(0, size - 4)
                gDispose = band(rshift(pk, 2), 7)
                gDelay = d
                gTransp = (band(pk, 1) == 1) and ti or nil
            end
            skipBlocks()
        elseif block == 0x2C then
            local ix, iy, iw, ih = u16(), u16(), u16(), u16()
            local ipk = u8()
            local pal = globalPal
            if band(ipk, 0x80) ~= 0 then
                pal = readPalette(lshift(1, band(ipk, 7) + 1))
            end
            local interlaced = band(ipk, 0x40) ~= 0
            local minCode = u8()
            local chunks = {}
            while pos <= len do
                local n = u8()
                if n == 0 then break end
                chunks[#chunks + 1] = string.sub(data, pos, pos + n - 1)
                pos = pos + n
            end
            local idx = lzwDecode(table.concat(chunks), minCode, iw * ih)

            -- disposal попереднього кадру
            if prevDispose == 2 then
                for y = prevY, math.min(prevY + prevH, H) - 1 do
                    for x = prevX, math.min(prevX + prevW, W) - 1 do
                        buffer.writeu32(canvas, (y * W + x) * 4, 0)
                    end
                end
            elseif prevDispose == 3 and saved then
                buffer.copy(canvas, 0, saved)
            end
            if gDispose == 3 then
                saved = buffer.create(frameBytes)
                buffer.copy(saved, 0, canvas)
            end

            local rowMap = {}
            if interlaced then
                local r = 0
                for _, pass in ipairs({{0, 8}, {4, 8}, {2, 4}, {1, 2}}) do
                    for y = pass[1], ih - 1, pass[2] do
                        rowMap[r] = y
                        r = r + 1
                    end
                end
            end

            if pal then
                for r = 0, ih - 1 do
                    local y = iy + (interlaced and rowMap[r] or r)
                    if y >= 0 and y < H then
                        local base = r * iw + 1
                        for x = 0, iw - 1 do
                            local px = ix + x
                            if px < W then
                                local ci = idx[base + x]
                                if ci ~= gTransp then
                                    local color = pal[ci]
                                    if color then
                                        buffer.writeu32(canvas, (y * W + px) * 4, color)
                                    end
                                end
                            end
                        end
                    end
                    work = work + iw
                    if work > 40000 then
                        work = 0
                        task.wait()
                    end
                end
            end

            local snap = buffer.create(frameBytes)
            buffer.copy(snap, 0, canvas)
            count = count + 1
            onFrame({data = snap, delay = (gDelay < 2) and 0.1 or (gDelay / 100)})

            prevDispose, prevX, prevY, prevW, prevH = gDispose, ix, iy, iw, ih
            gDispose, gDelay, gTransp = 0, 10, nil
        else
            break
        end
    end
    return true
end

local function PlayGif(bg, ScreenGui, data, onShown)
    local frames = {}
    local decoded = false
    local img, size

    local function onSize(w, h)
        size = Vector2.new(w, h)
        local made = pcall(function()
            img = AssetService:CreateEditableImage({Size = size})
            bg.ImageContent = Content.fromObject(img)
        end)
        if not made then
            made = pcall(function()
                if img then pcall(function() img:Destroy() end) end
                img = Instance.new("EditableImage")
                img.Size = size
                img.Parent = bg
            end)
        end
        if not made then
            error("EditableImage недоступний у цьому executor'і (потрібен для gif)")
        end
    end

    task.spawn(function()
        local ok, res = pcall(DecodeGif, data, onSize, function(f)
            frames[#frames + 1] = f
        end)
        decoded = true
        if not ok then
            warn("[Kavo] GIF: " .. tostring(res))
        elseif res == false then
            warn("[Kavo] GIF: некоректний файл")
        end
    end)

    task.spawn(function()
        local i, shown = 1, false
        while ScreenGui.Parent do
            local f = frames[i]
            if f and img then
                pcall(function() img:WritePixelsBuffer(Vector2.zero, size, f.data) end)
                if not shown then
                    shown = true
                    onShown()
                end
                if decoded and #frames == 1 then break end
                task.wait(f.delay)
                i = i + 1
            elseif decoded and #frames > 0 then
                i = 1
            elseif decoded then
                break
            else
                task.wait(0.05)
            end
        end
        if img then pcall(function() img:Destroy() end) end
    end)
end

-- Створює фон (ImageLabel + overlay) у Main. onReady викликається, коли картинка реально з'явилась.
local function AttachBackground(Main, ScreenGui, themeList, flags, onReady)
    local source = flags.image
    if not source or source == "" then return end

    local bg = Instance.new("ImageLabel")
    bg.Name = "BackgroundImage"
    bg.Parent = Main
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.Size = UDim2.new(1, 0, 1, 0)      -- завжди на все вікно (розтягується)
    bg.ScaleType = (flags.fit == "crop") and Enum.ScaleType.Crop or Enum.ScaleType.Stretch
    bg.ClipsDescendants = true
    bg.ZIndex = 0
    bg.Visible = false

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = bg

    -- overlay: шар кольору теми поверх картинки (0% = нема, 100% = картинку не видно)
    local pct = tonumber((tostring(flags.overlay or "0"):gsub("%%", ""))) or 0
    pct = math.clamp(pct, 0, 100)
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Parent = bg
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.ZIndex = 1
    overlay.BackgroundColor3 = themeList.Background
    overlay.BackgroundTransparency = 1 - (pct / 100)

    task.spawn(function()
        while ScreenGui.Parent do
            overlay.BackgroundColor3 = themeList.Background
            task.wait(0.25)
        end
    end)

    local function shown()
        bg.Visible = true
        onReady()
    end

    task.spawn(function()
        local ok, err = pcall(function()
            if source:match("^rbxassetid://") or source:match("^rbxasset://") then
                bg.Image = source
                shown()
            elseif source:match("^%d+$") then
                bg.Image = "rbxassetid://" .. source
                shown()
            else
                if not source:find("://", 1, true) then
                    source = "https://" .. source
                end
                local data = httpGet(source)
                if not data then
                    error("не вдалося завантажити " .. source)
                end
                if data:sub(1, 3) == "GIF" then
                    PlayGif(bg, ScreenGui, data, shown)
                else
                    bg.Image = staticAsset(data, source)
                    shown()
                end
            end
        end)
        if not ok then
            warn("[Kavo] Фон: " .. tostring(err))
        end
    end)
end

-- =====================================================================
--  ДИЗАЙН: nop.lua (index.html + global.css)
--  #1a1a1a фон / #313131 вікно / #272727 панелі / #251f25 обводка
--  #231f23 інпути / #8b828b підписи / #f9faff текст / #e600ac акцент
-- =====================================================================

themes.SchemeColor  = Color3.fromRGB(230, 0, 172)   -- #e600ac
themes.Background   = Color3.fromRGB(49, 49, 49)    -- #313131
themes.Header       = Color3.fromRGB(39, 39, 39)    -- #272727
themes.TextColor    = Color3.fromRGB(255, 255, 255)
themes.ElementColor = Color3.fromRGB(35, 31, 35)    -- #231f23

local STROKE_COLOR = Color3.fromRGB(37, 31, 37)     -- #251f25
local SOFT_COLOR   = Color3.fromRGB(249, 250, 255)  -- #f9faff
local MUTED_COLOR  = Color3.fromRGB(139, 130, 139)  -- #8b828b
local TABTEXT_COLOR= Color3.fromRGB(239, 240, 255)  -- #eff0ff
local TABBG_COLOR  = Color3.fromRGB(197, 197, 197)  -- rgba(197,197,197,.08)
local TABSTR_COLOR = Color3.fromRGB(115, 115, 115)  -- rgba(115,115,115,.2)

local FONT      = Enum.Font.Gotham
local FONT_BOLD = Enum.Font.GothamBold

local ActiveGui       -- ScreenGui останнього створеного меню
local AccentObjects = {}

-- ---------- дрібні помічники ----------
local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

local function stroke(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or STROKE_COLOR
    s.Thickness = 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function padd(obj, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, t)
    p.PaddingBottom = UDim.new(0, b)
    p.PaddingLeft = UDim.new(0, l)
    p.PaddingRight = UDim.new(0, r)
    p.Parent = obj
    return p
end

local function layout(obj, horizontal, gap, align)
    local l = Instance.new("UIListLayout")
    l.FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, gap or 0)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    l.HorizontalAlignment = align or Enum.HorizontalAlignment.Left
    if not horizontal then
        l.VerticalAlignment = Enum.VerticalAlignment.Top
    end
    l.Parent = obj
    return l
end

local function accent(obj, prop)
    table.insert(AccentObjects, {obj = obj, prop = prop})
end

function Kavo:ToggleUI()
    local gui = ActiveGui
    if not gui then return end
    local mainFrame = gui:FindFirstChild("Main", true)

    if guiVisible then
        guiVisible = false
        if mainFrame then
            mainFrame:SetAttribute("SavedPosition", mainFrame.Position)
            mainFrame:SetAttribute("SavedSize", mainFrame.Size)
            tween:Create(mainFrame, tweeninfo(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(
                    0, mainFrame.AbsolutePosition.X + (mainFrame.AbsoluteSize.X / 2),
                    0, mainFrame.AbsolutePosition.Y + (mainFrame.AbsoluteSize.Y / 2)
                )
            }):Play()
        end
        task.delay(0.3, function()
            if gui then gui.Enabled = false end
        end)
    else
        guiVisible = true
        gui.Enabled = true
        if mainFrame then
            local savedPos = mainFrame:GetAttribute("SavedPosition")
            local savedSize = mainFrame:GetAttribute("SavedSize")
            if savedPos and savedSize then
                mainFrame.Position = savedPos
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                tween:Create(mainFrame, tweeninfo(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = savedSize
                }):Play()
            end
        end
    end
end

function Kavo.CreateLib(...)
    local kavName, themeList, flags = ParseCreateArgs(...)

    if type(themeList) == "string" then
        themeList = themeStyles[themeList] or themes
    end
    if type(themeList) ~= "table" then
        themeList = themes
    end
    themeList.SchemeColor  = themeList.SchemeColor  or themes.SchemeColor
    themeList.Background   = themeList.Background   or themes.Background
    themeList.Header       = themeList.Header       or themes.Header
    themeList.TextColor    = themeList.TextColor    or themes.TextColor
    themeList.ElementColor = themeList.ElementColor or themes.ElementColor

    kavName = kavName or "nop.lua"
    table.insert(Kavo, kavName)

    -- палітра з теми (за замовчуванням = кольори з global.css)
    local P = {
        Window = themeList.Background,
        Panel  = themeList.Header,
        Input  = themeList.ElementColor,
        Text   = themeList.TextColor,
        Accent = themeList.SchemeColor,
        Soft   = SOFT_COLOR,
        Muted  = MUTED_COLOR,
        Stroke = STROKE_COLOR,
    }

    -- розмір вікна: size=708x460
    local winW, winH = 708, 460
    if flags.size then
        local w, h = tostring(flags.size):match("^(%d+)%s*[xX%*]%s*(%d+)$")
        if w then
            winW, winH = tonumber(w), tonumber(h)
        end
    end

    local COLUMNS = 3
    local COL_GAP = 13
    local PAD_X, PAD_Y = 13, 22
    local colW = math.floor((winW - PAD_X * 2 - COL_GAP * (COLUMNS - 1)) / COLUMNS)

    local guiParent = game:GetService("CoreGui")
    pcall(function()
        if gethui then guiParent = gethui() end
    end)
    for _, v in pairs(guiParent:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == kavName or v.Name == LibName) then
            v:Destroy()
        end
    end

    local ScreenGui = new("ScreenGui", {
        Name = LibName,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    }, guiParent)
    ActiveGui = ScreenGui
    guiVisible = true

    local Main = new("Frame", {
        Name = "Main",
        BackgroundColor3 = P.Window,
        BorderSizePixel = 0,
        Size = UDim2.new(0, winW, 0, winH),
        Position = UDim2.new(0.5, -winW / 2, 0.5, -winH / 2),
        ClipsDescendants = true,
    }, ScreenGui)
    Objects[Main] = "BackgroundColor3"
    corner(Main, 10)
    Main:SetAttribute("SavedSize", Main.Size)
    Main:SetAttribute("SavedPosition", Main.Position)

    AttachBackground(Main, ScreenGui, themeList, flags, function() end)

    local root = new("Frame", {
        Name = "Root",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2,
    }, Main)
    padd(root, PAD_Y, PAD_Y, PAD_X, PAD_X)

    -- ------------------------------ HEADER ------------------------------
    local header = new("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 26),
        ZIndex = 2,
    }, root)
    Kavo:DraggingEnabled(header, Main)

    local logoGroup = new("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 220, 1, 0),
    }, header)

    local mark1 = new("Frame", {
        BackgroundColor3 = P.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 9, 0, 22),
        Position = UDim2.new(0, 2, 0, 2),
        Rotation = 18,
    }, logoGroup)
    corner(mark1, 3)
    accent(mark1, "BackgroundColor3")

    local mark2 = new("Frame", {
        BackgroundColor3 = SOFT_COLOR,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 9, 0, 22),
        Position = UDim2.new(0, 12, 0, 2),
        Rotation = -18,
    }, logoGroup)
    corner(mark2, 3)

    new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = FONT_BOLD,
        Text = kavName,
        TextSize = 14,
        TextColor3 = P.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
    }, logoGroup)

    local tabHolder = new("Frame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -230, 1, 0),
        Position = UDim2.new(0, 230, 0, 0),
        ZIndex = 2,
    }, header)
    layout(tabHolder, true, 8, Enum.HorizontalAlignment.Right)

    -- ----------------------------- WORKSPACE -----------------------------
    local workspaceFrame = new("Frame", {
        Name = "Workspace",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 42),
        Size = UDim2.new(1, 0, 1, -42),
        ZIndex = 2,
    }, root)

    -- сумісність зі старим API
    function Kavo:SetMenuBlur() end
    function Kavo:ChangeFontSize() end
    function Kavo:ChangeMenuFont(font)
        for _, v in pairs(Main:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                v.Font = font
            end
        end
    end
    function Kavo:ChangeColor(prope, color)
        if prope == "SchemeColor" then
            P.Accent = color
            for _, d in pairs(AccentObjects) do
                pcall(function() d.obj[d.prop] = color end)
            end
        elseif prope == "Background" then
            P.Window = color
            Main.BackgroundColor3 = color
        end
        themeList[prope] = color
    end

    local Tabs = {}
    local tabList = {}
    local selected

    function Tabs:NewTab(tabName)
        tabName = tabName or "tab"

        local page = new("ScrollingFrame", {
            Name = tabName,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = P.Stroke,
            Visible = false,
            ZIndex = 2,
        }, workspaceFrame)

        local holder = new("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
        }, page)
        layout(holder, true, COL_GAP).VerticalAlignment = Enum.VerticalAlignment.Top

        local columns, colHeight = {}, {}
        for i = 1, COLUMNS do
            local col = new("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, colW, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = i,
                ZIndex = 2,
            }, holder)
            layout(col, false, 16)
            columns[i] = col
            colHeight[i] = 0
        end

        local tabBtn = new("TextButton", {
            BackgroundColor3 = TABBG_COLOR,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = "",
            Size = UDim2.new(0, 0, 0, 30),
            AutomaticSize = Enum.AutomaticSize.X,
        }, tabHolder)
        corner(tabBtn, 8)
        local tabStroke = stroke(tabBtn, TABSTR_COLOR, 1)
        padd(tabBtn, 8, 8, 16, 16)

        local tabLabel = new("TextLabel", {
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            Size = UDim2.new(0, 0, 0, 0),
            Font = FONT,
            Text = tabName,
            TextSize = 12,
            TextColor3 = TABTEXT_COLOR,
        }, tabBtn)

        local entry = {btn = tabBtn, page = page, stroke = tabStroke, label = tabLabel}
        table.insert(tabList, entry)

        local function select()
            for _, t in pairs(tabList) do
                local on = (t == entry)
                t.page.Visible = on
                Utility:TweenObject(t.btn, {BackgroundTransparency = on and 0.92 or 1}, 0.15)
                t.stroke.Transparency = on and 0.8 or 1
                t.label.TextColor3 = on and P.Text or TABTEXT_COLOR
            end
            selected = entry
        end

        tabBtn.MouseButton1Click:Connect(select)
        if not selected then select() end

        local Sections = {}

        function Sections:NewSection(secName, hidden)
            secName = secName or "section"

            -- панель іде в найкоротшу колонку
            local target, best = 1, colHeight[1]
            for i = 2, COLUMNS do
                if colHeight[i] < best then
                    target, best = i, colHeight[i]
                end
            end
            local function bump(px)
                colHeight[target] = colHeight[target] + px
            end
            bump(hidden and 32 or 73)

            local panel = new("Frame", {
                BackgroundColor3 = P.Panel,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
            }, columns[target])
            Objects[panel] = "BackgroundColor3"
            corner(panel, 8)
            stroke(panel, P.Stroke)
            padd(panel, 16, 16, 16, 16)
            layout(panel, false, 12)

            local head = new("TextButton", {
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Text = "",
                Size = UDim2.new(1, 0, 0, 16),
                LayoutOrder = 1,
                Visible = not hidden,
                ZIndex = 2,
            }, panel)

            new("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -16, 1, 0),
                Font = FONT_BOLD,
                Text = secName,
                TextSize = 13,
                TextColor3 = P.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2,
            }, head)

            local arrow = new("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 1, 0),
                Position = UDim2.new(1, -14, 0, 0),
                Font = FONT,
                Text = "▾",
                TextSize = 12,
                TextColor3 = P.Muted,
                ZIndex = 2,
            }, head)

            local divider = new("Frame", {
                BackgroundColor3 = P.Stroke,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1),
                LayoutOrder = 2,
                Visible = not hidden,
                ZIndex = 2,
            }, panel)

            local content = new("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = 3,
                ZIndex = 2,
            }, panel)
            layout(content, false, 12)

            head.MouseButton1Click:Connect(function()
                content.Visible = not content.Visible
                arrow.Rotation = content.Visible and 0 or 180
            end)

            -- ------------------- базові цеглинки -------------------
            local order = 0
            local function place(obj, h)
                order = order + 1
                obj.LayoutOrder = order
                obj.Parent = content
                bump((h or 16) + 12)
                return obj
            end

            local function makeRow(h)
                return new("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, h),
                    ZIndex = 2,
                })
            end

            local function makeBox(parent, w, h)
                local box = new("Frame", {
                    BackgroundColor3 = P.Input,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, w, 0, h),
                    Position = UDim2.new(1, -w, 0.5, -h / 2),
                    ZIndex = 2,
                }, parent)
                Objects[box] = "BackgroundColor3"
                corner(box, 4)
                stroke(box, P.Stroke)
                return box
            end

            local function makeLabel(parent, text, width)
                return new("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -width, 1, 0),
                    Font = FONT,
                    Text = text,
                    TextSize = 11,
                    TextColor3 = P.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 2,
                }, parent)
            end

            -- слайдер у стилі .slider-row (трек 80px + бокс значення 36px)
            local function buildSlider(parent, text, minvalue, maxvalue, default, pink, cb)
                local row = makeRow(22)
                row.Parent = parent

                local lbl = makeLabel(row, text, 136)

                local bar = new("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 80, 0, 16),
                    Position = UDim2.new(1, -128, 0.5, -8),
                    ZIndex = 2,
                }, row)

                local track = new("Frame", {
                    Name = "Track",
                    BackgroundColor3 = P.Input,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 4),
                    Position = UDim2.new(0, 0, 0.5, -2),
                    ZIndex = 2,
                }, bar)
                Objects[track] = "BackgroundColor3"
                corner(track, 2)

                local fill = new("Frame", {
                    BackgroundColor3 = pink and P.Accent or SOFT_COLOR,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 0, 0, 4),
                    Position = UDim2.new(0, 0, 0.5, -2),
                    ZIndex = 3,
                }, bar)
                corner(fill, 2)
                if pink then accent(fill, "BackgroundColor3") end

                local thumb = new("Frame", {
                    BackgroundColor3 = SOFT_COLOR,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, -6, 0.5, -6),
                    ZIndex = 4,
                }, bar)
                corner(thumb, 6)

                local valueBox = makeBox(row, 36, 22)
                local valueText = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = FONT,
                    Text = "0",
                    TextSize = 11,
                    TextColor3 = SOFT_COLOR,
                    ZIndex = 3,
                }, valueBox)

                local hit = new("TextButton", {
                    BackgroundTransparency = 1,
                    Text = "",
                    Size = UDim2.new(1, 8, 1, 6),
                    Position = UDim2.new(0, -4, 0, -3),
                    ZIndex = 5,
                }, bar)

                local value = math.clamp(default or minvalue, minvalue, maxvalue)

                local function render()
                    local pct = 0
                    if maxvalue ~= minvalue then
                        pct = (value - minvalue) / (maxvalue - minvalue)
                    end
                    fill.Size = UDim2.new(pct, 0, 0, 4)
                    thumb.Position = UDim2.new(pct, -6, 0.5, -6)
                    valueText.Text = tostring(value)
                end

                local function setValue(v, fire)
                    local n = tonumber(v) or minvalue
                    n = math.clamp(math.floor(n + 0.5), minvalue, maxvalue)
                    local changed = (n ~= value)
                    value = n
                    render()
                    if fire and changed then
                        pcall(cb, value)
                    end
                end

                local function fromX(x)
                    local rel = (x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1)
                    rel = math.clamp(rel, 0, 1)
                    setValue(minvalue + rel * (maxvalue - minvalue), true)
                end

                local dragging = false
                hit.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        fromX(i.Position.X)
                    end
                end)
                input.InputChanged:Connect(function(i)
                    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                    or i.UserInputType == Enum.UserInputType.Touch) then
                        fromX(i.Position.X)
                    end
                end)
                input.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                render()
                return row, lbl, setValue, function() return value end
            end

            local Elements = {}

            -- ----------------------- TOGGLE (.checkbox-row) -----------------------
            function Elements:NewToggle(tname, nTip, callback)
                callback = callback or function() end
                local row = makeRow(14)

                local box = new("Frame", {
                    BackgroundColor3 = P.Input,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, 0, 0.5, -7),
                    ZIndex = 2,
                }, row)
                Objects[box] = "BackgroundColor3"
                corner(box, 3)
                stroke(box, P.Stroke)

                local fill = new("Frame", {
                    BackgroundColor3 = P.Accent,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, -6, 1, -6),
                    Position = UDim2.new(0, 3, 0, 3),
                    ZIndex = 3,
                }, box)
                corner(fill, 2)
                accent(fill, "BackgroundColor3")

                local lbl = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 24, 0, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Font = FONT,
                    Text = tname or "toggle",
                    TextSize = 11,
                    TextColor3 = P.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 2,
                }, row)

                local btn = new("TextButton", {
                    BackgroundTransparency = 1,
                    Text = "",
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 4,
                }, row)

                local state = false
                local function set(v, fire)
                    state = v and true or false
                    Utility:TweenObject(fill, {BackgroundTransparency = state and 0 or 1}, 0.12)
                    lbl.TextColor3 = state and SOFT_COLOR or P.Muted
                    if fire then pcall(callback, state) end
                end

                btn.MouseButton1Click:Connect(function()
                    set(not state, true)
                end)

                place(row, 14)

                local TogFunction = {}
                function TogFunction:UpdateToggle(newText, isTogOn)
                    if newText then lbl.Text = newText end
                    if type(isTogOn) == "boolean" then set(isTogOn, false) end
                end
                function TogFunction:Set(v)
                    set(v, true)
                end
                function TogFunction:Get()
                    return state
                end
                return TogFunction
            end

            -- ----------------------- SLIDER (.slider-row) -----------------------
            function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
                callback = callback or function() end
                maxvalue = tonumber(maxvalue) or 100
                minvalue = tonumber(minvalue) or 0

                local row, lbl, setValue, getValue =
                    buildSlider(content, slidInf or "slider", minvalue, maxvalue, minvalue, false, callback)
                place(row, 22)

                local SlidFunction = {}
                function SlidFunction:UpdateSlider(newText, newValue)
                    if newText then lbl.Text = newText end
                    if newValue then setValue(newValue, false) end
                end
                function SlidFunction:Set(v)
                    setValue(v, true)
                end
                function SlidFunction:Get()
                    return getValue()
                end
                return SlidFunction
            end

            -- ----------------- SLIDER (рожевий, як pitch/yaw у макеті) -----------------
            function Elements:NewSliderPink(slidInf, slidTip, maxvalue, minvalue, callback)
                callback = callback or function() end
                maxvalue = tonumber(maxvalue) or 100
                minvalue = tonumber(minvalue) or 0

                local row, lbl, setValue, getValue =
                    buildSlider(content, slidInf or "slider", minvalue, maxvalue, minvalue, true, callback)
                place(row, 22)

                local SlidFunction = {}
                function SlidFunction:UpdateSlider(newText, newValue)
                    if newText then lbl.Text = newText end
                    if newValue then setValue(newValue, false) end
                end
                function SlidFunction:Set(v) setValue(v, true) end
                function SlidFunction:Get() return getValue() end
                return SlidFunction
            end

            -- ----------------------- DROPDOWN (.dropdown-row) -----------------------
            function Elements:NewDropdown(dropname, dropinf, options, callback)
                callback = callback or function() end
                options = options or {}

                local holder = new("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 2,
                })
                layout(holder, false, 8)

                local row = makeRow(22)
                row.LayoutOrder = 1
                row.Parent = holder
                makeLabel(row, dropname or "dropdown", 120)

                local boxBtn = new("TextButton", {
                    BackgroundColor3 = P.Input,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Text = "",
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.new(0, 0, 0, 22),
                    Position = UDim2.new(1, 0, 0.5, -11),
                    AnchorPoint = Vector2.new(1, 0),
                    ZIndex = 2,
                }, row)
                Objects[boxBtn] = "BackgroundColor3"
                corner(boxBtn, 4)
                stroke(boxBtn, P.Stroke)
                padd(boxBtn, 0, 0, 12, 12)

                local boxText = new("TextLabel", {
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.new(0, 0, 1, 0),
                    Font = FONT_BOLD,
                    Text = string.upper(tostring(options[1] or "none")),
                    TextSize = 10,
                    TextColor3 = P.Text,
                    ZIndex = 3,
                }, boxBtn)

                local optionHolder = new("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 2,
                    Visible = false,
                    ZIndex = 2,
                }, holder)
                layout(optionHolder, false, 4)

                local opened = false
                local function build(list)
                    for _, c in pairs(optionHolder:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for i, v in pairs(list) do
                        local opt = new("TextButton", {
                            BackgroundColor3 = P.Input,
                            BorderSizePixel = 0,
                            AutoButtonColor = false,
                            Size = UDim2.new(1, 0, 0, 22),
                            LayoutOrder = i,
                            Font = FONT_BOLD,
                            Text = string.upper(tostring(v)),
                            TextSize = 10,
                            TextColor3 = P.Muted,
                            ZIndex = 3,
                        }, optionHolder)
                        Objects[opt] = "BackgroundColor3"
                        corner(opt, 4)
                        stroke(opt, P.Stroke)

                        opt.MouseEnter:Connect(function()
                            opt.TextColor3 = SOFT_COLOR
                        end)
                        opt.MouseLeave:Connect(function()
                            opt.TextColor3 = P.Muted
                        end)
                        opt.MouseButton1Click:Connect(function()
                            boxText.Text = string.upper(tostring(v))
                            opened = false
                            optionHolder.Visible = false
                            pcall(callback, v)
                        end)
                    end
                end
                build(options)

                boxBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    optionHolder.Visible = opened
                end)

                place(holder, 22)

                local DropFunction = {}
                function DropFunction:Refresh(newList)
                    build(newList or {})
                end
                function DropFunction:Set(v)
                    boxText.Text = string.upper(tostring(v))
                    pcall(callback, v)
                end
                return DropFunction
            end

            -- ----------------------- LABEL (.text-uppercase) -----------------------
            function Elements:NewLabel(title)
                local lbl = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 14),
                    Font = FONT_BOLD,
                    Text = string.upper(tostring(title or "label")),
                    TextSize = 11,
                    TextColor3 = SOFT_COLOR,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 2,
                })
                place(lbl, 14)

                local labelFunctions = {}
                function labelFunctions:UpdateLabel(newText)
                    lbl.Text = string.upper(tostring(newText))
                end
                return labelFunctions
            end

            -- ----------------------------- BUTTON -----------------------------
            function Elements:NewButton(bname, tipINf, callback)
                callback = callback or function() end
                local btn = new("TextButton", {
                    BackgroundColor3 = P.Input,
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 26),
                    Font = FONT_BOLD,
                    Text = string.upper(tostring(bname or "button")),
                    TextSize = 10,
                    TextColor3 = P.Text,
                    ZIndex = 2,
                })
                Objects[btn] = "BackgroundColor3"
                corner(btn, 4)
                local bs = stroke(btn, P.Stroke)

                btn.MouseEnter:Connect(function()
                    bs.Color = P.Accent
                    bs.Transparency = 0.4
                end)
                btn.MouseLeave:Connect(function()
                    bs.Color = P.Stroke
                    bs.Transparency = 0
                end)
                btn.MouseButton1Click:Connect(function()
                    Utility:TweenObject(btn, {BackgroundColor3 = P.Panel}, 0.1)
                    task.delay(0.12, function()
                        Utility:TweenObject(btn, {BackgroundColor3 = P.Input}, 0.1)
                    end)
                    pcall(callback)
                end)

                place(btn, 26)

                local ButtonFunction = {}
                function ButtonFunction:UpdateButton(newTitle)
                    btn.Text = string.upper(tostring(newTitle))
                end
                return ButtonFunction
            end

            -- ---------------------------- TEXTBOX ----------------------------
            function Elements:NewTextBox(tname, tTip, callback)
                callback = callback or function() end
                local row = makeRow(22)
                makeLabel(row, tname or "textbox", 106)

                local box = makeBox(row, 98, 22)
                local tb = new("TextBox", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    Font = FONT,
                    Text = "",
                    PlaceholderText = "...",
                    PlaceholderColor3 = P.Muted,
                    TextSize = 11,
                    TextColor3 = SOFT_COLOR,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false,
                    ZIndex = 3,
                }, box)

                tb.FocusLost:Connect(function(enter)
                    if enter then pcall(callback, tb.Text) end
                end)

                place(row, 22)

                local TextboxFunction = {}
                function TextboxFunction:UpdateTextBox(newText)
                    tb.Text = tostring(newText)
                end
                return TextboxFunction
            end

            -- ---------------------------- KEYBIND ----------------------------
            function Elements:NewKeybind(keytext, keyinf, first, callback)
                callback = callback or function() end
                local row = makeRow(22)
                makeLabel(row, keytext or "keybind", 76)

                local box = makeBox(row, 68, 22)
                local keyLabel = new("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = FONT_BOLD,
                    Text = string.upper(tostring(first and first.Name or "none")),
                    TextSize = 10,
                    TextColor3 = P.Text,
                    ZIndex = 3,
                }, box)

                local btn = new("TextButton", {
                    BackgroundTransparency = 1,
                    Text = "",
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 4,
                }, box)

                local key = first
                local binding = false

                btn.MouseButton1Click:Connect(function()
                    binding = true
                    keyLabel.Text = "..."
                    keyLabel.TextColor3 = P.Accent
                end)

                input.InputBegan:Connect(function(i, gpe)
                    if binding then
                        if i.UserInputType == Enum.UserInputType.Keyboard then
                            key = i.KeyCode
                            keyLabel.Text = string.upper(key.Name)
                            keyLabel.TextColor3 = P.Text
                            binding = false
                        end
                    elseif not gpe and key and i.KeyCode == key then
                        pcall(callback, key)
                    end
                end)

                place(row, 22)

                local KeybindFunction = {}
                function KeybindFunction:UpdateKeybind(newKey)
                    key = newKey
                    keyLabel.Text = string.upper(tostring(newKey and newKey.Name or "none"))
                end
                return KeybindFunction
            end

            -- --------------------------- COLORPICKER ---------------------------
            function Elements:NewColorPicker(colText, colInf, defcolor, callback)
                callback = callback or function() end
                defcolor = defcolor or P.Accent

                local holder = new("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 2,
                })
                layout(holder, false, 8)

                local row = makeRow(22)
                row.LayoutOrder = 1
                row.Parent = holder
                makeLabel(row, colText or "color", 60)

                local swatch = makeBox(row, 52, 22)
                local preview = new("Frame", {
                    BackgroundColor3 = defcolor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, -8, 1, -8),
                    Position = UDim2.new(0, 4, 0, 4),
                    ZIndex = 3,
                }, swatch)
                corner(preview, 2)

                local openBtn = new("TextButton", {
                    BackgroundTransparency = 1,
                    Text = "",
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 4,
                }, swatch)

                local inners = new("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 2,
                    Visible = false,
                    ZIndex = 2,
                }, holder)
                layout(inners, false, 8)

                local r = math.floor(defcolor.R * 255)
                local g = math.floor(defcolor.G * 255)
                local b = math.floor(defcolor.B * 255)

                local function push()
                    local c = Color3.fromRGB(r, g, b)
                    preview.BackgroundColor3 = c
                    pcall(callback, c)
                end

                local rowR = buildSlider(inners, "r", 0, 255, r, false, function(v)
                    r = v
                    push()
                end)
                local rowG = buildSlider(inners, "g", 0, 255, g, false, function(v)
                    g = v
                    push()
                end)
                local rowB = buildSlider(inners, "b", 0, 255, b, false, function(v)
                    b = v
                    push()
                end)
                rowR.LayoutOrder, rowG.LayoutOrder, rowB.LayoutOrder = 1, 2, 3

                local opened = false
                openBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    inners.Visible = opened
                end)

                place(holder, 22)

                local ColorFunction = {}
                function ColorFunction:UpdateColorPicker(newText, newColor)
                    if newColor then
                        r = math.floor(newColor.R * 255)
                        g = math.floor(newColor.G * 255)
                        b = math.floor(newColor.B * 255)
                        preview.BackgroundColor3 = newColor
                    end
                end
                return ColorFunction
            end

            return Elements
        end

        return Sections
    end

    return Tabs
end

return Kavo
