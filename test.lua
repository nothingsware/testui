local Fun = {}

local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local tween = game:GetService("TweenService")
local ts = game:GetService("TweenService")

-- Utility function for gradients
local function createGradient(parent, colorSeq, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSeq
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

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

function Fun.Create(title)
    local nightmarefun = Instance.new("ScreenGui")
    local mainContainer = Instance.new("Frame")
    local tabContainer = Instance.new("Frame")
    local titleContainer = Instance.new("Frame")
    local tabListLayout = Instance.new("UIListLayout")
    local pageContainer = Instance.new("Frame")
    local tabUnderline = Instance.new("Frame")

    -- Main Container Setup
    nightmarefun.Name = "nightmarefun"
    nightmarefun.Parent = game.CoreGui
    nightmarefun.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    mainContainer.Name = "mainContainer"
    mainContainer.Parent = nightmarefun
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainContainer.Size = UDim2.new(0, 500, 0, 400)
    mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    mainContainer.ClipsDescendants = true
    
    createGradient(mainContainer, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    }))

    -- Tab Container Setup
    tabContainer.Name = "tabContainer"
    tabContainer.Parent = mainContainer
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(0, 150, 1, 0)
    
    createGradient(tabContainer, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 53, 93)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(127, 97, 145))
    }))

    -- Title Container
    titleContainer.Name = "titleContainer"
    titleContainer.Parent = tabContainer
    titleContainer.BackgroundTransparency = 1
    titleContainer.Size = UDim2.new(1, 0, 0, 50)

    local titleText = Instance.new("TextLabel")
    titleText.Name = "titleText"
    titleText.Parent = titleContainer
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -10, 1, 0)
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = title
    titleText.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleText.TextSize = 20
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Position = UDim2.new(0, 10, 0, 0)

    -- Tab List
    tabListLayout.Name = "tabListLayout"
    tabListLayout.Parent = tabContainer
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)

    -- Page Container
    pageContainer.Name = "pageContainer"
    pageContainer.Parent = mainContainer
    pageContainer.BackgroundTransparency = 1
    pageContainer.Position = UDim2.new(0, 160, 0, 10)
    pageContainer.Size = UDim2.new(1, -170, 1, -20)

    -- Tab Underline
    tabUnderline.Name = "tabUnderline"
    tabUnderline.Parent = tabContainer
    tabUnderline.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    tabUnderline.Size = UDim2.new(0.8, 0, 0, 2)
    tabUnderline.AnchorPoint = Vector2.new(0.5, 1)
    tabUnderline.Position = UDim2.new(0.5, 0, 0, 48)
    createGradient(tabUnderline, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 140, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 110, 170))
    }))

    Fun:DraggingEnabled(titleContainer, mainContainer)

    -- Toggle Visibility
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightAlt then
            nightmarefun.Enabled = not nightmarefun.Enabled
        end
    end)

    local tabHandling = {}
    local currentTab = nil

    function tabHandling:Tab(tabName)
        local tabButton = Instance.new("TextButton")
        local pageFrame = Instance.new("ScrollingFrame")
        local pageListLayout = Instance.new("UIListLayout")

        -- Tab Button
        tabButton.Name = "tabButton"
        tabButton.Parent = tabContainer
        tabButton.BackgroundTransparency = 1
        tabButton.Size = UDim2.new(1, -10, 0, 30)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabButton.TextSize = 16
        tabButton.AutoButtonColor = false

        -- Page Frame
        pageFrame.Name = "pageFrame"
        pageFrame.Parent = pageContainer
        pageFrame.BackgroundTransparency = 1
        pageFrame.Size = UDim2.new(1, 0, 1, 0)
        pageFrame.Visible = false
        pageFrame.ScrollBarThickness = 6
        pageFrame.ScrollBarImageColor3 = Color3.fromRGB(127, 97, 145)

        pageListLayout.Name = "pageListLayout"
        pageListLayout.Parent = pageFrame
        pageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageListLayout.Padding = UDim.new(0, 10)

        local function updateSize()
            pageFrame.CanvasSize = UDim2.new(0, 0, 0, pageListLayout.AbsoluteContentSize.Y + 20)
        end
        pageListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

        -- Tab Interactions
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabButton then
                ts:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabButton then
                ts:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
        end)

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                ts:Create(currentTab, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                currentTab.Parent.pageFrame.Visible = false
            end
            
            currentTab = tabButton
            pageFrame.Visible = true
            ts:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(240, 240, 240)}):Play()
            
            -- Animate underline
            ts:Create(tabUnderline, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Position = UDim2.new(0.5, 0, 0, tabButton.AbsolutePosition.Y - tabContainer.AbsolutePosition.Y + 30)
            }):Play()
        end)

        local sectionHandling = {}

        function sectionHandling:Section(sectionName)
            local sectionFrame = Instance.new("Frame")
            local sectionHeader = Instance.new("Frame")
            local sectionTitle = Instance.new("TextLabel")
            local sectionContent = Instance.new("Frame")
            local sectionListLayout = Instance.new("UIListLayout")
            local expandButton = Instance.new("ImageButton")

            -- Section Frame
            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = pageFrame
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Size = UDim2.new(1, 0, 0, 40)

            -- Section Header
            sectionHeader.Name = "sectionHeader"
            sectionHeader.Parent = sectionFrame
            sectionHeader.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
            sectionHeader.Size = UDim2.new(1, 0, 0, 32)
            createGradient(sectionHeader, ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 48))
            }))

            -- Section Title
            sectionTitle.Name = "sectionTitle"
            sectionTitle.Parent = sectionHeader
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Position = UDim2.new(0, 10, 0, 0)
            sectionTitle.Size = UDim2.new(1, -40, 1, 0)
            sectionTitle.Font = Enum.Font.GothamMedium
            sectionTitle.Text = sectionName
            sectionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
            sectionTitle.TextSize = 14
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            -- Expand Button
            expandButton.Name = "expandButton"
            expandButton.Parent = sectionHeader
            expandButton.AnchorPoint = Vector2.new(0.5, 0.5)
            expandButton.Position = UDim2.new(1, -20, 0.5, 0)
            expandButton.Size = UDim2.new(0, 20, 0, 20)
            expandButton.Image = "rbxassetid://3926305904"
            expandButton.ImageRectOffset = Vector2.new(884, 284)
            expandButton.ImageRectSize = Vector2.new(36, 36)
            expandButton.ImageColor3 = Color3.fromRGB(150, 150, 150)

            -- Section Content
            sectionContent.Name = "sectionContent"
            sectionContent.Parent = sectionFrame
            sectionContent.BackgroundTransparency = 1
            sectionContent.Position = UDim2.new(0, 0, 0, 35)
            sectionContent.Size = UDim2.new(1, 0, 0, 0)
            sectionContent.ClipsDescendants = true

            sectionListLayout.Name = "sectionListLayout"
            sectionListLayout.Parent = sectionContent
            sectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionListLayout.Padding = UDim.new(0, 5)

            local isExpanded = false
            local originalSize = 0

            expandButton.MouseButton1Click:Connect(function()
                isExpanded = not isExpanded
                if isExpanded then
                    originalSize = sectionListLayout.AbsoluteContentSize.Y + 10
                    ts:Create(sectionContent, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, originalSize)}):Play()
                    ts:Create(expandButton, TweenInfo.new(0.3), {Rotation = 180}):Play()
                else
                    ts:Create(sectionContent, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    ts:Create(expandButton, TweenInfo.new(0.3), {Rotation = 0}):Play()
                end
                updateSize()
            end)

            local elementHandling = {}

            -- Button Element
            function elementHandling:Button(btnText, callback)
                local buttonFrame = Instance.new("Frame")
                local buttonText = Instance.new("TextLabel")

                buttonFrame.Name = "buttonFrame"
                buttonFrame.Parent = sectionContent
                buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                buttonFrame.Size = UDim2.new(1, -10, 0, 30)
                buttonFrame.Position = UDim2.new(0, 5, 0, 0)
                
                createGradient(buttonFrame, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 120)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 100, 150))
                }), -90)

                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = Color3.fromRGB(60, 60, 70)
                buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                buttonStroke.Parent = buttonFrame

                buttonText.Name = "buttonText"
                buttonText.Parent = buttonFrame
                buttonText.AnchorPoint = Vector2.new(0.5, 0.5)
                buttonText.Position = UDim2.new(0.5, 0, 0.5, 0)
                buttonText.Size = UDim2.new(1, -10, 1, 0)
                buttonText.Font = Enum.Font.Gotham
                buttonText.Text = btnText
                buttonText.TextColor3 = Color3.fromRGB(240, 240, 240)
                buttonText.TextSize = 14
                buttonText.TextXAlignment = Enum.TextXAlignment.Center

                local hoverAnim = ts:Create(buttonFrame.UIGradient, TweenInfo.new(0.2), {Rotation = 90})
                local clickAnim = ts:Create(buttonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -15, 0, 25)})

                buttonFrame.MouseEnter:Connect(function()
                    hoverAnim:Play()
                    ts:Create(buttonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(90, 90, 100)}):Play()
                end)

                buttonFrame.MouseLeave:Connect(function()
                    hoverAnim:PlayBackward()
                    ts:Create(buttonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 70)}):Play()
                end)

                buttonFrame.MouseButton1Down:Connect(function()
                    clickAnim:Play()
                end)

                buttonFrame.MouseButton1Up:Connect(function()
                    clickAnim:PlayBackward()
                end)

                buttonFrame.MouseButton1Click:Connect(callback)
            end

            -- Toggle Element
            function elementHandling:Toggle(togText, default, callback)
                local toggleFrame = Instance.new("Frame")
                local toggleButton = Instance.new("Frame")
                local toggleText = Instance.new("TextLabel")

                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = sectionContent
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Size = UDim2.new(1, -10, 0, 25)
                toggleFrame.Position = UDim2.new(0, 5, 0, 0)

                toggleButton.Name = "toggleButton"
                toggleButton.Parent = toggleFrame
                toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                toggleButton.Size = UDim2.new(0, 45, 0, 25)
                toggleButton.Position = UDim2.new(1, -50, 0, 0)
                createGradient(toggleButton, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 90)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 70))
                }))

                local toggleKnob = Instance.new("Frame")
                toggleKnob.Name = "toggleKnob"
                toggleKnob.Parent = toggleButton
                toggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                toggleKnob.Size = UDim2.new(0, 15, 0, 15)
                toggleKnob.Position = UDim2.new(0, 5, 0.2, 0)
                createGradient(toggleKnob, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 240, 240)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
                }))

                toggleText.Name = "toggleText"
                toggleText.Parent = toggleFrame
                toggleText.BackgroundTransparency = 1
                toggleText.Size = UDim2.new(1, -50, 1, 0)
                toggleText.Font = Enum.Font.Gotham
                toggleText.Text = togText
                toggleText.TextColor3 = Color3.fromRGB(200, 200, 200)
                toggleText.TextSize = 14
                toggleText.TextXAlignment = Enum.TextXAlignment.Left

                local isToggled = default or false
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)

                local function updateToggle()
                    if isToggled then
                        ts:Create(toggleKnob, tweenInfo, {Position = UDim2.new(1, -20, 0.2, 0)}):Play()
                        ts:Create(toggleButton.UIGradient, tweenInfo, {
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 100, 150)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 70, 120))
                            })
                        }):Play()
                    else
                        ts:Create(toggleKnob, tweenInfo, {Position = UDim2.new(0, 5, 0.2, 0)}):Play()
                        ts:Create(toggleButton.UIGradient, tweenInfo, {
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 90)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 70))
                            })
                        }):Play()
                    end
                end

                toggleButton.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    updateToggle()
                    if callback then callback(isToggled) end
                end)

                updateToggle()
            end

            -- Slider Element
            function elementHandling:Slider(sliderText, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                local sliderBar = Instance.new("Frame")
                local sliderValue = Instance.new("TextLabel")
                local sliderFill = Instance.new("Frame")
                local sliderKnob = Instance.new("Frame")

                sliderFrame.Name = "sliderFrame"
                sliderFrame.Parent = sectionContent
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Size = UDim2.new(1, -10, 0, 40)
                sliderFrame.Position = UDim2.new(0, 5, 0, 0)

                sliderValue.Name = "sliderValue"
                sliderValue.Parent = sliderFrame
                sliderValue.BackgroundTransparency = 1
                sliderValue.Size = UDim2.new(0, 60, 0, 20)
                sliderValue.Position = UDim2.new(1, -65, 0, 0)
                sliderValue.Font = Enum.Font.GothamBold
                sliderValue.Text = tostring(default or min)
                sliderValue.TextColor3 = Color3.fromRGB(200, 200, 200)
                sliderValue.TextSize = 14
                sliderValue.TextXAlignment = Enum.TextXAlignment.Right

                local sliderTextLabel = Instance.new("TextLabel")
                sliderTextLabel.Name = "sliderText"
                sliderTextLabel.Parent = sliderFrame
                sliderTextLabel.BackgroundTransparency = 1
                sliderTextLabel.Size = UDim2.new(1, -70, 0, 20)
                sliderTextLabel.Font = Enum.Font.Gotham
                sliderTextLabel.Text = sliderText
                sliderTextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                sliderTextLabel.TextSize = 14
                sliderTextLabel.TextXAlignment = Enum.TextXAlignment.Left

                sliderBar.Name = "sliderBar"
                sliderBar.Parent = sliderFrame
                sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                sliderBar.Position = UDim2.new(0, 0, 0, 25)
                sliderBar.Size = UDim2.new(1, 0, 0, 6)
                createGradient(sliderBar, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 90)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 70))
                }))

                sliderFill.Name = "sliderFill"
                sliderFill.Parent = sliderBar
                sliderFill.BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                sliderFill.Size = UDim2.new((default or min) / max, 0, 1, 0)
                createGradient(sliderFill, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 120, 170)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 100, 150))
                }))

                sliderKnob.Name = "sliderKnob"
                sliderKnob.Parent = sliderFill
                sliderKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
                sliderKnob.Size = UDim2.new(0, 12, 0, 12)
                sliderKnob.Position = UDim2.new(1, -6, 0.5, -6)
                createGradient(sliderKnob, ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 250, 250)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230))
                }))

                local isDragging = false
                local function updateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1),
                        0,
                        0.5,
                        -6
                    )
                    local value = math.floor(min + ((max - min) * pos.X.Scale))
                    
                    ts:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos.X.Scale, 0, 1, 0)}):Play()
                    ts:Create(sliderKnob, TweenInfo.new(0.1), {Position = pos}):Play()
                    sliderValue.Text = tostring(value)
                    if callback then callback(value) end
                end

                sliderKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                    end
                end)

                sliderKnob.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
                end)

                input.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
                        updateSlider(input)
                    end
                end)
            end

            return elementHandling
        end

        return sectionHandling
    end

    return tabHandling
end

return Fun
