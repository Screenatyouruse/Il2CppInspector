--not a bypass, but still needed
task.spawn(function()
    local IAMGOINGINSANEFROMYOU = true
    while IAMGOINGINSANEFROMYOU do task.wait(1)
        for _,v in pairs(game.LogService:GetLogHistory()) do
            if string.find(v["message"], "BEGAN") or string.find(v["message"], "Data Error") then
                game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
                IAMGOINGINSANEFROMYOU = false
            end
        end
    end
end)

repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("RemoteEvent")

if getgenv().fpsBoost then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end

local LocalPlayer = game.Players.LocalPlayer
local Backpack = game.Players.LocalPlayer.Backpack
local PlayerStats = game.Players.LocalPlayer.PlayerStats
local currentQuest = "NaN"
local hasDioQuest = false

local timeExecuted, attemptedTWOH = 0, 0

local Data = { }
local File = pcall(function()
    Data = game:GetService('HttpService'):JSONDecode(readfile("AutoTWOH_"..LocalPlayer.Name..".txt"))
end)

    task.spawn(function()
	if not File then
	    while task.wait(1) do
			timeExecuted = timeExecuted + 1
		    Data = {
		        ["Time"] = timeExecuted,
                ["Attempts"] = 0,
		        ["Account"] = LocalPlayer.Name
		    }
		    writefile("AutoTWOH_"..LocalPlayer.Name..".txt", game:GetService('HttpService'):JSONEncode(Data))
		end
    else
    	timeExecuted = Data["Time"]
        attemptedTWOH = Data["Attempts"]
		while task.wait(1) do
            timeExecuted = timeExecuted + 1
            Data = {
                ["Time"] = timeExecuted,
                ["Attempts"] = attemptedTWOH,
                ["Account"] = LocalPlayer.Name
            }
            writefile("AutoTWOH_"..LocalPlayer.Name..".txt", game:GetService('HttpService'):JSONEncode(Data))
        end
    end
end)

--[[BYPASSES]]
--crash bypass
local function startBypasses()
    local functionLibrary = require(game.ReplicatedStorage:WaitForChild('Modules').FunctionLibrary) --TODO: FIND THE REASON WHY THIS IS ERRORING SOMETIMES
    local old = functionLibrary.pcall

    functionLibrary.pcall = function(...)
        local f = ...

        if type(f) == 'function' and #getupvalues(f) == 11 then 
            return
        end
        
        return old(...)
    end

    --tp bypass
    local Hook;
    Hook = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
        local args = {...}
        local namecallmethod =  getnamecallmethod()

        if namecallmethod == "InvokeServer" then
            if args[1] == "idklolbrah2de" then
                return "  ___XP DE KEY"
            end
        end
        
        if (namecallmethod == "InvokeServer" or namecallmethod == "InvokeClient") and args[1] == "Reset" and args[3] ~= "DANK WAS HERE" then
            return
        end
        if namecallmethod == "FireServer" and args[1] == "Reset" and args[3] ~= "DANK WAS HERE" then
            return
        end
        return Hook(self, ...)
    end))


    --reset
    local NewEvent = Instance.new("BindableEvent")
    NewEvent.Event:Connect(function()
                    
    local args = {
        [1] = "Reset",
        [2] = {
            ["Anchored"] = false
        },
            [3] = "DANK WAS HERE"
        }

        game:GetService("Players").LocalPlayer.Character.RemoteEvent:FireServer(unpack(args))
    end)

    game:GetService("StarterGui"):SetCore("ResetButtonCallback", NewEvent)
end

--[[STARTING SCREEN]]
local function skipScreen()
    if not LocalPlayer.PlayerGui:FindFirstChild("HUD") then
        print("I FOUND IT")
        local HUD = game.ReplicatedStorage.Objects.HUD:Clone()
        HUD.Parent = LocalPlayer.PlayerGui
    end

    print("I DID FOUND IT, MAYBE IT WILL WORK?")
    LocalPlayer.Character.RemoteEvent:FireServer("PressedPlay")

    if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen1") then
        LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen1"):Destroy()
    end

    if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen") then
        LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen"):Destroy()
    end
end



