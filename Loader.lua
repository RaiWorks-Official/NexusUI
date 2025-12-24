local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local OFFICIAL_VERSION = "V1.5"

local Themes = {
	Dark = {
		Background = Color3.fromRGB(17, 17, 17),
		Secondary = Color3.fromRGB(15, 15, 15),
		Tertiary = Color3.fromRGB(35, 35, 35),
		Accent = Color3.fromRGB(255, 255, 255),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(180, 180, 180)
	},
	Gray = {
		Background = Color3.fromRGB(40, 40, 40),
		Secondary = Color3.fromRGB(55, 55, 55),
		Tertiary = Color3.fromRGB(70, 70, 70),
		Accent = Color3.fromRGB(200, 200, 200),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(200, 200, 200)
	},
	Blue = {
		Background = Color3.fromRGB(20, 25, 35),
		Secondary = Color3.fromRGB(30, 40, 55),
		Tertiary = Color3.fromRGB(40, 50, 70),
		Accent = Color3.fromRGB(70, 130, 255),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(150, 180, 220)
	}
}

local function Tween(obj, props, dur, style, dir)
	TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(frame, dragFrame)
	local dragging, dragInput, dragStart, startPos
	dragFrame = dragFrame or frame
	
	dragFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	
	dragFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.15, Enum.EasingStyle.Linear)
		end
	end)
end

local function CreateLoader(config)
	local title = config.title or "Loading"
	local description = config.description or "Please wait..."
	local time = config.time or 3
	local icon = config.icon or "⏳"
	local isError = config.isError or false
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "NexusLoader"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("CoreGui")
	
	local LoaderFrame = Instance.new("Frame")
	LoaderFrame.Size = UDim2.new(0, 0, 0, 0)
	LoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LoaderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	LoaderFrame.BorderSizePixel = 0
	LoaderFrame.Parent = ScreenGui
	
	Instance.new("UICorner", LoaderFrame).CornerRadius = UDim.new(0, 8)
	
	local IconLabel = Instance.new("TextLabel")
	IconLabel.Size = UDim2.new(0, 60, 0, 60)
	IconLabel.Position = UDim2.new(0.5, 0, 0, 30)
	IconLabel.AnchorPoint = Vector2.new(0.5, 0)
	IconLabel.BackgroundTransparency = 1
	IconLabel.Text = icon
	IconLabel.TextColor3 = isError and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 255, 255)
	IconLabel.Font = Enum.Font.GothamBold
	IconLabel.TextSize = 48
	IconLabel.Parent = LoaderFrame
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -40, 0, 30)
	TitleLabel.Position = UDim2.new(0, 20, 0, 100)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 20
	TitleLabel.Parent = LoaderFrame
	
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Size = UDim2.new(1, -40, 0, 60)
	DescLabel.Position = UDim2.new(0, 20, 0, 135)
	DescLabel.BackgroundTransparency = 1
	DescLabel.Text = description
	DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextSize = 14
	DescLabel.TextWrapped = true
	DescLabel.TextYAlignment = Enum.TextYAlignment.Top
	DescLabel.Parent = LoaderFrame
	
	local BarBackground = Instance.new("Frame")
	BarBackground.Size = UDim2.new(1, -40, 0, 4)
	BarBackground.Position = UDim2.new(0, 20, 1, -20)
	BarBackground.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	BarBackground.BorderSizePixel = 0
	BarBackground.Parent = LoaderFrame
	Instance.new("UICorner", BarBackground).CornerRadius = UDim.new(1, 0)
	
	local BarFill = Instance.new("Frame")
	BarFill.Size = UDim2.new(0, 0, 1, 0)
	BarFill.BackgroundColor3 = isError and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 255, 255)
	BarFill.BorderSizePixel = 0
	BarFill.Parent = BarBackground
	Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)
	
	Tween(LoaderFrame, {Size = UDim2.new(0, 400, 0, 220)}, 0.5, Enum.EasingStyle.Back)
	
	if not isError then
		task.wait(0.5)
		Tween(BarFill, {Size = UDim2.new(1, 0, 1, 0)}, time, Enum.EasingStyle.Linear)
		task.wait(time)
	end
	
	return ScreenGui
end

