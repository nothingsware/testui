local Fun = {}

local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new

-- Dragging Functionality
function Fun:DraggingEnabled(frame, parent)
    parent = parent or frame
    
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
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Create Main UI
function Fun.Create(title)
    local nightmarefun = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local mainCorner = Instance.new("UICorner")
    local tabContainer = Instance.new("Frame")
    local tabList = Instance.new("UIListLayout")
    local pageContainer = Instance.new("Frame")
    local pages = Instance.new("Folder")

    -- Main UI Setup
    nightmarefun.Name = "nightmarefun"
    nightmarefun.Parent = game.CoreGui
    nightmarefun.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    nightmarefun.ResetOnSpawn = false

    mainFrame.Name = "mainFrame"
    mainFrame.Parent = nightmarefun
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark gray
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200) -- Centered
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame

    -- Tab Container (Left Side)
    tabContainer.Name = "tabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Slightly lighter gray
    tabContainer.Size = UDim2.new(0, 120, 1, 0)
    tabContainer.ClipsDescendants = true

    tabList.Name = "tabList"
    tabList.Parent = tabContainer
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)

    -- Page Container (Right Side)
    pageContainer.Name = "pageContainer"
    pageContainer.Parent = mainFrame
    pageContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    pageContainer.Position = UDim2.new(0, 125, 0, 0)
    pageContainer.Size = UDim2.new(0, 375, 1, 0)

    pages.Name = "pages"
    pages.Parent = pageContainer

    -- Enable Dragging
    Fun:DraggingEnabled(mainFrame)

    -- Toggle UI Visibility with Alt Key
    input.InputBegan:Connect(function(current)
        if current.KeyCode == Enum.KeyCode.LeftAlt then
            nightmarefun.Enabled = not nightmarefun.Enabled
        end
    end)

    -- Tab Handling
    local tabHandling = {}

    function tabHandling:Tab(tabText, iconId)
        tabText = tabText or "Tab"
        iconId = iconId or "rbxassetid://3926305904" -- Default icon (gear)

        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "tabButton"
        tabButton.Parent = tabContainer
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.Size = UDim2.new(1, -10, 0, 35)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = ""
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false

        -- Icon
        local icon = Instance.new("ImageLabel")
        icon.Name = "icon"
        icon.Parent = tabButton
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0.1, 0, 0.2, 0)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Image = iconId
        icon.ImageColor3 = Color3.fromRGB(200, 200, 200)

        -- Tab Text
        local tabTextLabel = Instance.new("TextLabel")
        tabTextLabel.Name = "tabTextLabel"
        tabTextLabel.Parent = tabButton
        tabTextLabel.BackgroundTransparency = 1
        tabTextLabel.Position = UDim2.new(0.4, 0, 0.2, 0)
        tabTextLabel.Size = UDim2.new(0.6, 0, 0.6, 0)
        tabTextLabel.Font = Enum.Font.Gotham
        tabTextLabel.Text = tabText
        tabTextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabTextLabel.TextSize = 14
        tabTextLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- Hover Effect
        tabButton.MouseEnter:Connect(function()
            tween:Create(tabButton, tweeninfo(0.2), {
                BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            tween:Create(icon, tweeninfo(0.2), {
                ImageColor3 = Color3.fromRGB(122, 92, 255) -- Purple accent
            }):Play()
        end)

        tabButton.MouseLeave:Connect(function()
            tween:Create(tabButton, tweeninfo(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
            tween:Create(icon, tweeninfo(0.2), {
                ImageColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end)

        -- Page Frame
        local pageFrame = Instance.new("ScrollingFrame")
        pageFrame.Name = "pageFrame"
        pageFrame.Parent = pages
        pageFrame.BackgroundTransparency = 1
        pageFrame.Size = UDim2.new(1, 0, 1, 0)
        pageFrame.ScrollBarThickness = 6
        pageFrame.ScrollBarImageColor3 = Color3.fromRGB(122, 92, 255) -- Purple accent
        pageFrame.Visible = false

        -- Section Layout
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.Parent = pageFrame
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Padding = UDim.new(0, 10)

        -- Update Page Size
        local function UpdateSize()
            local contentSize = sectionLayout.AbsoluteContentSize
            tween:Create(pageFrame, tweeninfo(0.2), {
                CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
            }):Play()
        end
        UpdateSize()
        pageFrame.ChildAdded:Connect(UpdateSize)
        pageFrame.ChildRemoved:Connect(UpdateSize)

        -- Tab Click Event
        tabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(pages:GetChildren()) do
                v.Visible = false
            end
            pageFrame.Visible = true
        end)

        -- Section Handling
        local sectionHandling = {}

        function sectionHandling:Section(sectionName)
            sectionName = sectionName or "Section"

            -- Section Frame
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = pageFrame
            sectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sectionFrame.Size = UDim2.new(1, -20, 0, 40)
            sectionFrame.Position = UDim2.new(0, 10, 0, 0)

            -- Section Title
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "sectionTitle"
            sectionTitle.Parent = sectionFrame
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Position = UDim2.new(0, 10, 0, 5)
            sectionTitle.Size = UDim2.new(1, -20, 0, 20)
            sectionTitle.Font = Enum.Font.Gotham
            sectionTitle.Text = sectionName
            sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionTitle.TextSize = 14
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            -- Item Handling
            local itemHandling = {}

            function itemHandling:Button(btnText, callback)
                btnText = btnText or "Button"
                callback = callback or function() end

                local button = Instance.new("TextButton")
                button.Name = "button"
                button.Parent = sectionFrame
                button.BackgroundColor3 = Color3.fromRGB(122, 92, 255) -- Purple accent
                button.Size = UDim2.new(1, -20, 0, 30)
                button.Position = UDim2.new(0, 10, 0, 40)
                button.Font = Enum.Font.Gotham
                button.Text = btnText
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.AutoButtonColor = false

                -- Hover Effect
                button.MouseEnter:Connect(function()
                    tween:Create(button, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(140, 110, 255)
                    }):Play()
                end)

                button.MouseLeave:Connect(function()
                    tween:Create(button, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(122, 92, 255)
                    }):Play()
                end)

                -- Click Event
                button.MouseButton1Click:Connect(function()
                    callback()
                end)
            end

            function itemHandling:Toggle(togText, callback)
                togText = togText or "Toggle"
                callback = callback or function() end

                local toggle = Instance.new("TextButton")
                toggle.Name = "toggle"
                toggle.Parent = sectionFrame
                toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                toggle.Size = UDim2.new(1, -20, 0, 30)
                toggle.Position = UDim2.new(0, 10, 0, 40)
                toggle.Font = Enum.Font.Gotham
                toggle.Text = togText
                toggle.TextColor3 = Color3.fromRGB(200, 200, 200)
                toggle.TextSize = 14
                toggle.AutoButtonColor = false

                local toggleState = false

                -- Hover Effect
                toggle.MouseEnter:Connect(function()
                    tween:Create(toggle, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    }):Play()
                end)

                toggle.MouseLeave:Connect(function()
                    tween:Create(toggle, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    }):Play()
                end)

                -- Click Event
                toggle.MouseButton1Click:Connect(function()
                    toggleState = not toggleState
                    callback(toggleState)
                    if toggleState then
                        tween:Create(toggle, tweeninfo(0.2), {
                            BackgroundColor3 = Color3.fromRGB(122, 92, 255)
                        }):Play()
                    else
                        tween:Create(toggle, tweeninfo(0.2), {
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        }):Play()
                    end
                end)
            end

            function itemHandling:Slider(sliderText, minValue, maxValue, callback)
                sliderText = sliderText or "Slider"
                minValue = minValue or 0
                maxValue = maxValue or 100
                callback = callback or function() end

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "sliderFrame"
                sliderFrame.Parent = sectionFrame
                sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                sliderFrame.Size = UDim2.new(1, -20, 0, 30)
                sliderFrame.Position = UDim2.new(0, 10, 0, 40)

                local sliderBar = Instance.new("Frame")
                sliderBar.Name = "sliderBar"
                sliderBar.Parent = sliderFrame
                sliderBar.BackgroundColor3 = Color3.fromRGB(122, 92, 255)
                sliderBar.Size = UDim2.new(0, 0, 1, 0)

                local sliderTextLabel = Instance.new("TextLabel")
                sliderTextLabel.Name = "sliderTextLabel"
                sliderTextLabel.Parent = sliderFrame
                sliderTextLabel.BackgroundTransparency = 1
                sliderTextLabel.Position = UDim2.new(0, 10, 0, 5)
                sliderTextLabel.Size = UDim2.new(1, -20, 0, 20)
                sliderTextLabel.Font = Enum.Font.Gotham
                sliderTextLabel.Text = sliderText
                sliderTextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                sliderTextLabel.TextSize = 14
                sliderTextLabel.TextXAlignment = Enum.TextXAlignment.Left

                local mouse = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")

                sliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local value = math.clamp((mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                        sliderBar.Size = UDim2.new(value, 0, 1, 0)
                        callback(math.floor(minValue + (maxValue - minValue) * value))
                    end
                end)
            end

            function itemHandling:Label(labelText)
                labelText = labelText or "Label"

                local label = Instance.new("TextLabel")
                label.Name = "label"
                label.Parent = sectionFrame
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0, 10, 0, 5)
                label.Size = UDim2.new(1, -20, 0, 20)
                label.Font = Enum.Font.Gotham
                label.Text = labelText
                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
            end

            function itemHandling:KeyBind(keyText, defaultKey, callback)
                keyText = keyText or "KeyBind"
                defaultKey = defaultKey or Enum.KeyCode.E
                callback = callback or function() end

                local keyBind = Instance.new("TextButton")
                keyBind.Name = "keyBind"
                keyBind.Parent = sectionFrame
                keyBind.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                keyBind.Size = UDim2.new(1, -20, 0, 30)
                keyBind.Position = UDim2.new(0, 10, 0, 40)
                keyBind.Font = Enum.Font.Gotham
                keyBind.Text = keyText .. ": " .. defaultKey.Name
                keyBind.TextColor3 = Color3.fromRGB(200, 200, 200)
                keyBind.TextSize = 14
                keyBind.AutoButtonColor = false

                local key = defaultKey

                -- Hover Effect
                keyBind.MouseEnter:Connect(function()
                    tween:Create(keyBind, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    }):Play()
                end)

                keyBind.MouseLeave:Connect(function()
                    tween:Create(keyBind, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    }):Play()
                end)

                -- Key Bind Event
                keyBind.MouseButton1Click:Connect(function()
                    keyBind.Text = keyText .. ": ..."
                    local input = input.InputBegan:Wait()
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        keyBind.Text = keyText .. ": " .. key.Name
                    end
                end)

                input.InputBegan:Connect(function(input)
                    if input.KeyCode == key then
                        callback()
                    end
                end)
            end

            function itemHandling:Dropdown(dropText, options, callback)
                dropText = dropText or "Dropdown"
                options = options or {"Option 1", "Option 2", "Option 3"}
                callback = callback or function() end

                local dropdown = Instance.new("TextButton")
                dropdown.Name = "dropdown"
                dropdown.Parent = sectionFrame
                dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                dropdown.Size = UDim2.new(1, -20, 0, 30)
                dropdown.Position = UDim2.new(0, 10, 0, 40)
                dropdown.Font = Enum.Font.Gotham
                dropdown.Text = dropText
                dropdown.TextColor3 = Color3.fromRGB(200, 200, 200)
                dropdown.TextSize = 14
                dropdown.AutoButtonColor = false

                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = "dropdownFrame"
                dropdownFrame.Parent = sectionFrame
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
                dropdownFrame.Position = UDim2.new(0, 10, 0, 70)
                dropdownFrame.ClipsDescendants = true

                local dropdownList = Instance.new("UIListLayout")
                dropdownList.Parent = dropdownFrame
                dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
                dropdownList.Padding = UDim.new(0, 5)

                local dropdownOpen = false

                -- Hover Effect
                dropdown.MouseEnter:Connect(function()
                    tween:Create(dropdown, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    }):Play()
                end)

                dropdown.MouseLeave:Connect(function()
                    tween:Create(dropdown, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    }):Play()
                end)

                -- Dropdown Click Event
                dropdown.MouseButton1Click:Connect(function()
                    dropdownOpen = not dropdownOpen
                    if dropdownOpen then
                        dropdownFrame.Size = UDim2.new(1, -20, 0, #options * 30)
                        for i, option in pairs(options) do
                            local optionButton = Instance.new("TextButton")
                            optionButton.Name = "optionButton"
                            optionButton.Parent = dropdownFrame
                            optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                            optionButton.Size = UDim2.new(1, 0, 0, 30)
                            optionButton.Font = Enum.Font.Gotham
                            optionButton.Text = option
                            optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                            optionButton.TextSize = 14
                            optionButton.AutoButtonColor = false

                            -- Hover Effect
                            optionButton.MouseEnter:Connect(function()
                                tween:Create(optionButton, tweeninfo(0.2), {
                                    BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                                }):Play()
                            end)

                            optionButton.MouseLeave:Connect(function()
                                tween:Create(optionButton, tweeninfo(0.2), {
                                    BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                                }):Play()
                            end)

                            -- Option Click Event
                            optionButton.MouseButton1Click:Connect(function()
                                dropdown.Text = dropText .. ": " .. option
                                callback(option)
                                dropdownOpen = false
                                dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
                            end)
                        end
                    else
                        dropdownFrame.Size = UDim2.new(1, -20, 0, 0)
                    end
                end)
            end

            function itemHandling:TextBox(textBoxText, callback)
                textBoxText = textBoxText or "Textbox"
                callback = callback or function() end

                local textBox = Instance.new("TextBox")
                textBox.Name = "textBox"
                textBox.Parent = sectionFrame
                textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                textBox.Size = UDim2.new(1, -20, 0, 30)
                textBox.Position = UDim2.new(0, 10, 0, 40)
                textBox.Font = Enum.Font.Gotham
                textBox.Text = textBoxText
                textBox.TextColor3 = Color3.fromRGB(200, 200, 200)
                textBox.TextSize = 14
                textBox.ClearTextOnFocus = false

                -- Hover Effect
                textBox.Focused:Connect(function()
                    tween:Create(textBox, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    }):Play()
                end)

                textBox.FocusLost:Connect(function()
                    tween:Create(textBox, tweeninfo(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    }):Play()
                    callback(textBox.Text)
                end)
            end

            return itemHandling
        end

        return sectionHandling
    end

    return tabHandling
end

return Fun