--[[MAIN FUNCTIONS]]
local function SendWebhook(msg, webHookLink, update)
    local data, url, timeOut
    task.spawn(function()
        if not webHookLink then
            url = getgenv().mainWebhook
        else
            url = webHookLink
        end
        
        if not update then
            data = {
                ["embeds"] = {
                    {
                        ["footer"] = {
                            ["text"] = "Current Time: " .. os.date("%Y-%m-%d %H:%M:%S"),
                            ["icon_url"] = "https://cdn.discordapp.com/attachments/1015581960711720971/1136896939540090930/image.png"},

                        ["title"] = "Xenon V3 - Auto The World Over Heaven BETA TESTING!",
                        ["description"] = msg,
                        ["type"] = "rich",
                        ["color"] = tonumber(string.format("0x%X", math.random(0x000000, 0xFFFFFF))),
                    }
                }
            }
        else
            timeOut = 50 repeat task.wait(0.1) timeOut =- 1 until currentQuest ~= "NaN" or timeOut <= 0
            data = {
                ["embeds"] = {
                    {
                        ["title"] = "Auto TWOH",
                        ["color"] = tonumber(string.format("0x%X", math.random(0x000000, 0xFFFFFF))),
                        ["fields"] = {
                            {
                                ["name"] = "📜 Quest Information",
                                ["value"] = "```css\n[Current Quest] - ".. currentQuest .."\n[Quest Progress] - ".. LocalPlayer.PlayerStats.QuestProgress.Value .."\n```"
                            },
                            {
                                ["name"] = "Player Information",
                                ["value"] = "```css\n[Equipped Stand] - ".. LocalPlayer.PlayerStats.Stand.Value.. "\n[Main Account] - ".. getgenv().mainAccount .."\n[Alt Account] - ".. getgenv().altAccount .."\n```"
                            },
                            {
                                ["name"] = "🧑‍💻 Script Information",
                                ["value"] = "```css\n[Time Elapsed] - ".. game:GetService('HttpService'):JSONDecode(readfile("AutoTWOH_"..game.Players.LocalPlayer.Name..".txt"))["Time"]/3600 .. " Hours\n[Sent From] - ".. LocalPlayer.Name .."\n```"
                            }
                        },
                        ["footer"] = {
                            ["text"] = "Xenon Auto TWOH"
                        },
                        ["timestamp"] = "2023-09-01T03:56:00.000Z",
                        ["thumbnail"] = {
                            ["url"] = "https://images-ext-2.discordapp.net/external/YSinwJzJheufLlcA2EoghzUjLgoj0AOB8EDJ-CFMHvE/%3Fsize%3D4096/https/cdn.discordapp.com/icons/1068426300274004018/a_e0d5f0ef6d1aec5c416cd8d4461fc723.gif"
                        }
                    }
                },
            }
        end

        repeat task.wait() until data
        local newdata = game:GetService("HttpService"):JSONEncode(data)


        local headers = {
            ["Content-Type"] = "application/json"
        }
        local request = http_request or request or HttpPost or syn.request or http.request
        local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
        request(abcdef)
    end)
end

local function Notify(Error, Duration)
    if not Duration then
        Duration = 999
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Auto TWOH Debug",
        Text = Error,
        Duration = Duration
    })
end

local function debugLog(message, functionName)
    if getgenv().debugMode then
        SendWebhook(tostring(message) .. " came from ".. functionName, getgenv().debugWebhook)
        print("Debugging! ".. tostring(message) .. " came from ".. functionName)
        Notify(message, 5)
    end
end

local function createPartWithOnTouch(partName, CFrame, size, touch)
    if workspace:FindFirstChild(partName) then
        return
    end

    local part = Instance.new("Part")
    part.Parent = workspace
    part.CFrame = CFrame
    part.Name = partName
    part.Size = size
    part.CanCollide = false
    part.Anchored = true
    part.Touched:Connect(touch)
end

