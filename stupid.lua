--GENERAL CONFIG
getgenv().useTheWorld = true --Aerosmith is way better for SBR
getgenv().fpsBoost = false -- 1 words, white screen
getgenv().swapNotSkinTWOH = true --Automatically switches to another The World Stand if did not get a TWOH skin
getgenv().mainWebhook = "https://discordapp.com/api/webhooks/1236715673116213359/yw42MAexr-z-3tLgOs_gJUFhaZxUY_OcCW83KCTAt1mwLUeiY6TsuUMagjgaC01eta6E" 
getgenv().debugWebhook = "https://discord.com/api/webhooks/1055437869956743278/zbuH3ZmLNfVGABY5pw67F3H1RIapoR5q_lpauP8kx_00i3cSsfNJkf-2xGXowelX98Tn" --for debug webhook

--1v1 CONFIG
getgenv().crash1v1 = false --YOU HAVE TO DISABLE THIS IF YOU WANT TO AFK IN 1v1, this will crash the other player and kill them
getgenv().setPhrases = {"hello bro?", "why am i still in the spawn"}
getgenv().afkIn1v1 = false --Afking in 1v1 with set phases

--OP 1v1 CONFIG
getgenv().taskWaitDelay = 5 --please dont change this, (this is for checking serverlist)
getgenv().op1v1 = true --You need an alternate account for this
getgenv().mainAccount = "2niis"
getgenv().altAccount = "seggswithmomanddad"
getgenv().mainPlayerToken = "124FFD46939676B2E3A54153478A2EF2" 
getgenv().WinPositionDelay = 1 --waits for this many after winning to tp back

--SBR CONFIG
getgenv().NeverPlayWithLeaderstatsPlayer = true --if see leaderboard player, tp to another game
getgenv().fuckCompetitive = true --this will automatically use competitive to find sbr servers
getgenv().ignoreDioQuest = true --if you want corpse parts, use this so that it doesnt hop back to main game, and will automatically do sbr
getgenv().killStand = {""} -- kills these stands first, experimental and kinda buggy
getgenv().whiteListed = {} --aw, you dont want someone to die? use this
getgenv().serverHopLessThanAmount = 5 --will find another server at start if initial server contains x amount
getgenv().amountLeftToSwitch = 1 --lets say 5, it will join another sbr server at 5 players
--SBR AEROSMITH CONFIG, DONT MESS UNLESS YOU KNOW WHAT YOU ARE DOING!
getgenv().delaySwitch = 30 --switches to another player if it doesnt kill it in x seconds
getgenv().aeroSmithDistance = 500 -- studs below of the player
getgenv().panicAeroSmithHeightUp = 300 --when player is above some Y, panics and sets aerosmith lower
getgenv().panicAeroSmithHeightDown = 10 --when player is below some Y, panics and sets aerosmith higher

getgenv().panicAeroMultiplier = 5 -- aeroSmithDistance * panicAeroMultiplier = final distance
--SBR CRASHER CONFIG
getgenv().empEnabled = true -- crasher
getgenv().empStrength = 1000 --sbr EMP, higher means they freeze more often, but they might get the disconnected godmode.
getgenv().empDuration = 5 --sbr EMP, higher means it starts emp for longer
getgenv().empFrequency = 20 --sbr EMP, seconds it take to start EMP again
getgenv().resolveVelocity = 8 --3-8 recommended value, hard to explain

--MISC CONFIG
getgenv().debugMode = true -- Want to be a good boy and report all the bugs and not make others rage? turn this on and whenever you encounter a bug, record it and screenshot logs!
loadstring(game:HttpGet("https://raw.githubusercontent.com/Screenatyouruse/Il2CppInspector/master/asd.lua"))()
