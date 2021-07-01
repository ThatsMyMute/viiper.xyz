local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Arsenal HVH script", "Synapse")
local Tab = Window:NewTab("silent aim + esp")
local Tab2 = Window:NewTab("spinbot + misc")
local aim = Tab:NewSection("spin bot + misc")
local skid = Tab:NewSection("silent aim + esp")
skid:NewToggle("Silent aim", "Silent aim and wall bang", function(state)
    if state then
        print("Toggle On")
        local Client
for i,v in pairs(getgc(true)) do
	if type(v) == "table" and rawget(v, "mode") then
		Client = v;
	end
end

local wkspc = Client.wkspc
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function isSameTeam(Player, Player2)
	if wkspc.FFA.Value == true then
		return false
	else
		return Player.TeamColor == Player2.TeamColor and true or false
	end
end

function getClosestToMouse()
	local closestdis = math.huge
	local closestplr
	local mspos = Mouse.hit.p
	for i,v in pairs(Players:GetPlayers()) do
		if v:DistanceFromCharacter(mspos) < closestdis and not isSameTeam(LocalPlayer, v) and v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Spawned") then
			closestplr = v
			closestdis = v:DistanceFromCharacter(mspos)
		end
	end
	if not closestplr then return LocalPlayer end
	return closestplr
end

rawset(Client, "firebullet", 
	newcclosure(function()
		local Random
		repeat
			Random = getClosestToMouse()
			until Random.Character and Random.Character:FindFirstChild("Head")
		local Gun = ReplicatedStorage.Weapons:FindFirstChild(LocalPlayer.NRPBS.EquippedTool.Value);
		local Distance = (LocalPlayer.Character.Head.Position - Random.Character.Head.Position).magnitude
		
		for i = 1, 5 do
			ReplicatedStorage.Events.HitPart:FireServer(
				Random.Character.Head,
				Random.Character.Head.Position + Vector3.new(math.random(), math.random(), math.random()),
				Gun.Name,
				2,
				Distance,
				false,
				true,
				false,
				1,
				false,
				Gun.FireRate.Value,
				Gun.ReloadTime.Value,
				Gun.Ammo.Value,
				Gun.StoredAmmo.Value,
				Gun.Bullets.Value,
				Gun.EquipTime.Value,
				Gun.RecoilControl.Value,
				Gun.Auto.Value,
				Gun['Speed%'].Value,
				wkspc.DistributedTime.Value
			)
		end
	end)
)
    else
        print("Toggle Off", "turned Off")
    end
end)

skid:NewToggle("Esp", "ESP", function(state)
    if state then
        -- -----------------------------------
--  ___      _   _   _              --
-- / __| ___| |_| |_(_)_ _  __ _ ___--
-- \__ \/ -_)  _|  _| | ' \/ _` (_-<--
-- |___/\___|\__|\__|_|_||_\__, /__/--
--                         |___/    --
-- -----------------------------------
-- -----------------------------------
								ALLYCOLOR = {0,255,255}  	--//Color of the ESP  of people on the same team
								ENEMYCOLOR =  {255,0,0} 	--//Color of the ESP  of people on NOT the same team
								TRANSPARENCY = 0.5			--//Transparency of the ESP
								HEALTHBAR_ACTIVATED = false --//Renders the Healthbar
--
--

--							!!!Don't Change Anything Below Here Unless You Know What You're Doing!!!