local function killNPC(npcName, npcDistance, dontDestroyOnKill, extraParameters)
    print("DEBUG CHECK 1", npcName, npcDistance, dontDestroyOnKill, extraParameters)

	local NPC = workspace.Living:WaitForChild(npcName,60)
    local tagService = game:GetService("CollectionService")
    local hasHamon, hasRage, beingTargeted, chargingHamon = true, true, true, false
    local healthLimit = 0.2
	local deadCheck
    local BlockBreaker
    local setStandMorphPosition
    local HamonCharge

    if not LocalPlayer.Character:FindFirstChild("Hamon") then
        hasHamon = false
    end 

    if not LocalPlayer.Character:FindFirstChild("Rage") then
        hasRage = false
    end
    
    if not NPC then
        print("I HAVE NO IDEA WHAT THE FUCK HAPPENED")
        return "NPCNotFound"
    end

    local function getNPC() --allows calling functions to get current npc targeted
        return NPC
    end

    local function checkCounters()
        local existingSound = NPC.HumanoidRootPart:FindFirstChildOfClass("Sound")
        if (existingSound and existingSound.SoundId == "rbxassetid://2659057948") or (NPC:FindFirstChild("Highlight")) then
            return true
            end
        return false
    end

    if extraParameters then --incase some function wants current npc attacking
        extraParameters(getNPC)
    end

    if PlayerStats.Stand.Value == "Aerosmith" then
        setStandMorphPosition = function()
            if not LocalPlayer.Character:FindFirstChild("SummonedStand").Value then
                LocalPlayer.Character.RemoteFunction:InvokeServer("ToggleStand", "Toggle")
                return
            end

            if tagService:HasTag(NPC, "Blocking") and not checkCounters() and not chargingHamon then
                LocalPlayer.Character.StandMorph.HumanoidRootPart.CFrame = NPC.HumanoidRootPart.CFrame + (NPC.HumanoidRootPart.Velocity / getgenv().resolveVelocity) --resolves movement
            else
                LocalPlayer.Character.StandMorph.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end

        BlockBreaker = function()
            local finalPosition = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector - Vector3.new(0, getgenv().aeroSmithDistance, 0)
            if tagService:HasTag(NPC, "Blocking") and not checkCounters() then
                finalPosition = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector - Vector3.new(0, 30, 0)
                LocalPlayer.Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.R})
                LocalPlayer.Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.E})
                LocalPlayer.Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.T})
            elseif not tagService:HasTag(NPC, "Blocking") and not checkCounters() then
                firetouchinterest(LocalPlayer.Character.StandMorph.Propellers, NPC.HumanoidRootPart, 1)
                firetouchinterest(LocalPlayer.Character.StandMorph.Propellers, NPC.HumanoidRootPart, 0)
            elseif NPC.HumanoidRootPart.Position.Y >= getgenv().panicAeroSmithHeightUp then
                finalPosition = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector - Vector3.new(0, (getgenv().aeroSmithDistance * getgenv().panicAeroMultiplier), 0)
            elseif NPC.HumanoidRootPart.Position.Y <= getgenv().panicAeroSmithHeightDown then
                finalPosition = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector - Vector3.new(0, (getgenv().aeroSmithDistance * getgenv().panicAeroMultiplier), 0)
            end

            LocalPlayer.Character.HumanoidRootPart.CFrame = finalPosition
        end

        HamonCharge = function()
            if hasHamon then
                if LocalPlayer.Character.Hamon.Value <= 0 then
                    chargingHamon = true
                    LocalPlayer.Character.StandMorph.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    LocalPlayer.Character.RemoteFunction:InvokeServer("AssignSkillKey", {["Type"] = "Spec",["Key"] = "Enum.KeyCode.L",["Skill"] = "Hamon Charge"}) --to prevent overloading
                    LocalPlayer.Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.L})
                elseif LocalPlayer.Character.Hamon.Value >= 80 then
                    chargingHamon = false
                end
            end
        end
    else
        setStandMorphPosition = function()
            if not LocalPlayer.Character:FindFirstChild("SummonedStand").Value then
                LocalPlayer.Character.RemoteFunction:InvokeServer("ToggleStand", "Toggle")
                return
            end
            local finalPosition = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector * -1.1
            
            if npcName ~= "Heaven Ascension Dio" then
                if NPC.HumanoidRootPart.Position.Y >= getgenv().panicAeroSmithHeightUp then
                    finalPosition = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector * -1.1 - Vector3.new(0, (getgenv().aeroSmithDistance * getgenv().panicAeroMultiplier), 0)
                elseif NPC.HumanoidRootPart.Position.Y <= getgenv().panicAeroSmithHeightDown then
                    finalPosition = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector * -1.1 - Vector3.new(0, (getgenv().aeroSmithDistance * getgenv().panicAeroMultiplier), 0)
                end
            else
                getgenv().delaySwitch = 120
                healthLimit = 0.1
            end

            LocalPlayer.Character.StandMorph.PrimaryPart.CFrame = finalPosition
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.StandMorph.PrimaryPart.CFrame + LocalPlayer.Character.StandMorph.PrimaryPart.CFrame.lookVector - Vector3.new(0, 30, 0)
        end

        BlockBreaker = function()
            if not LocalPlayer.Character:FindFirstChild("SummonedStand").Value then
                return
            end

            if tagService:HasTag(NPC, "Blocking") then --neat feature yba
                LocalPlayer.Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.R})
            elseif hasHamon then
                if LocalPlayer.Character.Hamon.Value >= 1 then
                    LocalPlayer.Character.RemoteFunction:InvokeServer("Attack", "m1")
                end
            else
                LocalPlayer.Character.RemoteFunction:InvokeServer("Attack", "m1")
            end
        end

        HamonCharge = function()
            if hasHamon then
                if LocalPlayer.Character.Hamon.Value <= 0 then
                    LocalPlayer.Character.RemoteFunction:InvokeServer("AssignSkillKey", {["Type"] = "Spec",["Key"] = "Enum.KeyCode.L",["Skill"] = "Hamon Charge"}) --to prevent overloading
                    LocalPlayer.Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.L})
                end
            end

            if hasRage then
                if LocalPlayer.Character.Rage.Value >= 80 then
                    LocalPlayer.Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.H})
                end
            end
        end
    end

    deadCheck = LocalPlayer.PlayerGui.HUD.Main.DropMoney.Money.ChildAdded:Connect(function(child)
        local number = tonumber(string.match(child.Name,"%d+"))
            if number and NPC then
                deadCheck:Disconnect()
                beingTargeted = false

                if not dontDestroyOnKill then
                NPC:Destroy()
            end
        end
    end)

    if not LocalPlayer.Character:FindFirstChild("FocusCam") and LocalPlayer.Character:FindFirstChild("SummonedStand").Value then
        local FocusCam = Instance.new("ObjectValue", LocalPlayer)
        FocusCam.Parent = LocalPlayer.Character
        FocusCam.Name = "FocusCam"
        FocusCam.Value = LocalPlayer.Character.StandMorph.PrimaryPart
    end

    task.delay(getgenv().delaySwitch, function()
        beingTargeted = false
        deadCheck:Disconnect()
    end)

    while beingTargeted do
        task.wait()

        if not workspace.Living:FindFirstChild(npcName) or getgenv().Abort or NPC:WaitForChild("Humanoid").Health <= healthLimit then
            deadCheck:Disconnect()
            beingTargeted = false
            return true
        end

        task.spawn(setStandMorphPosition)
        task.spawn(HamonCharge)
        task.spawn(BlockBreaker)
    end

	return true
end