function Library:CreateWindow(config)
	local name = config.name or config[1] or "UI Library"
	local subtext = config.subtext or config[2] or ""
	local theme = config.theme or config[4] or "Dark"
	local ver = config.ver or config[6] or OFFICIAL_VERSION
	local misc = config.Misc ~= nil and config.Misc or false
	local loader = config.Loader or false
	local loaderTime = config.Time or 3
	local currentTheme = Themes[theme] or Themes.Dark
	
	-- Version Check
	if ver > OFFICIAL_VERSION then
		local errorLoader = CreateLoader({
			title = "Invalid Version",
			description = "The version you're using is not supported.\nPlease use the official version that has been released.",
			icon = "⚠️",
			isError = true
		})
		return
	end
	
	-- Show Loader
	if loader then
		local loaderGui = CreateLoader({
			title = "Loading Nexus UI",
			description = "Please wait while we initialize...",
			time = loaderTime,
			icon = "⏳"
		})
		loaderGui:Destroy()
	end
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Nexus"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("CoreGui")
	
	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = currentTheme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 6)
	MainCorner.Parent = MainFrame
	
	Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 450)}, 0.5, Enum.EasingStyle.Back)
	
	local Header = Instance.new("Frame")
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.BackgroundColor3 = currentTheme.Secondary
	Header.BorderSizePixel = 0
	Header.Parent = MainFrame
	
	local HeaderCorner = Instance.new("UICorner")
	HeaderCorner.CornerRadius = UDim.new(0, 6)
	HeaderCorner.Parent = Header
	
	local HeaderCover = Instance.new("Frame")
	HeaderCover.Size = UDim2.new(1, 0, 0, 10)
	HeaderCover.Position = UDim2.new(0, 0, 1, -10)
	HeaderCover.BackgroundColor3 = currentTheme.Secondary
	HeaderCover.BorderSizePixel = 0
	HeaderCover.Parent = Header
	
	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(0, 300, 1, 0)
	Title.Position = UDim2.new(0, 20, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = name
	Title.TextColor3 = currentTheme.Text
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Header
	
	task.wait()
	
	if subtext ~= "" then
		local textWidth = Title.TextBounds.X
		local SubText = Instance.new("TextLabel")
		SubText.Size = UDim2.new(0, 200, 1, 0)
		SubText.Position = UDim2.new(0, 20 + textWidth + 8, 0, 0)
		SubText.BackgroundTransparency = 1
		SubText.Text = "• " .. subtext
		SubText.TextColor3 = currentTheme.SubText
		SubText.Font = Enum.Font.Gotham
		SubText.TextSize = 14
		SubText.TextXAlignment = Enum.TextXAlignment.Left
		SubText.Parent = Header
	end
	
	MakeDraggable(MainFrame, Header)
	
	-- Close Button
	local CloseButton = Instance.new("TextButton")
	CloseButton.Size = UDim2.new(0, 28, 0, 28)
	CloseButton.Position = UDim2.new(1, -36, 0, 8)
	CloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	CloseButton.BackgroundTransparency = 1
	CloseButton.Text = "✕"
	CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.TextSize = 16
	CloseButton.Parent = Header
	Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 4)
	
	CloseButton.MouseEnter:Connect(function()
		Tween(CloseButton, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(255, 70, 70)}, 0.2)
	end)
	CloseButton.MouseLeave:Connect(function()
		Tween(CloseButton, {BackgroundTransparency = 1}, 0.2)
	end)
	CloseButton.MouseButton1Click:Connect(function()
		Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.wait(0.3)
		ScreenGui:Destroy()
	end)
	
	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(0, 160, 1, -45)
	TabContainer.Position = UDim2.new(0, 0, 0, 45)
	TabContainer.BackgroundColor3 = currentTheme.Secondary
	TabContainer.BorderSizePixel = 0
	TabContainer.Parent = MainFrame
	
	local TabList = Instance.new("UIListLayout")
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	TabList.Padding = UDim.new(0, 6)
	TabList.Parent = TabContainer
	
	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingTop = UDim.new(0, 12)
	TabPadding.PaddingLeft = UDim.new(0, 12)
	TabPadding.PaddingRight = UDim.new(0, 12)
	TabPadding.Parent = TabContainer
	
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Size = UDim2.new(1, -160, 1, -45)
	ContentContainer.Position = UDim2.new(0, 160, 0, 45)
	ContentContainer.BackgroundColor3 = currentTheme.Background
	ContentContainer.BorderSizePixel = 0
	ContentContainer.Parent = MainFrame
	
	-- Minimize Button
	local MinButton = Instance.new("TextButton")
	MinButton.Size = UDim2.new(0, 28, 0, 28)
	MinButton.Position = UDim2.new(1, -68, 0, 8)
	MinButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	MinButton.BackgroundTransparency = 1
	MinButton.Text = "–"
	MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinButton.Font = Enum.Font.GothamBold
	MinButton.TextSize = 16
	MinButton.Parent = Header
	Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 4)
	
	local minimized = false
	
	MinButton.MouseEnter:Connect(function()
		Tween(MinButton, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(120, 120, 120)}, 0.2)
	end)
	MinButton.MouseLeave:Connect(function()
		if not minimized then
			Tween(MinButton, {BackgroundTransparency = 1}, 0.2)
		end
	end)
	MinButton.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			-- Hide content
			TabContainer.Visible = false
			ContentContainer.Visible = false
			-- Shrink window
			Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 45)}, 0.3, Enum.EasingStyle.Quint)
			Tween(MinButton, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(140, 140, 140)}, 0.2)
		else
			-- Expand window
			Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 450)}, 0.3, Enum.EasingStyle.Quint)
			Tween(MinButton, {BackgroundTransparency = 1}, 0.2)
			task.wait(0.3)
			-- Show content
			TabContainer.Visible = true
			ContentContainer.Visible = true
		end
	end)
	
	local Window = {Tabs = {}, CurrentTab = nil, Theme = currentTheme, ScreenGui = ScreenGui}
	
	function Window:Notification(title, text, duration)
		duration = duration or 3
		local NotifFrame = Instance.new("Frame")
		NotifFrame.Size = UDim2.new(0, 0, 0, 90)
		NotifFrame.Position = UDim2.new(1, -20, 1, -110)
		NotifFrame.AnchorPoint = Vector2.new(1, 0)
		NotifFrame.BackgroundColor3 = currentTheme.Secondary
		NotifFrame.BorderSizePixel = 0
		NotifFrame.ClipsDescendants = true
		NotifFrame.Parent = ScreenGui
		
		Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 6)
		
		local NotifAccent = Instance.new("Frame")
		NotifAccent.Size = UDim2.new(0, 4, 1, 0)
		NotifAccent.BackgroundColor3 = currentTheme.Accent
		NotifAccent.BorderSizePixel = 0
		NotifAccent.Parent = NotifFrame
		Instance.new("UICorner", NotifAccent).CornerRadius = UDim.new(0, 6)
		
		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Size = UDim2.new(1, -30, 0, 28)
		NotifTitle.Position = UDim2.new(0, 15, 0, 12)
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Text = title
		NotifTitle.TextColor3 = currentTheme.Text
		NotifTitle.Font = Enum.Font.GothamBold
		NotifTitle.TextSize = 15
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.Parent = NotifFrame
		
		local NotifText = Instance.new("TextLabel")
		NotifText.Size = UDim2.new(1, -30, 0, 40)
		NotifText.Position = UDim2.new(0, 15, 0, 40)
		NotifText.BackgroundTransparency = 1
		NotifText.Text = text
		NotifText.TextColor3 = currentTheme.SubText
		NotifText.Font = Enum.Font.Gotham
		NotifText.TextSize = 13
		NotifText.TextXAlignment = Enum.TextXAlignment.Left
		NotifText.TextYAlignment = Enum.TextYAlignment.Top
		NotifText.TextWrapped = true
		NotifText.Parent = NotifFrame
		
		Tween(NotifFrame, {Size = UDim2.new(0, 320, 0, 90)}, 0.4, Enum.EasingStyle.Back)
		task.spawn(function()
			task.wait(duration)
			Tween(NotifFrame, {Size = UDim2.new(0, 0, 0, 90)}, 0.3)
			task.wait(0.3)
			NotifFrame:Destroy()
		end)
	end
	
	function Window:Tab(name, index)
		local TabButton = Instance.new("TextButton")
		TabButton.Name = name
		TabButton.Size = UDim2.new(1, 0, 0, 32)
		TabButton.BackgroundColor3 = currentTheme.Tertiary
		TabButton.BorderSizePixel = 0
		TabButton.Text = name
		TabButton.TextColor3 = currentTheme.Text
		TabButton.Font = Enum.Font.GothamSemibold
		TabButton.TextSize = 13
		TabButton.LayoutOrder = index or 1
		TabButton.AutoButtonColor = false
		TabButton.Parent = TabContainer
		
		Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 4)
		
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.ScrollBarThickness = 5
		TabContent.ScrollBarImageColor3 = currentTheme.Accent
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.Visible = false
		TabContent.Parent = ContentContainer
		
		local ContentList = Instance.new("UIListLayout")
		ContentList.SortOrder = Enum.SortOrder.LayoutOrder
		ContentList.Padding = UDim.new(0, 10)
		ContentList.Parent = TabContent
		
		local ContentPadding = Instance.new("UIPadding")
		ContentPadding.PaddingTop = UDim.new(0, 12)
		ContentPadding.PaddingLeft = UDim.new(0, 12)
		ContentPadding.PaddingRight = UDim.new(0, 12)
		ContentPadding.PaddingBottom = UDim.new(0, 12)
		ContentPadding.Parent = TabContent
		
		ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 24)
		end)
		
		local Tab = {Content = TabContent, Theme = currentTheme, Button = TabButton}
		
		TabButton.MouseEnter:Connect(function()
			if Window.CurrentTab ~= Tab then
				local r = math.clamp(currentTheme.Tertiary.R * 255 + 15, 0, 255) / 255
				local g = math.clamp(currentTheme.Tertiary.G * 255 + 15, 0, 255) / 255
				local b = math.clamp(currentTheme.Tertiary.B * 255 + 15, 0, 255) / 255
				Tween(TabButton, {BackgroundColor3 = Color3.new(r, g, b)}, 0.2)
			end
		end)
		
		TabButton.MouseLeave:Connect(function()
			if Window.CurrentTab ~= Tab then
				Tween(TabButton, {BackgroundColor3 = currentTheme.Tertiary}, 0.2)
			end
		end)
		
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(Window.Tabs) do
				tab.Content.Visible = false
				Tween(tab.Button, {BackgroundColor3 = currentTheme.Tertiary}, 0.2)
			end
			TabContent.Visible = true
			Tween(TabButton, {BackgroundColor3 = currentTheme.Accent}, 0.2)
			Window.CurrentTab = Tab
		end)
		
		Window.Tabs[name] = Tab
		
		if not Window.CurrentTab then
			TabContent.Visible = true
			TabButton.BackgroundColor3 = currentTheme.Accent
			Window.CurrentTab = Tab
		end
		
		function Tab:Section(name, desc, index)
			local isOpen = true
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Size = UDim2.new(1, 0, 0, 50)
			SectionFrame.BackgroundColor3 = currentTheme.Secondary
			SectionFrame.BorderSizePixel = 0
			SectionFrame.LayoutOrder = index or 1
			SectionFrame.ClipsDescendants = true
			SectionFrame.Parent = TabContent
			
			Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 6)
			
			local SectionHeader = Instance.new("TextButton")
			SectionHeader.Size = UDim2.new(1, 0, 0, 50)
			SectionHeader.BackgroundTransparency = 1
			SectionHeader.Text = ""
			SectionHeader.AutoButtonColor = false
			SectionHeader.Parent = SectionFrame
			
			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Size = UDim2.new(1, -50, 0, 22)
			SectionTitle.Position = UDim2.new(0, 15, 0, 6)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Text = name
			SectionTitle.TextColor3 = currentTheme.Text
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.TextSize = 16
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.Parent = SectionHeader
			
			local SectionDesc = Instance.new("TextLabel")
			SectionDesc.Size = UDim2.new(1, -50, 0, 16)
			SectionDesc.Position = UDim2.new(0, 15, 0, 28)
			SectionDesc.BackgroundTransparency = 1
			SectionDesc.Text = desc
			SectionDesc.TextColor3 = currentTheme.SubText
			SectionDesc.Font = Enum.Font.Gotham
			SectionDesc.TextSize = 12
			SectionDesc.TextXAlignment = Enum.TextXAlignment.Left
			SectionDesc.Parent = SectionHeader
			
			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 0, 20)
			Arrow.Position = UDim2.new(1, -35, 0, 15)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "▼"
			Arrow.TextColor3 = currentTheme.Text
			Arrow.Font = Enum.Font.GothamBold
			Arrow.TextSize = 14
			Arrow.Parent = SectionHeader
			
			local SectionContent = Instance.new("Frame")
			SectionContent.Size = UDim2.new(1, 0, 0, 0)
			SectionContent.Position = UDim2.new(0, 0, 0, 50)
			SectionContent.BackgroundTransparency = 1
			SectionContent.Parent = SectionFrame
			SectionContent.AutomaticSize = Enum.AutomaticSize.Y
			
			local SectionList = Instance.new("UIListLayout")
			SectionList.SortOrder = Enum.SortOrder.LayoutOrder
			SectionList.Padding = UDim.new(0, 6)
			SectionList.Parent = SectionContent
			
			local SectionPadding = Instance.new("UIPadding")
			SectionPadding.PaddingLeft = UDim.new(0, 12)
			SectionPadding.PaddingRight = UDim.new(0, 12)
			SectionPadding.PaddingBottom = UDim.new(0, 12)
			SectionPadding.Parent = SectionContent
			
			SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if isOpen then
					Tween(SectionFrame, {Size = UDim2.new(1, 0, 0, 50 + SectionList.AbsoluteContentSize.Y + 12)}, 0.3)
				end
			end)
			
			SectionHeader.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				if isOpen then
					Tween(SectionFrame, {Size = UDim2.new(1, 0, 0, 50 + SectionList.AbsoluteContentSize.Y + 12)}, 0.3)
					Tween(Arrow, {Rotation = 0}, 0.3)
				else
					Tween(SectionFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.3)
					Tween(Arrow, {Rotation = -90}, 0.3)
				end
			end)
			
			local Section = {}
			
			function Section:Button(text, callback)
				local Button = Instance.new("TextButton")
				Button.Size = UDim2.new(1, 0, 0, 38)
				Button.BackgroundColor3 = currentTheme.Tertiary
				Button.BorderSizePixel = 0
				Button.Text = text
				Button.TextColor3 = currentTheme.Text
				Button.Font = Enum.Font.GothamSemibold
				Button.TextSize = 13
				Button.AutoButtonColor = false
				Button.Parent = SectionContent
				Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
				
				Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = currentTheme.Accent}, 0.2) end)
				Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = currentTheme.Tertiary}, 0.2) end)
				Button.MouseButton1Click:Connect(function()
					Tween(Button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
					task.wait(0.1)
					Tween(Button, {Size = UDim2.new(1, 0, 0, 38)}, 0.1)
					pcall(callback)
				end)
			end
			
			function Section:Toggle(text, default, callback)
				local toggled = default or false
				local ToggleFrame = Instance.new("Frame")
				ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
				ToggleFrame.BackgroundColor3 = currentTheme.Tertiary
				ToggleFrame.BorderSizePixel = 0
				ToggleFrame.Parent = SectionContent
				Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)
				
				local ToggleLabel = Instance.new("TextLabel")
				ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
				ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
				ToggleLabel.BackgroundTransparency = 1
				ToggleLabel.Text = text
				ToggleLabel.TextColor3 = currentTheme.Text
				ToggleLabel.Font = Enum.Font.Gotham
				ToggleLabel.TextSize = 13
				ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
				ToggleLabel.Parent = ToggleFrame
				
				local ToggleButton = Instance.new("TextButton")
				ToggleButton.Size = UDim2.new(0, 44, 0, 22)
				ToggleButton.Position = UDim2.new(1, -54, 0.5, -11)
				ToggleButton.BackgroundColor3 = toggled and currentTheme.Accent or Color3.fromRGB(60, 60, 60)
				ToggleButton.BorderSizePixel = 0
				ToggleButton.Text = ""
				ToggleButton.AutoButtonColor = false
				ToggleButton.Parent = ToggleFrame
				Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
				
				local ToggleCircle = Instance.new("Frame")
				ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
				ToggleCircle.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
				ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleCircle.BorderSizePixel = 0
				ToggleCircle.Parent = ToggleButton
				Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0)
				
				ToggleButton.MouseButton1Click:Connect(function()
					toggled = not toggled
					Tween(ToggleButton, {BackgroundColor3 = toggled and currentTheme.Accent or Color3.fromRGB(60, 60, 60)}, 0.25)
					Tween(ToggleCircle, {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.25)
					pcall(callback, toggled)
				end)
			end
			
			function Section:Dropdown(config)
				local text = type(config) == "table" and config.text or config
				local options = type(config) == "table" and config.options or {}
				local callback = type(config) == "table" and config.callback or function() end
				local multi = type(config) == "table" and config.multi or false
				
				local opened = false
				local selectedOptions = {}
				local selectedOption = "Select..."
				
				local DropdownFrame = Instance.new("Frame")
				DropdownFrame.Size = UDim2.new(1, 0, 0, 65)
				DropdownFrame.BackgroundColor3 = currentTheme.Tertiary
				DropdownFrame.BorderSizePixel = 0
				DropdownFrame.ClipsDescendants = true
				DropdownFrame.Parent = SectionContent
				Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)
				
				local DropdownLabel = Instance.new("TextLabel")
				DropdownLabel.Size = UDim2.new(1, -24, 0, 20)
				DropdownLabel.Position = UDim2.new(0, 12, 0, 8)
				DropdownLabel.BackgroundTransparency = 1
				DropdownLabel.Text = text .. (multi and " (Multi)" or "")
				DropdownLabel.TextColor3 = currentTheme.Text
				DropdownLabel.Font = Enum.Font.Gotham
				DropdownLabel.TextSize = 13
				DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
				DropdownLabel.Parent = DropdownFrame
				
				local DropdownButton = Instance.new("TextButton")
				DropdownButton.Size = UDim2.new(1, -24, 0, 28)
				DropdownButton.Position = UDim2.new(0, 12, 0, 30)
				DropdownButton.BackgroundColor3 = currentTheme.Secondary
				DropdownButton.BorderSizePixel = 0
				DropdownButton.Text = ""
				DropdownButton.Parent = DropdownFrame
				Instance.new("UICorner", DropdownButton).CornerRadius = UDim.new(0, 4)
				
				local SelectedLabel = Instance.new("TextLabel")
				SelectedLabel.Size = UDim2.new(1, -35, 1, 0)
				SelectedLabel.Position = UDim2.new(0, 10, 0, 0)
				SelectedLabel.BackgroundTransparency = 1
				SelectedLabel.Text = selectedOption
				SelectedLabel.TextColor3 = currentTheme.SubText
				SelectedLabel.Font = Enum.Font.Gotham
				SelectedLabel.TextSize = 12
				SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
				SelectedLabel.TextWrapped = true
				SelectedLabel.Parent = DropdownButton
				
				local Arrow = Instance.new("TextLabel")
				Arrow.Size = UDim2.new(0, 20, 1, 0)
				Arrow.Position = UDim2.new(1, -25, 0, 0)
				Arrow.BackgroundTransparency = 1
				Arrow.Text = "▼"
				Arrow.TextColor3 = currentTheme.Text
				Arrow.Font = Enum.Font.GothamBold
				Arrow.TextSize = 10
				Arrow.Parent = DropdownButton
				
				local OptionsList = Instance.new("Frame")
				OptionsList.Size = UDim2.new(1, 0, 0, 0)
				OptionsList.Position = UDim2.new(0, 0, 0, 65)
				OptionsList.BackgroundTransparency = 1
				OptionsList.Parent = DropdownFrame
				OptionsList.AutomaticSize = Enum.AutomaticSize.Y
				
				local OptionsLayout = Instance.new("UIListLayout")
				OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
				OptionsLayout.Padding = UDim.new(0, 2)
				OptionsLayout.Parent = OptionsList
				
				local OptionsPadding = Instance.new("UIPadding")
				OptionsPadding.PaddingTop = UDim.new(0, 5)
				OptionsPadding.PaddingBottom = UDim.new(0, 5)
				OptionsPadding.PaddingLeft = UDim.new(0, 12)
				OptionsPadding.PaddingRight = UDim.new(0, 12)
				OptionsPadding.Parent = OptionsList
				
				local function updateLabel()
					if multi then
						if #selectedOptions == 0 then
							SelectedLabel.Text = "None Selected"
							SelectedLabel.TextColor3 = currentTheme.SubText
						else
							SelectedLabel.Text = table.concat(selectedOptions, ", ")
							SelectedLabel.TextColor3 = currentTheme.Text
						end
					end
				end
				
				for _, option in ipairs(options) do
					local OptionButton = Instance.new("TextButton")
					OptionButton.Size = UDim2.new(1, 0, 0, 28)
					OptionButton.BackgroundColor3 = currentTheme.Tertiary
					OptionButton.BorderSizePixel = 0
					OptionButton.Text = ""
					OptionButton.AutoButtonColor = false
					OptionButton.Parent = OptionsList
					Instance.new("UICorner", OptionButton).CornerRadius = UDim.new(0, 4)
					
					local OptionLabel = Instance.new("TextLabel")
					OptionLabel.Size = UDim2.new(1, multi and -30 or -10, 1, 0)
					OptionLabel.Position = UDim2.new(0, 10, 0, 0)
					OptionLabel.BackgroundTransparency = 1
					OptionLabel.Text = option
					OptionLabel.TextColor3 = currentTheme.Text
					OptionLabel.Font = Enum.Font.Gotham
					OptionLabel.TextSize = 12
					OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
					OptionLabel.Parent = OptionButton
					
					local Checkmark
					if multi then
						Checkmark = Instance.new("TextLabel")
						Checkmark.Size = UDim2.new(0, 20, 0, 20)
						Checkmark.Position = UDim2.new(1, -24, 0.5, -10)
						Checkmark.BackgroundColor3 = currentTheme.Secondary
						Checkmark.BorderSizePixel = 0
						Checkmark.Text = ""
						Checkmark.TextColor3 = currentTheme.Accent
						Checkmark.Font = Enum.Font.GothamBold
						Checkmark.TextSize = 14
						Checkmark.Parent = OptionButton
						Instance.new("UICorner", Checkmark).CornerRadius = UDim.new(0, 3)
					end
					
					OptionButton.MouseEnter:Connect(function() 
						Tween(OptionButton, {BackgroundColor3 = Color3.fromRGB(23, 23, 23)}, 0.2) 
					end)
					OptionButton.MouseLeave:Connect(function() 
						Tween(OptionButton, {BackgroundColor3 = currentTheme.Tertiary}, 0.2) 
					end)
					OptionButton.MouseButton1Click:Connect(function()
						if multi then
							local index = table.find(selectedOptions, option)
							if index then
								table.remove(selectedOptions, index)
								Checkmark.Text = ""
							else
								table.insert(selectedOptions, option)
								Checkmark.Text = "✓"
							end
							updateLabel()
							pcall(callback, selectedOptions)
						else
							selectedOption = option
							SelectedLabel.Text = option
							SelectedLabel.TextColor3 = currentTheme.Text
							opened = false
							Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 65)}, 0.3)
							Tween(Arrow, {Rotation = 0}, 0.3)
							pcall(callback, option)
						end
					end)
				end
				
				DropdownButton.MouseButton1Click:Connect(function()
					opened = not opened
					local targetSize = opened and UDim2.new(1, 0, 0, 65 + OptionsLayout.AbsoluteContentSize.Y + 10) or UDim2.new(1, 0, 0, 65)
					Tween(DropdownFrame, {Size = targetSize}, 0.3)
					Tween(Arrow, {Rotation = opened and 180 or 0}, 0.3)
				end)
				
				if multi then
					updateLabel()
				end
			end
			
			function Section:Input(text, placeholder, callback)
				local InputFrame = Instance.new("Frame")
				InputFrame.Size = UDim2.new(1, 0, 0, 65)
				InputFrame.BackgroundColor3 = currentTheme.Tertiary
				InputFrame.BorderSizePixel = 0
				InputFrame.Parent = SectionContent
				Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)
				
				local InputLabel = Instance.new("TextLabel")
				InputLabel.Size = UDim2.new(1, -24, 0, 20)
				InputLabel.Position = UDim2.new(0, 12, 0, 8)
				InputLabel.BackgroundTransparency = 1
				InputLabel.Text = text
				InputLabel.TextColor3 = currentTheme.Text
				InputLabel.Font = Enum.Font.Gotham
				InputLabel.TextSize = 13
				InputLabel.TextXAlignment = Enum.TextXAlignment.Left
				InputLabel.Parent = InputFrame
				
				local InputBox = Instance.new("TextBox")
				InputBox.Size = UDim2.new(1, -24, 0, 28)
				InputBox.Position = UDim2.new(0, 12, 0, 30)
				InputBox.BackgroundColor3 = currentTheme.Secondary
				InputBox.BorderSizePixel = 0
				InputBox.Text = ""
				InputBox.PlaceholderText = placeholder
				InputBox.TextColor3 = currentTheme.Text
				InputBox.PlaceholderColor3 = currentTheme.SubText
				InputBox.Font = Enum.Font.Gotham
				InputBox.TextSize = 12
				InputBox.ClearTextOnFocus = false
				InputBox.Parent = InputFrame
				Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 4)
				
				InputBox.FocusLost:Connect(function() pcall(callback, InputBox.Text) end)
			end
			
			function Section:Paragraph(title, content)
				local ParagraphFrame = Instance.new("Frame")
				ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
				ParagraphFrame.BackgroundColor3 = currentTheme.Tertiary
				ParagraphFrame.BorderSizePixel = 0
				ParagraphFrame.Parent = SectionContent
				ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
				Instance.new("UICorner", ParagraphFrame).CornerRadius = UDim.new(0, 4)
				
				local ParagraphTitle = Instance.new("TextLabel")
				ParagraphTitle.Size = UDim2.new(1, -24, 0, 22)
				ParagraphTitle.Position = UDim2.new(0, 12, 0, 10)
				ParagraphTitle.BackgroundTransparency = 1
				ParagraphTitle.Text = title
				ParagraphTitle.TextColor3 = currentTheme.Text
				ParagraphTitle.Font = Enum.Font.GothamBold
				ParagraphTitle.TextSize = 14
				ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphTitle.Parent = ParagraphFrame
				
				local ParagraphContent = Instance.new("TextLabel")
				ParagraphContent.Size = UDim2.new(1, -24, 0, 0)
				ParagraphContent.Position = UDim2.new(0, 12, 0, 34)
				ParagraphContent.BackgroundTransparency = 1
				ParagraphContent.Text = content
				ParagraphContent.TextColor3 = currentTheme.SubText
				ParagraphContent.Font = Enum.Font.Gotham
				ParagraphContent.TextSize = 12
				ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
				ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
				ParagraphContent.TextWrapped = true
				ParagraphContent.AutomaticSize = Enum.AutomaticSize.Y
				ParagraphContent.Parent = ParagraphFrame
				
				local ParagraphPadding = Instance.new("UIPadding")
				ParagraphPadding.PaddingBottom = UDim.new(0, 12)
				ParagraphPadding.Parent = ParagraphFrame
			end
			
			return Section
		end
		
		function Tab:Invite(name, desc, link)
			local InviteFrame = Instance.new("Frame")
			InviteFrame.Size = UDim2.new(1, 0, 0, 95)
			InviteFrame.BackgroundColor3 = currentTheme.Secondary
			InviteFrame.BorderSizePixel = 0
			InviteFrame.Parent = TabContent
			Instance.new("UICorner", InviteFrame).CornerRadius = UDim.new(0, 6)
			
			local InviteName = Instance.new("TextLabel")
			InviteName.Size = UDim2.new(1, -24, 0, 24)
			InviteName.Position = UDim2.new(0, 12, 0, 12)
			InviteName.BackgroundTransparency = 1
			InviteName.Text = name
			InviteName.TextColor3 = currentTheme.Text
			InviteName.Font = Enum.Font.GothamBold
			InviteName.TextSize = 16
			InviteName.TextXAlignment = Enum.TextXAlignment.Left
			InviteName.Parent = InviteFrame
			
			local InviteDesc = Instance.new("TextLabel")
			InviteDesc.Size = UDim2.new(1, -24, 0, 18)
			InviteDesc.Position = UDim2.new(0, 12, 0, 36)
			InviteDesc.BackgroundTransparency = 1
			InviteDesc.Text = desc
			InviteDesc.TextColor3 = currentTheme.SubText
			InviteDesc.Font = Enum.Font.Gotham
			InviteDesc.TextSize = 12
			InviteDesc.TextXAlignment = Enum.TextXAlignment.Left
			InviteDesc.Parent = InviteFrame
			
			local CopyButton = Instance.new("TextButton")
			CopyButton.Size = UDim2.new(1, -24, 0, 32)
			CopyButton.Position = UDim2.new(0, 12, 0, 56)
			CopyButton.BackgroundColor3 = currentTheme.Tertiary
			CopyButton.BorderSizePixel = 0
			CopyButton.Text = "Copy Invite Link"
			CopyButton.TextColor3 = currentTheme.Text
			CopyButton.Font = Enum.Font.GothamSemibold
			CopyButton.TextSize = 13
			CopyButton.AutoButtonColor = false
			CopyButton.Parent = InviteFrame
			Instance.new("UICorner", CopyButton).CornerRadius = UDim.new(0, 4)
			
			CopyButton.MouseEnter:Connect(function() Tween(CopyButton, {BackgroundColor3 = currentTheme.Accent}, 0.2) end)
			CopyButton.MouseLeave:Connect(function() Tween(CopyButton, {BackgroundColor3 = currentTheme.Tertiary}, 0.2) end)
			CopyButton.MouseButton1Click:Connect(function()
				setclipboard(link)
				CopyButton.Text = "Copied!"
				task.wait(1)
				CopyButton.Text = "Copy Invite Link"
			end)
		end
		
		return Tab
	end
	
	-- Create Misc Tab if enabled
	if misc then
		task.spawn(function()
			task.wait(0.2)
			local MiscTab = Window:Tab("Misc", 999)
			
			local MiscInfoFrame = Instance.new("Frame")
			MiscInfoFrame.Size = UDim2.new(1, 0, 0, 140)
			MiscInfoFrame.BackgroundColor3 = currentTheme.Secondary
			MiscInfoFrame.BorderSizePixel = 0
			MiscInfoFrame.Parent = MiscTab.Content
			Instance.new("UICorner", MiscInfoFrame).CornerRadius = UDim.new(0, 6)
			
			local PlayerIcon = Instance.new("ImageLabel")
			PlayerIcon.Size = UDim2.new(0, 60, 0, 60)
			PlayerIcon.Position = UDim2.new(0, 20, 0, 20)
			PlayerIcon.BackgroundColor3 = currentTheme.Tertiary
			PlayerIcon.BorderSizePixel = 0
			PlayerIcon.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
			PlayerIcon.Parent = MiscInfoFrame
			Instance.new("UICorner", PlayerIcon).CornerRadius = UDim.new(1, 0)
			
			local HelloText = Instance.new("TextLabel")
			HelloText.Size = UDim2.new(1, -100, 0, 25)
			HelloText.Position = UDim2.new(0, 90, 0, 20)
			HelloText.BackgroundTransparency = 1
			HelloText.Text = "Hello " .. LocalPlayer.Name .. "!"
			HelloText.TextColor3 = currentTheme.Text
			HelloText.Font = Enum.Font.GothamBold
			HelloText.TextSize = 18
			HelloText.TextXAlignment = Enum.TextXAlignment.Left
			HelloText.Parent = MiscInfoFrame
			
			local ThanksText = Instance.new("TextLabel")
			ThanksText.Size = UDim2.new(1, -100, 0, 40)
			ThanksText.Position = UDim2.new(0, 90, 0, 45)
			ThanksText.BackgroundTransparency = 1
			ThanksText.Text = "Thanks for using Nexus UI\nNexus is a fast and lightweight UI design"
			ThanksText.TextColor3 = currentTheme.SubText
			ThanksText.Font = Enum.Font.Gotham
			ThanksText.TextSize = 12
			ThanksText.TextXAlignment = Enum.TextXAlignment.Left
			ThanksText.TextYAlignment = Enum.TextYAlignment.Top
			ThanksText.TextWrapped = true
			ThanksText.Parent = MiscInfoFrame
			
			local VersionText = Instance.new("TextLabel")
			VersionText.Size = UDim2.new(1, -40, 0, 20)
			VersionText.Position = UDim2.new(0, 20, 1, -35)
			VersionText.BackgroundTransparency = 1
			VersionText.Text = "Version • " .. OFFICIAL_VERSION
			VersionText.TextColor3 = currentTheme.Accent
			VersionText.Font = Enum.Font.GothamBold
			VersionText.TextSize = 14
			VersionText.TextXAlignment = Enum.TextXAlignment.Left
			VersionText.Parent = MiscInfoFrame
		end)
	end
	
	return Window
end

return Library
