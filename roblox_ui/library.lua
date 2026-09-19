-- Extended Kavo wrapper
-- Adds:
--   Library.CreateLib("name", "DarkTheme", "gif=url", "overlay=50%", "size=400x400")
--   Library.CreateLib("name", "DarkTheme", "png=url", "overlay=70%", "size=500x320")
--
-- The original Kavo library is loaded from its normal URL and wrapped.
-- PNG/JPG/Roblox image URLs can be used directly when Roblox accepts them.
-- For GIF URLs, Roblox GUI does not natively animate arbitrary remote GIF files;
-- this wrapper attempts a custom-asset fallback when the executor provides it.

local ORIGINAL_URL = "https://raw.githubusercontent.com/vimettvie/blub/main/roblox_ui/library.lua"

local function loadOriginal()
    local source = game:HttpGet(ORIGINAL_URL)
    source = source:gsub("0%.11 USDcy", "1,-cy")

    local compiler = loadstring or load
    local chunk, err = compiler(source)
    if not chunk then
        error("Extended Kavo: library compile failed: " .. tostring(err))
    end

    local ok, lib = pcall(chunk)
    if not ok then
        error("Extended Kavo: library runtime failed: " .. tostring(lib))
    end

    return lib
end

local Library = loadOriginal()
local OriginalCreateLib = Library.CreateLib

local function trim(s)
    return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function parseFlags(...)
    local flags = {
        imageType = nil,
        imageUrl = nil,
        overlay = 0.70,
        width = 525,
        height = 318
    }

    local args = {...}

    -- Also allow one combined flag string:
    -- "gif=url overlay=70% size=400x400"
    local expanded = {}
    for _, value in ipairs(args) do
        if type(value) == "string" then
            for token in value:gmatch("%S+") do
                table.insert(expanded, token)
            end
        end
    end

    for _, flag in ipairs(expanded) do
        local key, value = flag:match("^([%w_]+)%s*=%s*(.+)$")
        if not key then
            continue
        end

        key = key:lower()
        value = trim(value)

        if key == "png" or key == "image" or key == "jpg" then
            flags.imageType = "image"
            flags.imageUrl = value
        elseif key == "gif" then
            flags.imageType = "gif"
            flags.imageUrl = value
        elseif key == "overlay" then
            local pct = tonumber(value:match("([%d%.]+)%%?"))
            if pct then
                flags.overlay = math.clamp(pct / 100, 0, 1)
            end
        elseif key == "size" then
            local w, h = value:match("^(%d+)%s*[xX]%s*(%d+)$")
            if w and h then
                flags.width = tonumber(w)
                flags.height = tonumber(h)
            end
        end
    end

    return flags
end

local function findWindowGui(windowName)
    local core = game:GetService("CoreGui")

    for _, gui in ipairs(core:GetChildren()) do
        if gui:IsA("ScreenGui") then
            local title = gui:FindFirstChild("Main", true)
            if title and title:IsA("Frame") then
                local titleLabel = title:FindFirstChild("title", true)
                if titleLabel and titleLabel:IsA("TextLabel") and titleLabel.Text == windowName then
                    return gui, title
                end
            end
        end
    end

    return nil, nil
end

local function tryCustomAsset(url, windowName)
    if type(getcustomasset) ~= "function" and type(getsynasset) ~= "function" then
        return nil
    end

    if type(writefile) ~= "function" then
        return nil
    end

    local request = request or http_request or (syn and syn.request)
    if type(request) ~= "function" then
        return nil
    end

    local ext = url:lower():match("%.([%w]+)") or "png"
    if ext ~= "png" and ext ~= "jpg" and ext ~= "jpeg" and ext ~= "gif" then
        ext = "png"
    end

    local safeName = tostring(windowName):gsub("[^%w_%-]", "_")
    local path = "ExtendedKavo_" .. safeName .. "." .. ext

    local ok, response = pcall(function()
        return request({
            Url = url,
            Method = "GET"
        })
    end)

    if not ok or type(response) ~= "table" or not response.Body then
        return nil
    end

    pcall(function()
        writefile(path, response.Body)
    end)

    local getter = getcustomasset or getsynasset
    local assetOk, asset = pcall(function()
        return getter(path)
    end)

    if assetOk then
        return asset
    end

    return nil
end

local function applyBackground(main, windowName, flags)
    if not flags.imageUrl then
        return
    end

    local bg = Instance.new("ImageLabel")
    bg.Name = "ExtendedBackground"
    bg.Parent = main
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Position = UDim2.fromScale(0, 0)
    bg.Size = UDim2.fromScale(1, 1)
    bg.ZIndex = 0
    bg.ScaleType = Enum.ScaleType.Stretch
    bg.ImageTransparency = 1 - flags.overlay
    bg.Image = flags.imageUrl

    -- If Roblox rejects the remote URL, try the executor's custom-asset API.
    task.delay(0.15, function()
        if bg.Parent and (bg.IsLoaded == false or bg.Image == flags.imageUrl) then
            local asset = tryCustomAsset(flags.imageUrl, windowName)
            if asset and bg.Parent then
                bg.Image = asset
            end
        end
    end)

    -- Keep the UI above the background.
    for _, child in ipairs(main:GetChildren()) do
        if child ~= bg and child:IsA("GuiObject") then
            child.ZIndex = math.max(child.ZIndex, 2)
        end
    end
end

local function addResizeHandle(main, minW, minH)
    local handle = Instance.new("TextButton")
    handle.Name = "ExtendedResizeHandle"
    handle.Parent = main
    handle.AnchorPoint = Vector2.new(1, 1)
    handle.Position = UDim2.new(1, -4, 1, -4)
    handle.Size = UDim2.fromOffset(18, 18)
    handle.BackgroundTransparency = 1
    handle.Text = "◢"
    handle.TextSize = 14
    handle.TextColor3 = Color3.fromRGB(180, 180, 180)
    handle.AutoButtonColor = false
    handle.ZIndex = 100

    local uis = game:GetService("UserInputService")
    local dragging = false
    local startMouse
    local startSize

    handle.MouseButton1Down:Connect(function(input)
        dragging = true
        startMouse = input.Position
        startSize = main.AbsoluteSize
    end)

    uis.InputChanged:Connect(function(input)
        if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        local delta = input.Position - startMouse
        local newW = math.max(minW, startSize.X + delta.X)
        local newH = math.max(minH, startSize.Y + delta.Y)

        main.Size = UDim2.fromOffset(newW, newH)
        main:SetAttribute("SavedSize", main.Size)
    end)

    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Reposition the handle when the window changes size.
    main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if handle.Parent then
            handle.Position = UDim2.new(1, -4, 1, -4)
        end
    end)
end

function Library.CreateLib(kavName, themeList, ...)
    local flags = parseFlags(...)

    if flags.width and flags.height then
        -- The original library creates 525x318 internally.
        -- We resize after creation so all its existing controls remain intact.
    end

    local window = OriginalCreateLib(kavName, themeList)

    task.defer(function()
        local gui, main

        for _ = 1, 30 do
            gui, main = findWindowGui(kavName)
            if gui and main then
                break
            end
            task.wait()
        end

        if not main then
            warn("Extended Kavo: couldn't find created window '" .. tostring(kavName) .. "'")
            return
        end

        main.Size = UDim2.fromOffset(flags.width, flags.height)
        main:SetAttribute("SavedSize", main.Size)

        applyBackground(main, kavName, flags)

        addResizeHandle(main, 300, 200)
    end)

    return window
end

return Library