local function crash(part)
    hookfunction(workspace.Raycast, function() -- noclip bypass
        return
    end)

    for _,v in pairs(getconnections(game.ReplicatedStorage.ClientFX.OnClientEvent)) do
        v:Disable()
    end

    local crashArguments = {
        [1] = "Bleed",
        [2] = {
            ["TotalDamage"] = 0.0001,
            ["Duration"] = 1
        }
    }
    
    if part == "1v1" then
        crashArguments[2]["Duration"] = 10000
        for _ = 2000, 1, -1 do
            LocalPlayer.Character.RemoteEvent:FireServer(unpack(crashArguments))
        end
    elseif part == "sbr" and getgenv().empEnabled then
        task.spawn(function()
            while getgenv().empEnabled do
                crashArguments[2]["Duration"] = getgenv().empDuration
                for _ = getgenv().empStrength, 1, -1 do
                    print("crash")
                    LocalPlayer.Character.RemoteEvent:FireServer(unpack(crashArguments))
                end
                task.wait(getgenv().empFrequency)
            end
        end)
    end
end

local function allocateSkills()
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Vitality X",["SkillTreeType"] = "Character"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Destructive Power V",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Time Stop Resistance",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Anger Issues III",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Constant Rage III",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Artillery",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Propeller Charge",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Sharpness IX",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Stocked Magazines",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Little Boy",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Vola Barrage",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Pilot",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Wingman",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Stand Range I",["SkillTreeType"] = "Stand"})
    LocalPlayer.Character.RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Jonathan",["Option"] = "Option1",["Dialogue"] = "Dialogue5"})

    if LocalPlayer.PlayerStats.Spec.Value == "Hamon (Jonathan Joestar)" then
        LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Hamon Punch",["SkillTreeType"] = "Spec"})
        LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Lung Capacity V", ["SkillTreeType"] = "Spec"})
        LocalPlayer.Character.RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Hamon Breathing V",["SkillTreeType"] = "Spec"})
    end
end

local function join1v1Server()
    local function attemptJoin1v1Server()
        local serverURL = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/5290908008/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in ipairs(serverURL.data) do
            for _, playerToken in ipairs(server.playerTokens) do
                debugLog("playerToken ".. tostring(playerToken), "join1v1Server()")
                debugLog("is equal to alt? ".. tostring(playerToken == getgenv().mainPlayerToken), "join1v1Server()")
                if playerToken == getgenv().mainPlayerToken and server.playing == 1 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(5290908008, server.id, game.Players.LocalPlayer)
                    task.wait(20)
                end
            end
        end
end

    while true do
        task.wait(getgenv().taskWaitDelay)
        attemptJoin1v1Server()
    end
end

local function start1v1Instance()
    while true do
        game:GetService("TeleportService"):Teleport(5290908008, game:GetService("Players").LocalPlayer)
        task.wait(5)
    end
end

local function blockPlayer(playerName)
    local function Press(UI)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(UI.AbsolutePosition.X + UI.AbsoluteSize.X / 2, UI.AbsolutePosition.Y + UI.AbsoluteSize.Y + 20, 0, true, game, 0)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(UI.AbsolutePosition.X + UI.AbsoluteSize.X / 2, UI.AbsolutePosition.Y + UI.AbsoluteSize.Y + 20, 0, false, game, 0)
    end
        
    game:GetService("StarterGui"):SetCore("PromptBlockPlayer", game.Players[playerName])
    Press(game:GetService("CoreGui").RobloxGui.PromptDialog.ContainerFrame.ConfirmButton)
end

local function entry1v1()
    if game.PlaceId == 5290908008 then

        task.delay(60, function()
             game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
        end)

        if LocalPlayer.Name == getgenv().altAccount then
            for _,player in pairs(game.Players:GetPlayers()) do
                if player.Name ~= getgenv().altAccount and player.Name ~= getgenv().mainAccount then
                    join1v1Server()
                end
            end

        repeat task.wait() until not workspace:FindFirstChild("Message")
            game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)

        elseif LocalPlayer.Name == getgenv().mainAccount then
            for _,player in pairs(game.Players:GetPlayers()) do
                if player.Name ~= getgenv().altAccount and player.Name ~= getgenv().mainAccount then
                    blockPlayer(player.Name)
                    start1v1Instance()
                end
            end
        end

        createPartWithOnTouch("WinPosition", CFrame.new(3486, 1439, 2887), Vector3.new(10, 5, 10), function(partHit)
            if not partHit.Parent then
                return
            end

            if workspace.Living:FindFirstChild(partHit.Parent.Name) and partHit.Parent.Name == getgenv().mainAccount then
                task.delay(getgenv().WinPositionDelay, function()
                    game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
                end)
            end
        end)
    end
end


--[[QUEST FINDING]]
local function getDioQuest()
    hasDioQuest = false
    currentQuest = "NaN"

    for _, quest in pairs(LocalPlayer.PlayerGui.HUD.Main.Frames:WaitForChild("Quest").Quests:GetChildren()) do
        if string.find(quest.Name, "Dio's DIARY") then
            hasDioQuest = true
            currentQuest = quest.Name
            debugLog(currentQuest, "gettingQuests")
            debugLog(hasDioQuest, "gettingQuests")
            break
        end
    end
end