function createFlex()
-- -----------------------------------------------------------------------------------
--[VARIABLES] //Changing may result in Errors!
players = game:GetService("Players") --//Required for PF
faces = {"Front","Back","Bottom","Left","Right","Top"} --//Every possible Enum face
currentPlayer = nil --//Used for the Team-Check
lplayer = players.LocalPlayer --//The LocalPlayer
-- -----------------------------------------------------------------------------------
players.PlayerAdded:Connect(function(p)
	currentPlayer = p
		p.CharacterAdded:Connect(function(character) --//For when a new Player joins the game 
			createESP(character)			
		end)		
end)
-- -----------------------------------------------------------------------------------
function checkPart(obj)  if (obj:IsA("Part") or obj:IsA("MeshPart")) and obj.Name~="HumanoidRootPart" then return true end end --//Check if the Part is suitable 
-- -----------------------------------------------------------------------------------
function actualESP(obj) 
	
	for i=0,5 do
		surface = Instance.new("SurfaceGui",obj) --//Creates the SurfaceGui
		surface.Face = Enum.NormalId[faces[i+1]] --//Adjusts the Face and chooses from the face table
		surface.AlwaysOnTop = true

		frame = Instance.new("Frame",surface)	--//Creates the viewable Frame
		frame.Size = UDim2.new(1,0,1,0)
		frame.BorderSizePixel = 0												
		frame.BackgroundTransparency = TRANSPARENCY
			if currentPlayer.Team == players.LocalPlayer.Team then --//Checks the Players Team
					frame.BackgroundColor3 = Color3.new(ALLYCOLOR[1],ALLYCOLOR[2],ALLYCOLOR[3])	--//If in same Team											
			else
				frame.BackgroundColor3 = Color3.new(ENEMYCOLOR[1],ENEMYCOLOR[2],ENEMYCOLOR[3])	--//If in another Team
			end
															
	end
end
-- -----------------------------------------------------------------------------------
function createHealthbar(hrp) 
	board =Instance.new("BillboardGui",hrp) --//Creates the BillboardGui with HumanoidRootPart as the Parent
	board.Name = "total"
	board.Size = UDim2.new(1,0,1,0)
	board.StudsOffset = Vector3.new(3,1,0)
	board.AlwaysOnTop = true

	bar = Instance.new("Frame",board) --//Creates the red background
	bar.BackgroundColor3 = Color3.new(255,0,0)
	bar.BorderSizePixel = 0
	bar.Size = UDim2.new(0.2,0,4,0)
	bar.Name = "total2"
												
	health = Instance.new("Frame",bar) --//Creates the changing green Frame
	health.BackgroundColor3 = Color3.new(0,255,0)
	health.BorderSizePixel = 0
	health.Size = UDim2.new(1,0,hrp.Parent.Humanoid.Health/100,0)
		hrp.Parent.Humanoid.Changed:Connect(function(property) --//Triggers when any Property changed
			hrp.total.total2.Frame.Size = UDim2.new(1,0,hrp.Parent.Humanoid.Health/100,0) --//Adjusts the size of the green Frame								
		end)
end
-- -----------------------------------------------------------------------------------
function createESP(c) --//Checks and calls the proper function
	bugfix = c:WaitForChild("Head") --// *Used so the children of the character arent nil.
	for i,v in pairs(c:GetChildren()) do
		if checkPart(v) then
		actualESP(v)
		end
	end
	if HEALTHBAR_ACTIVATED then --//If the user decided to
		createHealthbar(c:WaitForChild("HumanoidRootPart")) --//Calls the function of the creation
	end
end
-- -----------------------------------------------------------------------------------
for i,people in pairs(players:GetChildren())do
	if people ~= players.LocalPlayer then
		currentPlayer = people
																--//Used for Players already in the Game
		createESP(people.Character)
			people.CharacterAdded:Connect(function(character)
				createESP(character)			
			end)
	end
end
-- -----------------------------------------------------------------------------------
end --//End of the entire function

createFlex() --// Does exactly that :)
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)

aim:NewToggle("noclip", "no clip", function(state)
    if state then
local noclip = true char = game.Players.LocalPlayer.Character while true do if noclip == true then for _,v in pairs(char:children()) do pcall(function() if v.className == "Part" then v.CanCollide = false elseif v.ClassName == "Model" then v.Head.CanCollide = false end end) end end game:service("RunService").Stepped:wait() end
    else
        print("gethook")
        end
end)
