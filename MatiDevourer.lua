-- FPS DEVOURER FINAL ABSOLUTE - LocalScript

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local TOOL_NAME = "Dark Matter Slap"
local TOGGLE_INTERVAL = 0.01 -- 🔥 velocidad extrema

-- ================= UI =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FpsDevourerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,300,0,120)
mainFrame.Position = UDim2.new(0.05,0,0.35,0)
mainFrame.BackgroundColor3 = Color3.fromRGB(5,5,5)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,-20,0,30)
title.Position = UDim2.new(0,10,0,6)
title.BackgroundTransparency = 1
title.Text = "Fps Devourer"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(1,-20,0,46)
toggleBtn.Position = UDim2.new(0,10,0,44)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
toggleBtn.Text = "Fps Devourer Off"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,12)

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-36,0,8)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

-- ================= Drag =================
local dragging, dragStart, startPos = false,nil,nil

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
end)

mainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- ================= Utils =================
local function getBackpack()
	return player:FindFirstChild("Backpack")
end

local function getCharacter()
	return player.Character
end

local function findMainTool()
	local backpack = getBackpack()
	local char = getCharacter()
	if backpack and backpack:FindFirstChild(TOOL_NAME) then
		return backpack:FindFirstChild(TOOL_NAME)
	end
	if char and char:FindFirstChild(TOOL_NAME) then
		return char:FindFirstChild(TOOL_NAME)
	end
	return nil
end

local function getAllTools()
	local tools = {}
	local backpack = getBackpack()
	local char = getCharacter()

	if backpack then
		for _,v in ipairs(backpack:GetChildren()) do
			if v:IsA("Tool") then
				table.insert(tools,v)
			end
		end
	end

	if char then
		for _,v in ipairs(char:GetChildren()) do
			if v:IsA("Tool") then
				table.insert(tools,v)
			end
		end
	end

	return tools
end

local function equip(tool)
	if tool and getCharacter() then
		pcall(function()
			tool.Parent = getCharacter()
		end)
	end
end

local function unequip(tool)
	if tool and getBackpack() then
		pcall(function()
			tool.Parent = getBackpack()
		end)
	end
end

-- ================= Visual Only Clothing Removal =================
local function remove3D(character)
	if not character then return end

	local function hide()
		for _,v in ipairs(character:GetDescendants()) do
			
			-- Accessories / ropa 3D
			if v:IsA("Accessory") or v:IsA("Hat") then
				for _,p in ipairs(v:GetDescendants()) do
					if p:IsA("BasePart") then
						p.LocalTransparencyModifier = 1
						p.Transparency = 1
					end
					if p:IsA("Decal") or p:IsA("Texture") then
						p.Transparency = 1
					end
					if p:IsA("SurfaceAppearance") then
						p:Destroy() -- local only
					end
				end
			end

			-- Ropa clásica
			if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
				pcall(function()
					v.Enabled = false
				end)
			end

			-- Layered clothing
			if v:IsA("WrapLayer") or v:IsA("WrapTarget") then
				pcall(function()
					v.Enabled = false
				end)
			end

			-- MeshParts (ropa 3D)
			if v:IsA("MeshPart") or v:IsA("BasePart") then
				local n = v.Name:lower()
				if n:find("cloth") or n:find("clothes") or n:find("shirt")
				or n:find("pants") or n:find("jacket") or n:find("hoodie")
				or n:find("robe") or n:find("outfit") then
					v.LocalTransparencyModifier = 1
					v.Transparency = 1
				end
			end
		end
	end

	-- aplicar varias veces (Roblox reaplica apariencia)
	hide()
	task.delay(0.3, hide)
	task.delay(0.8, hide)
	task.delay(1.5, hide)
end

-- ================= Loop =================
local active = false
local running = false

local function startLoop()
	if running then return end
	running = true

	task.spawn(function()
		while active do
			local mainTool = findMainTool()

			if mainTool then
				-- Modo Dark Matter Slap
				if mainTool.Parent == getCharacter() then
					unequip(mainTool)
				else
					equip(mainTool)
				end
			else
				-- 🔥 UNA POR UNA
				local tools = getAllTools()
				local char = getCharacter()
				local backpack = getBackpack()

				if char and backpack then
					-- Equipar una por una
					for _,t in ipairs(tools) do
						if not active then break end
						equip(t)
						task.wait(TOGGLE_INTERVAL)
					end

					-- Desequipar una por una
					for _,t in ipairs(tools) do
						if not active then break end
						unequip(t)
						task.wait(TOGGLE_INTERVAL)
					end
				end
			end

			task.wait(TOGGLE_INTERVAL)
		end
		running = false
	end)
end

local function stopLoop()
	active = false
end

-- ================= Buttons =================
toggleBtn.MouseButton1Click:Connect(function()
	active = not active
	if active then
		toggleBtn.Text = "Fps Devourer On"
		if getCharacter() then
			remove3D(getCharacter()) -- solo visual
		end
		startLoop()
	else
		toggleBtn.Text = "Fps Devourer Off"
		stopLoop()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)

-- ================= Respawn =================
player.CharacterAdded:Connect(function(char)
	if active then
		task.wait(0.2)
		remove3D(char)
	end
end)

-- ================= Appearance Loaded Hook =================
player.CharacterAppearanceLoaded:Connect(function(char)
	if active then
		task.wait(0.2)
		remove3D(char)
	end
end)