--[[HOPPING TO ANOTHER SBR SERVER]]
    local function joinRandomSBR()
        game:GetService("TeleportService").TeleportInitFailed:Connect(function(player, result, reason, placeid)
            if placeid == 4643697430 then
                debugLog("Failed joining SBR, Reconnecting!", "joiningSBR")
                task.wait(10)
                LocalPlayer.PlayerGui["Metal Ball Run Servers"]:Destroy()
                joinRandomSBR()
            end
        end)

        game.Players.LocalPlayer.Character.RemoteEvent:FireServer("EndDialogue", {["NPC"] = "[COMPETITIVE] Metal Ball Run", ["Option"] = "Option1",["Dialogue"] = "Dialogue2"})

        --it might be better to use firesignal on one of the guis.
        if not LocalPlayer.PlayerGui:WaitForChild("Metal Ball Run Servers", 30) then
            joinRandomSBR()
        end
        
        local server = game.Players.LocalPlayer.PlayerGui:WaitForChild("Metal Ball Run Servers"):WaitForChild("Frame"):WaitForChild("ScrollingFrame"):GetChildren()[math.random(1,4)]
        local args = {
            [1] = "JoinMetalBallRun",
            [2] = {
                ["Competitive"] = getgenv().fuckCompetitive,
                ["Code"] = server.Text
            }
        }

        debugLog(server.Text, "joiningSBR")
        game:GetService("Players").LocalPlayer.Character.RemoteEvent:FireServer(unpack(args))

        task.wait(30)
        joinRandomSBR()
    end


--[[COMPASSES DIO BONE, AND READING DA DIARY]]
local function mainGame()
    if game.PlaceId ~= 2809202155 then
        return
    end

    getDioQuest()

    local function swapToStand(standName)
        debugLog(standName, "swapToStand")

        if LocalPlayer.PlayerStats.Stand.Value == standName then
            return true
        end

        for _, objectValue in pairs(PlayerStats:GetChildren()) do
            if objectValue.Value == standName and string.find(objectValue.Name, "Slot") and not string.find(objectValue.Name, "Style") then
                repeat task.wait()
                    LocalPlayer.Character.RemoteEvent:FireServer("SwapStand", objectValue.Name)
                    LocalPlayer.PlayerGui.HUD.Main.DropMoney.Money.Text = "100"
                until LocalPlayer.Character.Humanoid.Health <= 5
                
                repeat task.wait() until LocalPlayer.PlayerGui:WaitForChild("HUD").Main.DropMoney.Money.Text ~= "100"
                allocateSkills()
                return true
            end
        end

        return false
    end


    local function getTWOH()
        debugLog("Got the Dio's Bone!", "getBone")
        SendWebhook("@everyone Thanks for using AUTO-TWOH! Xenon V3 ON TOP!")

        repeat
            task.wait(1)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-215, 285, 321)
            LocalPlayer.Character:WaitForChild("RemoteFunction"):InvokeServer("ToggleStand", "Toggle")
        until LocalPlayer.PlayerStats.Stand.Value == "The World Over Heaven"

        local standSkin = LocalPlayer.Character:WaitForChild("StandMorph"):WaitForChild("StandSkin").Value
        if standSkin == "" then
            pcall(function()
                Data = game:GetService('HttpService'):JSONDecode(readfile("AutoTWOH_"..game.Players.LocalPlayer.Name..".txt"))
                Data["Attempts"] = Data["Attempts"] + 1
            end)

            SendWebhook("Sorry, you didn't get a skin, no worries! Let's try another!")
            if getgenv().swapNotSkinTWOH then
                swapToStand("The World")
                game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
            end
        elseif standSkin ~= "" then
            pcall(function()
                Data = game:GetService('HttpService'):JSONDecode(readfile("AutoTWOH_"..game.Players.LocalPlayer.Name..".txt"))
            end)

            SendWebhook(
                "**A wild TWOH appeared!**" ..
                "\nHours Took: `" .. Data["Time"]/3600 .. "`" ..
                "\nAttempts Made: `" .. Data["Attempts"] .. "`" ..
                "\nSkin: `" .. LocalPlayer.Character.StandMorph.StandSkin.Value .. "`" ..
                "\nAccount: `" .. LocalPlayer.Name .. "`"   
            )
            SendWebhook(
                "**A wild TWOH appeared!**" ..
                "\nHours Took: `" .. Data["Time"]/3600 .. "`" ..
                "\nAttempts Made: `" .. Data["Attempts"] .. "`" ..
                "\nSkin: `" .. LocalPlayer.Character.StandMorph.StandSkin.Value .. "`",
                "https://discord.com/api/webhooks/1142519127983009822/HdHJw3iwrwxwD3F2ldq7Qihm4WFYwFEhhQr-SmN6CkOr3Qcv7URxeXbP9tit4zjYHVRm"
            )
            Data["Time"] = 0
            Data["Attempts"] = 0
            writefile("AutoTWOH_"..LocalPlayer.Name..".txt", game:GetService('HttpService'):JSONEncode(Data))
            if getgenv().swapNotSkinTWOH then
                swapToStand("The World")
                game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
            end
        end
    end

    local function getBone()
        LocalPlayer.Character.RemoteEvent:FireServer("EndDialogue",{["NPC"] = "Path to Heaven",["Option"] = "Option1",["Dialogue"] = "Dialogue8"})
        LocalPlayer.Character.RemoteEvent:FireServer("EndDialogue",{["NPC"] = "Path to Heaven",["Option"] = "Option1",["Dialogue"] = "Dialogue6"})

        if string.find(currentQuest, "Dio's BONE") and not LocalPlayer.Backpack:FindFirstChild("Dio's Bone") and LocalPlayer.PlayerStats.Stand.Value == "The World" then
            debugLog("Getting Dio Bone!", "getBoneSummonTWOH")
            swapToStand("The World")

            local killed = killNPC("Heaven Ascension Dio", 30, false)
            
            if killed == "NPCNotFound" then
                print("WTF HAPPENED?")
                game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
            end

            if not LocalPlayer.Backpack:WaitForChild("Dio's Bone", 20) then
                getBone()
            else
                getTWOH()
            end
        end
    end

    local function boneHelper()
        workspace.Living.ChildAdded:Connect(function(character)
            if character.Name == LocalPlayer.Name and string.find(currentQuest, "Dio's BONE") then
                debugLog("Player died, will restart getting Dio Bone!", "getBoneSummonTWOH")
                task.wait(5)
                getBone()
            end
        end)
        
        hookfunction(workspace.Raycast, function() -- noclip bypass
            return
        end)

        createPartWithOnTouch("Serverhop", CFrame.new(8494, -479, 8161), Vector3.new(1000, 5, 1000), function(partHit)
            if not partHit.Parent then
                return
            end

            if workspace.Living:FindFirstChild(partHit.Parent.Name) and game.Players:FindFirstChild(partHit.Parent.Name) and partHit.Parent.Name ~= LocalPlayer.Name then
                debugLog("Someone was caught farming Dio OH! Serverhopping for a new one ", "getBone")
                game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
                task.wait(9999999)
            end
        end)
    end

    local function readDiary()
        debugLog("Reading the Diary", "ReadingDiary")
        local swappedSuccessfully = swapToStand("The World")
        local dioDiary = LocalPlayer.Backpack:WaitForChild("Dio's Diary", 5) or LocalPlayer.Backpack:WaitForChild("Redeemed Dio's Diary", 5)

        if not swappedSuccessfully then
            SendWebhook("You are currently missing a The World stand (or failed to equip one), maybe get one?")
            return
        end

        if not dioDiary then
            SendWebhook("You are currently missing a Dio's Diary or a Redeemed Dio's Diary, maybe get one?")
            return
        end

        repeat task.wait() LocalPlayer.Character.Humanoid:EquipTool(dioDiary) LocalPlayer.Character:FindFirstChild(dioDiary.Name):Activate() until LocalPlayer.PlayerGui:FindFirstChild("DialogueGui")
        if LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.DialogueFrame.Frame.Line001.Container.Group001.Text == "Wryyyy" then
            repeat
                pcall(function()
                    task.wait()
                    firesignal(LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
                    firesignal(LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options.Option1.TextButton.MouseButton1Click)
                end)
            until not LocalPlayer.PlayerGui:FindFirstChild("DialogueGui")
        else
            SendWebhook("This isn't in the debug logs for a reason, did not expect Wryyy (starting message) at opening of Dio's Diary")
        end

        LocalPlayer.Character.Humanoid:UnequipTools()
        getDioQuest()
        mainGame()
    end

    local function doDiaryQuests()
        debugLog("Doing the Diary quests", "DoingDiary")
        if not getgenv().useTheWorld and not string.find(currentQuest, "Dio's BONE") then
            swapToStand("Aerosmith")
        elseif string.find(currentQuest, "Dio's BONE") or getgenv().useTheWorld then
            swapToStand("The World")
        end

        allocateSkills()

        if currentQuest ~= "NaN" and Backpack:FindFirstChild("Dio's Bone") then
            SendWebhook("You have an extra Dio Bone, if this is your first time executing it, this will break the script")
            if not getgenv().disableDioBoneDelete then
                Backpack:FindFirstChild("Dio's Bone"):Destroy()
            end
        end

        if string.find(currentQuest, 25) then
            if getgenv().op1v1 then
                start1v1Instance()
            else
                game.ReplicatedStorage.SBMRemote:FireServer(false)
            end
        elseif string.find(currentQuest, 50) then
            joinRandomSBR()
        elseif string.find(currentQuest, "Dio's BONE") then
            boneHelper()
            getBone()
        end
    end

    if not hasDioQuest and not Backpack:FindFirstChild("Dio's Bone") then
        readDiary()
    elseif hasDioQuest then
        doDiaryQuests()
    end
end


--[[1v1 PART OF QUEST]]
local function auto1v1()
    if game.PlaceId ~= 5290908008 then
        return
    end

    if getgenv().op1v1 then
        entry1v1()
    else
        repeat task.wait() until LocalPlayer.PlayerGui:WaitForChild("HUD").Main.DropMoney.Money.Text ~= "100"
        getDioQuest()
        if not hasDioQuest then
            SendWebhook("@everyone Completed 1v1 quest! Returning to Main Game")
            game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
        end
    end

    if not getgenv().crash1v1 and getgenv().afkIn1v1 then
        repeat task.wait() until not LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen1")
        task.spawn(function()
            repeat task.wait()
                LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.WinnerTP.CFrame
            until LocalPlayer.Character:FindFirstChild("FocusCam")
        end)

        repeat task.wait() until not workspace:FindFirstChild("Message")
        task.wait(math.random(1, 3))
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(getgenv().setPhrases[math.random(1, #getgenv().setPhrases)], "All")
    end

    if getgenv().crash1v1 and not getgenv().afkIn1v1 then
        local Opponent =  game.Players:GetChildren()[2]

        crash("1v1")
        debugLog("Crashed player! killing them for that win", "auto1v1")
    end
end

--[[SBR PART OF QUEST]]
local function wipeSBR()
    if game.PlaceId ~= 4643697430 then
        return
    end

    local function shuffle(tbl)
        for i = #tbl, 2, -1 do
            local j = math.random(i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    
        return tbl
    end

    local function whiteList(partHit)
        if not partHit.Parent then
            return
        end

        if workspace.Living:FindFirstChild(partHit.Parent.Name) and partHit.Name == "HumanoidRootPart" and not partHit.Parent:FindFirstChild("Whitelisted") then
            print(partHit.Parent.Name, "was whitelisted")
            local news = Instance.new("StringValue")
            news.Name = "Whitelisted"
            news.Parent = partHit.Parent
        end
    end
    
    game:GetService("CollectionService").TagAdded:Connect(function(_tag)
        if _tag == "AntiHeal" then
            LocalPlayer.Character.RemoteEvent:FireServer("StopPoison")
            LocalPlayer.Character.RemoteEvent:FireServer("StopFire")
        end
    end)

    createPartWithOnTouch("Whitelist", CFrame.new(-2635, 499, -3894), Vector3.new(100, 5, 100), whiteList)
    if workspace:FindFirstChild("BarrierRoofKicks") then
        workspace.BarrierRoofKicks:Destroy()
    end
    hookfunction(workspace.Raycast, function() return end)

    repeat task.wait()
        LocalPlayer.Character.Humanoid.Sit = false
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2635, 499, -3894)
    until LocalPlayer.Character.HumanoidRootPart.CFrame == CFrame.new(-2635, 499, -3894)

    if not getgenv().ignoreDioQuest then
        getgenv().amountLeftToSwitch = 1

        workspace.Living.ChildRemoved:Connect(function()
            if #workspace.Living:GetChildren() <= getgenv().amountLeftToSwitch then
                joinRandomSBR()
            end

            getDioQuest()

            if not hasDioQuest then
                SendWebhook("Completed SBR quest! Returning to Main Game")
                game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
            end
        end)

        if #game.Players:GetPlayers() <= getgenv().serverHopLessThanAmount or #workspace.Living:GetChildren() <= getgenv().serverHopLessThanAmount then
            joinRandomSBR()
        end
    end

    repeat task.wait() until not workspace:FindFirstChild("Message")


    if getgenv().NeverPlayWithLeaderstatsPlayer then
        local data = LocalPlayer.Character.RemoteFunction:InvokeServer("ReturnPlayerRankings", "GlobalSBRRankings")

        for _,player in pairs(data) do
            if workspace.Living:FindFirstChild(player["Name"]) and player["Name"] ~= LocalPlayer.Name then
                joinRandomSBR()
            end
        end
    end


    crash("sbr")
    
    local shuffledPlayer = shuffle(game.Players:GetPlayers())
    
    if next(getgenv().killStand) then
        local success, response = pcall(function()
            table.sort(shuffledPlayer, function(playerA, playerB)
                local function playerHasElement(player, elementName)
                    local playerStats = game.Players[player.Name]:FindFirstChild("PlayerStats")
                    if playerStats == nil then
                        return false
                    end
                
                    local element = playerStats:FindFirstChild(elementName)
                    return element == nil
                end
                
                local playerAHasStats = playerHasElement(playerA, "Stand")
                local playerBHasStats = playerHasElement(playerB, "Stand")
                
                if not playerAHasStats and not playerBHasStats then
                    return false
                elseif not playerAHasStats then
                    return false
                elseif not playerBHasStats then
                    return true
                end
        
                if playerAHasStats and playerBHasStats then
                    local standA = game.Players[playerA.Name].PlayerStats.Stand.Value
                    local standB = game.Players[playerB.Name].PlayerStats.Stand.Value
                    
                    local function getStandPriority(stand)
                        for i, allowedStand in ipairs(getgenv().killStand) do
                            if stand == allowedStand then
                                return i
                            end
                        end
                        return #getgenv().killStand + 1
                    end
                    
                    local standPriorityA = getStandPriority(standA)
                    local standPriorityB = getStandPriority(standB)
                    
                    if standPriorityA > standPriorityB then
                        return true
                    elseif standPriorityA < standPriorityB then
                        return false
                    else
                        return playerA.Name < playerB.Name
                    end
                end
            end)
        end)

        if not success and response then
            debugLog("Error occured".. response, "stand sort wipesbr")
        end
    end

    for playersLeft = #shuffledPlayer, 1, -1 do
        debugLog(playersLeft, "sbrwipe")
        local player = shuffledPlayer[playersLeft]
        if not workspace.Living:FindFirstChild(player.Name) or table.find(getgenv().whiteListed, player.Name) then
            continue
        elseif playersLeft <= getgenv().amountLeftToSwitch then
            joinRandomSBR()
        elseif player.Name ~= LocalPlayer.Name and not player:FindFirstChild("Whitelist") then
            killNPC(player.Name, 25)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1100, 355, -216)
        end
    end

    if getgenv().ignoreDioQuest then
        local AutoSbrTimes = {
            ["SBR_Delay_1"] = 5;
            ["SBR_Delay_2"] = 5;
            ["SBR_Delay_3"] = 5;
            ["SBR_Delay_4"] = 5;
            ["SBR_Delay_5"] = 5;
            ["SBR_Delay_Hide"] = 5;
        }
        
        local SBRTeleports = {
            ["Hide in Stage 1-3"] = CFrame.new(-1124, 264, -152);
            ["Hide in Last Stage"] = CFrame.new(-1360, 390, 7912);
            ["Stage 1 Barrier"] = CFrame.new(-2085.69629, 330.770966, 2866.13306, -0.999443173, 4.35378738e-08, 0.033366207, 4.50038975e-08, 1, 4.31863825e-08, -0.033366207, 4.46639454e-08, -0.999443173);
            ["Stage 2 Barrier"] = CFrame.new(-1982.73682, 253.770493, 4058.58423, -0.94292599, 7.01420344e-09, -0.333002299, -2.01068318e-08, 1, 7.79978322e-08, 0.333002299, 8.02418043e-08, -0.94292599);
            ["Stage 3 Barrier"] = CFrame.new(-624.011658, 398.771515, 6679.8042, 0.994807601, -4.8680544e-09, -0.10177321, -7.54299556e-09, 1, -1.21563261e-07, 0.10177321, 1.21699742e-07, 0.994807601);
            ["Stage 4 Barrier"] = CFrame.new(-1764.24475, 425.771698, 8663.1377, 0.998665392, -9.6763884e-08, -0.0516476519, 9.91457227e-08, 1, 4.35549836e-08, 0.0516476519, -4.86174976e-08, 0.998665392);
            ["End Barrier"] = CFrame.new(-1814.3798828125, 571.7680053710938, 9025.5322265625);
        }

        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Hide in Stage 1-3"] -- Wait for SBR to start vvv
        repeat task.wait() until workspace:FindFirstChild("Barrier") == nil -- Wait until tp to stage 1 vvv

        task.wait(AutoSbrTimes["SBR_Delay_1"]) -- TP to Stage 1 Barrier vvv
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Stage 1 Barrier"] -- Wait until hide vvv
        task.wait(AutoSbrTimes["SBR_Delay_Hide"])
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Hide in Stage 1-3"] -- Wait for Stage 1 to open vvv
        repeat task.wait() until workspace.Barriers:FindFirstChild("1") == nil -- Wait until tp to stage 2 vvv

        task.wait(AutoSbrTimes["SBR_Delay_2"]) -- TP to Stage 2 Barrier vvv
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Stage 2 Barrier"] -- Wait until hide vvv
        task.wait(AutoSbrTimes["SBR_Delay_Hide"])
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Hide in Stage 1-3"] -- Wait for Stage 2 to open vvv
        repeat task.wait() until workspace.Barriers:FindFirstChild("2") == nil -- Wait until tp to stage 3 vvv

        task.wait(AutoSbrTimes["SBR_Delay_3"]) -- TP to Stage 3 Barrier vvv
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Stage 3 Barrier"] -- Wait until hide vvv
        task.wait(AutoSbrTimes["SBR_Delay_Hide"])
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Hide in Stage 1-3"]-- Wait for Stage 3 to open vvv
        repeat task.wait() until workspace.Barriers:FindFirstChild("3") == nil -- Wait until tp to stage 4 vvv

        task.wait(AutoSbrTimes["SBR_Delay_4"]) -- TP to Stage 4 Barrier vvv
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Stage 4 Barrier"] -- Wait until hide vvv
        task.wait(AutoSbrTimes["SBR_Delay_Hide"])
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["Hide in Last Stage"] -- Wait for Stage 4 (last) to open vvv
        repeat task.wait() until workspace.Barriers:FindFirstChild("4") == nil -- Wait until tp to end vvv

        task.wait(AutoSbrTimes["SBR_Delay_5"]) -- TP to end vvv
        LocalPlayer.Character.HumanoidRootPart.CFrame = SBRTeleports["End Barrier"]
        task.wait(2)
    end
    joinRandomSBR()
end


print("Test")
print(game.PlaceId ~= 5290796989)
print(LocalPlayer.Name == getgenv().mainAccount)

if game.PlaceId ~= 5290796989 and (LocalPlayer.Name == getgenv().mainAccount) then
    skipScreen()
    startBypasses()
    auto1v1()
    wipeSBR()

    repeat task.wait() until LocalPlayer.PlayerGui:WaitForChild("HUD").Main.DropMoney.Money.Text ~= "100"
    SendWebhook("", false, true)
    mainGame()
elseif game.PlaceId ~= 5290908008 and (LocalPlayer.Name == getgenv().altAccount and getgenv().op1v1) then
    join1v1Server()
elseif game.PlaceId == 5290908008 and (LocalPlayer.Name == getgenv().altAccount and getgenv().op1v1) then
    startBypasses()
    entry1v1()
end