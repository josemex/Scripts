local scriptname = "Rengar The Mighty"
local author = "Da Vinci"
local version = "1.0"
local champion = "Rengar"
if myHero.charName:lower() ~= champion:lower() then return end
local igniteslot = nil
local Ferocity = false
local Invisible = false
local Passive = { Damage = function(target) return getDmg("P", target, myHero) end }
local AA = { Range = function(target) 
local int1 = 0 if ValidTarget(target) then int1 = GetDistance(target.minBBox, target)/2 end
return myHero.range + GetDistance(myHero, myHero.minBBox) + int1 end , Damage = function(target) return getDmg("AD", target, myHero) end }
local Q = { Range = 125, Width = nil, Delay = 0.5, Speed = math.huge, LastCastTime = 0, Collision = false, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Mana = function() return myHero:GetSpellData(_Q).mana end, Damage = function(target) return getDmg("Q", target, myHero) end}
local W = { Range = 390, Width = 55, Delay = 0.5, Speed = math.huge, LastCastTime = 0, Collision = false, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Mana = function() return myHero:GetSpellData(_W).mana end, Damage = function(target) return getDmg("W", target, myHero) end}
local E = { Range = 950, Width = 50, Delay = 0.3, Speed = 1500, LastCastTime = 0, Collision = true, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Mana = function() return myHero:GetSpellData(_E).mana end, Damage = function(target) return getDmg("E", target, myHero) end}
local Ignite = { Range = 600, IsReady = function() return (igniteslot ~= nil and myHero:CanUseSpell(igniteslot) == READY) end, Damage = function(target) return getDmg("IGNITE", target, myHero) end}
local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "LeBlanc",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne"},
}
local CastableItems = {
Tiamat      = { Range = 400, Slot = function() return GetInventorySlotItem(3077) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3077) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) end, Damage = function(target) return getDmg("TIAMAT", target, myHero) end},
Hydra       = { Range = 400, Slot = function() return GetInventorySlotItem(3074) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3074) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) end, Damage = function(target) return getDmg("HYDRA", target, myHero) end},
Bork        = { Range = 450, Slot = function() return GetInventorySlotItem(3153) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end, Damage = function(target) return getDmg("RUINEDKING", target, myHero) end},
Bwc         = { Range = 400, Slot = function() return GetInventorySlotItem(3144) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end, Damage = function(target) return getDmg("BWC", target, myHero) end},
Hextech     = { Range = 400, Slot = function() return GetInventorySlotItem(3146) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3146) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY) end, Damage = function(target) return getDmg("HXG", target, myHero) end},
Blackfire   = { Range = 750, Slot = function() return GetInventorySlotItem(3188) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3188) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3188)) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", target, myHero) end},
Youmuu      = { Range = 350, Slot = function() return GetInventorySlotItem(3142) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
Randuin     = { Range = 500, Slot = function() return GetInventorySlotItem(3143) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
TwinShadows = { Range = 1000, Slot = function() return GetInventorySlotItem(3023) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3023) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3023)) == READY) end, Damage = function(target) return 0 end},
}

local scriptLoaded = false

local visionRange = 1800

local Colors = { 
    -- O R G B
    Green =  ARGB(255, 0, 255, 0), 
    Yellow =  ARGB(255, 255, 255, 0),
    Red =  ARGB(255,255,0,0),
    White =  ARGB(255, 255, 255, 255),
    Blue =  ARGB(255,0,0,255),
}

require "VPrediction"
if VIP_USER then require "Prodiction" end

function PrintMessage(script, message) 
    print("<font color=\"#6699ff\"><b>" .. script .. ":</b></font> <font color=\"#FFFFFF\">" .. message .. "</font>") 
end


function OnLoad()
    
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then igniteslot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then igniteslot = SUMMONER_2
    end
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000 ,DAMAGE_PHYSICAL)
    DelayAction(arrangePrioritys,5)
    VP = VPrediction()
    prediction = Prediction()
    iOrb = iOrbwalker()
    damage = Damage()
    Config = scriptConfig(scriptname.." by "..author, scriptname.."version1")
    EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    JungleMinions = minionManager(MINION_JUNGLE, 900, myHero, MINION_SORT_MAXHEALTH_DEC)
    DelayAction(OrbLoad, 1)
    LoadMenu()
end

function LoadMenu()

    
    Config:addTS(ts)

    Config:addSubMenu(scriptname.." - Combo Settings", "Combo")
        Config.Combo:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)

        Config.Combo:addSubMenu("Empowerment Settings", "R")
            Config.Combo.R:addParam("useQ", "Use Empowered Q", SCRIPT_PARAM_ONOFF, true)
            Config.Combo.R:addParam("useW", "Use Empowered W", SCRIPT_PARAM_ONOFF, true)
            Config.Combo.R:addParam("useWhp", "W - Min. % HP to Cast", SCRIPT_PARAM_SLICE, 65, 0, 100, 0)
            Config.Combo.R:addParam("useE", "Use E", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte('Z'))

    Config:addSubMenu(scriptname.." - Harass Settings", "Harass")
        Config.Harass:addParam("useQ","Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.Harass:addParam("useW","Use W", SCRIPT_PARAM_ONOFF, true)
        Config.Harass:addParam("useE","Use E", SCRIPT_PARAM_ONOFF, true)


    Config:addSubMenu(scriptname.." - LaneClear Settings", "LaneClear")
        Config.LaneClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.LaneClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Config.LaneClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(scriptname.." - JungleClear Settings", "JungleClear")
        Config.JungleClear:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, false)
        Config.JungleClear:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
        Config.JungleClear:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu(scriptname.." - KillSteal Settings", "KillSteal")
        Config.KillSteal:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu(scriptname.." - Misc Settings", "Misc")
        if VIP_USER then Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, { "vPrediction", "Prodiction"})
        else Config.Misc:addParam("predictionType",  "Type of prediction", SCRIPT_PARAM_LIST, 1, { "vPrediction"}) end
        Config.Misc:addParam("overkill","Overkill % for Dmg Predict..", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
        Config.Misc:addParam("bufferAA", "Delay for AA", SCRIPT_PARAM_SLICE, 2, -15, 20)

    Config:addSubMenu(scriptname.." - Drawing Settings", "Draw")
        draw = Draw()
        draw:LoadMenu(Config.Draw)

    Config:addSubMenu(scriptname.." - Key Settings", "Keys")
        Config.Keys:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.Keys:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("C"))
        Config.Keys:addParam("Clear", "LaneClear or JungleClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))  
        Config.Keys:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X")) 
        Config.Keys:addParam("Flee", "Flee", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("T"))

        Config.Keys.Combo = false
        Config.Keys.Harass = false
        Config.Keys.Flee = false
        Config.Keys.Clear = false
        Config.Keys.LastHit = false

    PrintMessage(scriptname, "Script by "..author..".")
    PrintMessage(scriptname, "Have Fun!.")
    scriptLoaded = true
end

function Checks()

end


function OnTick()
    if myHero.dead or not scriptLoaded then return end
    ts.target = GetCustomTarget()
    local targetObj = GetTarget()
    if targetObj ~= nil then
        if targetObj.type:lower():find("hero") and targetObj.team ~= myHero.team and GetDistance(myHero, targetObj) < ts.range then
            ts.target = targetObj
        end
    end
    --KillSteal
        KillSteal()
    --run
    if Config.Keys.Flee then Flee() end
    
    if not iOrb:CanCast() or iOrb:RequiresAA() then return end

    if Config.Keys.Combo then Combo() end
		if Config.Combo.R.useE then CastE() end
    --qharass
    if Config.Keys.Harass then Harass() end
		
		if Config.Keys.Clear then Clear() end
		Magnet()
end

function KillSteal()
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and enemy.visible and enemy.health/enemy.maxHealth < 0.5 and GetDistance(myHero, enemy) < ts.range  then
            if Config.KillSteal.useQ and Q.Damage(enemy) > enemy.health and not enemy.dead then CastQ(enemy) end
            if Config.KillSteal.useW and W.Damage(enemy) > enemy.health and not enemy.dead then CastW(enemy) end
            if Config.KillSteal.useE and E.Damage(enemy) > enemy.health and not enemy.dead then CastE(enemy) end
            if Config.KillSteal.useIgnite and Ignite.IsReady() and Ignite.Damage(enemy) > enemy.health and not enemy.dead  and GetDistance(myHero, enemy) < Ignite.Range then CastSpell(igniteslot, enemy) end
        end
    end
end

function Flee()
    myHero:MoveTo(mousePos.x, mousePos.z)
    CastE(target)
end


function Combo()
    local target = ts.target
    if not ValidTarget(target) then return end
    if not Ferocity then
        if Config.Combo.useQ then CastQ(target) end
        if Config.Combo.useW then CastW(target) end
        if Config.Combo.useE and not Invisible then CastE(target) end
    end
		if Ferocity then
        if Config.Combo.R.useQ then CastQ(target) end
        if Config.Combo.R.useW then CastWR(target) end
        if Config.Combo.R.useE then CastE(target) end  	
    end
end

function Harass()
    local target = ts.target
    if not ValidTarget(target) then return end
    if not Ferocity then
        if Config.Harass.useE and not Invisible then CastE(target) end
    end
end

--CastX
function CastQ(target)
    if Q.IsReady() and ValidTarget(target, Q.Range) then 
        CastSpell(_Q)
				--myHero:Attack(target)
				--SOWi:resetAA()
    end
end

function CastW(target)
    if W.IsReady() and ValidTarget(target, W.Range) then
        CastSpell(_W)
    end
end

function CastWR()
    if (myHero.health / myHero.maxHealth) * 100 <= Config.Combo.R.useWhp then
        CastSpell(_W)
    end
end

function CastE(target)
    if E.IsReady() and ValidTarget(target, E.Range) then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, E.Delay, E.Width, E.Range, E.Speed, myHero)
        if HitChance >= 2 then
            CastSpell(_E,CastPosition.x, CastPosition.z)
        end    
    end
end



function Magnet()
    if target ~= nil and (Combo or Harass) and ValidTarget(target, AA.Range(target)) then
		local dist = GetDistance(target)
		if dist < AA.Range(target) and dist > 50 then 
			StayClose(target, true)
		elseif dist <= 50 then
			StayClose(target, false)
		end
    end
end

function StayClose(target, mode)
	if mode then
		local myVector = Vector(myHero.x, myHero.y, myHero.z)
		local targetVector = Vector(unit.x, unit.y, unit.z)
		local ClosePoint1 = targetVector + (myVector - targetVector):normalized()*100
		local ClosePoint2 = targetVector - (myVector - targetVector):normalized()*100
		if GetDistance(ClosePoint1) < GetDistance(ClosePoint2) then
			--SOWi:OrbWalk(target, ClosePoint1)
		else
			--SOWi:OrbWalk(target, ClosePoint2)
		end
	else
		--SOWi:OrbWalk(target, myHero)
	end
end

function Clear()
    EnemyMinions:update()
    JungleMinions:update()
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, 1000) then
            if not Ferocity then 
                if Config.LaneClear.useE and E.IsReady() then
									CastE(minion)
                end

                if Config.LaneClear.useQ and Q.IsReady() then
                    CastQ(minion)
                end

                if Config.LaneClear.useW and W.IsReady() then
                    CastW(minion)
                end
            else
                if Config.Combo.R.useE and E.IsReady() then
									CastE(minion)
                end

                if Config.Combo.R.useQ and Q.IsReady() then
                    CastQ(minion)
                end

                if Config.Combo.R.useW and W.IsReady() then
                    CastWR(minion)
                end
            end     
        end
    end

    for i, minion in pairs(JungleMinions.objects) do
        if ValidTarget(minion, 1000) then
            if not Ferocity then
                if Config.JungleClear.useE and E.IsReady() then
									CastE(minion)
                end

                if Config.JungleClear.useQ and Q.IsReady() then
                 CastQ(minion)
                end

                if Config.JungleClear.useW and W.IsReady() then
                CastW(minion)
                end
            else
                if Config.Combo.R.useE and E.IsReady() then
									CastE(minion)
                end

                if Config.Combo.R.useQ and Q.IsReady() then
                    CastQ(minion)
                end

                if Config.Combo.R.useW and W.IsReady() then
                    CastWR(minion)
                end
            end    
        end
    end
end




function OnProcessSpell(unit, spell)
    if myHero.dead or unit == nil or not scriptLoaded then return end
    if not unit.isMe then
    end
end

function RecvPacket(p)
    -- body
end

function OnCreateObj(object)
  if object.name:find("Rengar_Base_P_Buf_Max.troy") then
      Ferocity = true
  end
  if object.name:find("Rengar_Base_R_Cas.troy") then
      Invisible = true
  end
end

function OnDeleteObj(object)
  if object.name:find("Rengar_Base_P_Buf_Max.troy") then
    Ferocity = false
  end
  if object.name:find("Rengar_Base_R_Buf.troy") then
      Invisible = false
  end
end


function UseItems(unit)
    if unit ~= nil then
        for _, item in pairs(CastableItems) do
            if item.IsReady() and GetDistance(myHero, unit) < item.Range then
                if item.reqTarget then
                    CastSpell(item.Slot(), unit)
                else
                    CastSpell(item.Slot())
                end
            end
        end
    end
end

function GetCustomTarget()
    ts:update()
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return ts.target
end

function OrbLoad()
    if _G.Reborn_Initialised then
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Combo", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Harass", AutoCarry.MODE_MIXEDMODE)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Clear", AutoCarry.MODE_LANECLEAR)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "LastHit", AutoCarry.MODE_LASTHIT)
        _G.AutoCarry.MyHero:AttacksEnabled(true)
        PrintMessage(scriptname, "To have a better experience turn off SAC:R")
    elseif _G.Reborn_Loaded then
        DelayAction(OrbLoad, 1)
    else
        Config:addSubMenu(scriptname.." - Orbwalking Settings", "Orbwalking")
        iOrb:LoadMenu(Config.Orbwalking)
    end
end

--[[
function OrbLoad()
    if _G.Reborn_Initialised then
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Combo", AutoCarry.MODE_AUTOCARRY)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Harass", AutoCarry.MODE_MIXEDMODE)
        _G.AutoCarry.Keys:RegisterMenuKey(Config.Keys, "Clear", AutoCarry.MODE_LANECLEAR)
        _G.AutoCarry.MyHero:AttacksEnabled(true)
    elseif _G.Reborn_Loaded then
        DelayAction(OrbLoad, 1)
    elseif FileExist(LIB_PATH .. "SOW.lua") then
        require 'SOW'
        SOWi = SOW(VP)
        Config:addSubMenu(scriptname.." - Orbwalking", "Orbwalking")
        SOWi:LoadToMenu(Config.Orbwalking)
    else
        print("You will need an orbwalker")
    end
end
]]

function CountEnemiesNear(source, range)
    local Count = 0
    for idx, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) then
            if GetDistance(enemy, source) <= range then
                Count = Count + 1
            end
        end
    end
    return Count
end
 



function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end
    end
end
function arrangePrioritys()
     local priorityOrder = {
                [1] = {1,1,1,1,1},
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,2,3},
        [4] = {1,1,2,3,4},
        [5] = {1,2,3,4,5},
    }
    local enemies = #GetEnemyHeroes()
    for i, enemy in ipairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.p1, enemy, priorityOrder[enemies][1])
        SetPriority(priorityTable.p2, enemy, priorityOrder[enemies][2])
        SetPriority(priorityTable.p3,  enemy, priorityOrder[enemies][3])
        SetPriority(priorityTable.p4,  enemy, priorityOrder[enemies][4])
        SetPriority(priorityTable.p5,  enemy, priorityOrder[enemies][5])
    end
end
--CREDIT TO EXTRAGOZ
local spellsFile = LIB_PATH.."missedspells.txt"
local spellslist = {}
local textlist = ""
local spellexists = false
local spelltype = "Unknown"
 
function writeConfigsspells()
        local file = io.open(spellsFile, "w")
        if file then
                textlist = "return {"
                for i=1,#spellslist do
                        textlist = textlist.."'"..spellslist[i].."', "
                end
                textlist = textlist.."}"
                if spellslist[1] ~=nil then
                        file:write(textlist)
                        file:close()
                end
        end
end
if FileExist(spellsFile) then spellslist = dofile(spellsFile) end
 
local Others = {"Recall","recall","OdinCaptureChannel","LanternWAlly","varusemissiledummy","khazixqevo","khazixwevo","khazixeevo","khazixrevo","braumedummyvoezreal","braumedummyvonami","braumedummyvocaitlyn","braumedummyvoriven","braumedummyvodraven","braumedummyvoashe","azirdummyspell"}
local Items = {"RegenerationPotion","FlaskOfCrystalWater","ItemCrystalFlask","ItemMiniRegenPotion","PotionOfBrilliance","PotionOfElusiveness","PotionOfGiantStrength","OracleElixirSight","OracleExtractSight","VisionWard","SightWard","sightward","ItemGhostWard","ItemMiniWard","ElixirOfRage","ElixirOfIllumination","wrigglelantern","DeathfireGrasp","HextechGunblade","shurelyascrest","IronStylus","ZhonyasHourglass","YoumusBlade","randuinsomen","RanduinsOmen","Mourning","OdinEntropicClaymore","BilgewaterCutlass","QuicksilverSash","HextechSweeper","ItemGlacialSpike","ItemMercurial","ItemWraithCollar","ItemSoTD","ItemMorellosBane","ItemPromote","ItemTiamatCleave","Muramana","ItemSeraphsEmbrace","ItemSwordOfFeastAndFamine","ItemFaithShaker","OdynsVeil","ItemHorn","ItemPoroSnack","ItemBlackfireTorch","HealthBomb","ItemDervishBlade","TrinketTotemLvl1","TrinketTotemLvl2","TrinketTotemLvl3","TrinketTotemLvl3B","TrinketSweeperLvl1","TrinketSweeperLvl2","TrinketSweeperLvl3","TrinketOrbLvl1","TrinketOrbLvl2","TrinketOrbLvl3","OdinTrinketRevive","RelicMinorSpotter","RelicSpotter","RelicGreaterLantern","RelicLantern","RelicSmallLantern","ItemFeralFlare","trinketorblvl2","trinketsweeperlvl2","trinkettotemlvl2","SpiritLantern","RelicGreaterSpotter"}
local MSpells = {"JayceStaticField","JayceToTheSkies","JayceThunderingBlow","Takedown","Pounce","Swipe","EliseSpiderQCast","EliseSpiderW","EliseSpiderEInitial","elisespidere","elisespideredescent","gnarbigq","gnarbigw","gnarbige","GnarBigQMissile"}
local PSpells = {"CaitlynHeadshotMissile","RumbleOverheatAttack","JarvanIVMartialCadenceAttack","ShenKiAttack","MasterYiDoubleStrike","sonaqattackupgrade","sonawattackupgrade","sonaeattackupgrade","NocturneUmbraBladesAttack","NautilusRavageStrikeAttack","ZiggsPassiveAttack","QuinnWEnhanced","LucianPassiveAttack","SkarnerPassiveAttack","KarthusDeathDefiedBuff","AzirTowerClick","azirtowerclick","azirtowerclickchannel"}
 
local QSpells = {"TrundleQ","LeonaShieldOfDaybreakAttack","XenZhaoThrust","NautilusAnchorDragMissile","RocketGrabMissile","VayneTumbleAttack","VayneTumbleUltAttack","NidaleeTakedownAttack","ShyvanaDoubleAttackHit","ShyvanaDoubleAttackHitDragon","frostarrow","FrostArrow","MonkeyKingQAttack","MaokaiTrunkLineMissile","FlashFrostSpell","xeratharcanopulsedamage","xeratharcanopulsedamageextended","xeratharcanopulsedarkiron","xeratharcanopulsediextended","SpiralBladeMissile","EzrealMysticShotMissile","EzrealMysticShotPulseMissile","jayceshockblast","BrandBlazeMissile","UdyrTigerAttack","TalonNoxianDiplomacyAttack","LuluQMissile","GarenSlash2","VolibearQAttack","dravenspinningattack","karmaheavenlywavec","ZiggsQSpell","UrgotHeatseekingHomeMissile","UrgotHeatseekingLineMissile","JavelinToss","RivenTriCleave","namiqmissile","NasusQAttack","BlindMonkQOne","ThreshQInternal","threshqinternal","QuinnQMissile","LissandraQMissile","EliseHumanQ","GarenQAttack","JinxQAttack","JinxQAttack2","yasuoq","xeratharcanopulse2","VelkozQMissile","KogMawQMis","BraumQMissile","KarthusLayWasteA1","KarthusLayWasteA2","KarthusLayWasteA3","karthuslaywastea3","karthuslaywastea2","karthuslaywastedeada1","MaokaiSapling2Boom","gnarqmissile","GnarBigQMissile","viktorqbuff"}
local WSpells = {"KogMawBioArcaneBarrageAttack","SivirWAttack","TwitchVenomCaskMissile","gravessmokegrenadeboom","mordekaisercreepingdeath","DrainChannel","jaycehypercharge","redcardpreattack","goldcardpreattack","bluecardpreattack","RenektonExecute","RenektonSuperExecute","EzrealEssenceFluxMissile","DariusNoxianTacticsONHAttack","UdyrTurtleAttack","talonrakemissileone","LuluWTwo","ObduracyAttack","KennenMegaProc","NautilusWideswingAttack","NautilusBackswingAttack","XerathLocusOfPower","yoricksummondecayed","Bushwhack","karmaspiritbondc","SejuaniBasicAttackW","AatroxWONHAttackLife","AatroxWONHAttackPower","JinxWMissile","GragasWAttack","braumwdummyspell","syndrawcast","SorakaWParticleMissile"}
local ESpells = {"KogMawVoidOozeMissile","ToxicShotAttack","LeonaZenithBladeMissile","PowerFistAttack","VayneCondemnMissile","ShyvanaFireballMissile","maokaisapling2boom","VarusEMissile","CaitlynEntrapmentMissile","jayceaccelerationgate","syndrae5","JudicatorRighteousFuryAttack","UdyrBearAttack","RumbleGrenadeMissile","Slash","hecarimrampattack","ziggse2","UrgotPlasmaGrenadeBoom","SkarnerFractureMissile","YorickSummonRavenous","BlindMonkEOne","EliseHumanE","PrimalSurge","Swipe","ViEAttack","LissandraEMissile","yasuodummyspell","XerathMageSpearMissile","RengarEFinal","RengarEFinalMAX","KarthusDefileSoundDummy2"}
local RSpells = {"Pantheon_GrandSkyfall_Fall","LuxMaliceCannonMis","infiniteduresschannel","JarvanIVCataclysmAttack","jarvanivcataclysmattack","VayneUltAttack","RumbleCarpetBombDummy","ShyvanaTransformLeap","jaycepassiverangedattack", "jaycepassivemeleeattack","jaycestancegth","MissileBarrageMissile","SprayandPrayAttack","jaxrelentlessattack","syndrarcasttime","InfernalGuardian","UdyrPhoenixAttack","FioraDanceStrike","xeratharcanebarragedi","NamiRMissile","HallucinateFull","QuinnRFinale","lissandrarenemy","SejuaniGlacialPrisonCast","yasuordummyspell","xerathlocuspulse","tempyasuormissile","PantheonRFall"}
 
local casttype2 = {"blindmonkqtwo","blindmonkwtwo","blindmonketwo","infernalguardianguide","KennenMegaProc","sonawattackupgrade","redcardpreattack","fizzjumptwo","fizzjumpbuffer","gragasbarrelrolltoggle","LeblancSlideM","luxlightstriketoggle","UrgotHeatseekingHomeMissile","xeratharcanopulseextended","xeratharcanopulsedamageextended","XenZhaoThrust3","ziggswtoggle","khazixwlong","khazixelong","renektondice","SejuaniNorthernWinds","shyvanafireballdragon2","shyvanaimmolatedragon","ShyvanaDoubleAttackHitDragon","talonshadowassaulttoggle","viktorchaosstormguide","zedw2","ZedR2","khazixqlong","AatroxWONHAttackLife","viktorqbuff"}
local casttype3 = {"sonaeattackupgrade","bluecardpreattack","LeblancSoulShackleM","UdyrPhoenixStance","RenektonSuperExecute"}
local casttype4 = {"FrostShot","PowerFist","DariusNoxianTacticsONH","EliseR","JaxEmpowerTwo","JaxRelentlessAssault","JayceStanceHtG","jaycestancegth","jaycehypercharge","JudicatorRighteousFury","kennenlrcancel","KogMawBioArcaneBarrage","LissandraE","MordekaiserMaceOfSpades","mordekaisercotgguide","NasusQ","Takedown","NocturneParanoia","QuinnR","RengarQ","HallucinateFull","DeathsCaressFull","SivirW","ThreshQInternal","threshqinternal","PickACard","goldcardlock","redcardlock","bluecardlock","FullAutomatic","VayneTumble","MonkeyKingDoubleAttack","YorickSpectral","ViE","VorpalSpikes","FizzSeastonePassive","GarenSlash3","HecarimRamp","leblancslidereturn","leblancslidereturnm","Obduracy","UdyrTigerStance","UdyrTurtleStance","UdyrBearStance","UrgotHeatseekingMissile","XenZhaoComboTarget","dravenspinning","dravenrdoublecast","FioraDance","LeonaShieldOfDaybreak","MaokaiDrain3","NautilusPiercingGaze","RenektonPreExecute","RivenFengShuiEngine","ShyvanaDoubleAttack","shyvanadoubleattackdragon","SyndraW","TalonNoxianDiplomacy","TalonCutthroat","talonrakemissileone","TrundleTrollSmash","VolibearQ","AatroxW","aatroxw2","AatroxWONHAttackLife","JinxQ","GarenQ","yasuoq","XerathArcanopulseChargeUp","XerathLocusOfPower2","xerathlocuspulse","velkozqsplitactivate","NetherBlade","GragasQToggle","GragasW","SionW","sionpassivespeed"}
local casttype5 = {"VarusQ","ZacE","ViQ","SionQ"}
local casttype6 = {"VelkozQMissile","KogMawQMis","RengarEFinal","RengarEFinalMAX","BraumQMissile","KarthusDefileSoundDummy2","gnarqmissile","GnarBigQMissile","SorakaWParticleMissile"}
--,"PoppyDevastatingBlow"--,"Deceive" -- ,"EliseRSpider"
function getSpellType(unit, spellName)
        spelltype = "Unknown"
        casttype = 1
        if unit ~= nil and unit.type == "AIHeroClient" then
                if spellName == nil or unit:GetSpellData(_Q).name == nil or unit:GetSpellData(_W).name == nil or unit:GetSpellData(_E).name == nil or unit:GetSpellData(_R).name == nil then
                        return "Error name nil", casttype
                end
                if spellName:find("SionBasicAttackPassive") or spellName:find("zyrapassive") then
                        spelltype = "P"
                elseif (spellName:find("BasicAttack") and spellName ~= "SejuaniBasicAttackW") or spellName:find("basicattack") or spellName:find("JayceRangedAttack") or spellName == "SonaQAttack" or spellName == "SonaWAttack" or spellName == "SonaEAttack" or spellName == "ObduracyAttack" or spellName == "GnarBigAttackTower" then
                        spelltype = "BAttack"
                elseif spellName:find("CritAttack") or spellName:find("critattack") then
                        spelltype = "CAttack"
                elseif unit:GetSpellData(_Q).name:find(spellName) then
                        spelltype = "Q"
                elseif unit:GetSpellData(_W).name:find(spellName) then
                        spelltype = "W"
                elseif unit:GetSpellData(_E).name:find(spellName) then
                        spelltype = "E"
                elseif spellName:find("Summoner") or spellName:find("summoner") or spellName == "teleportcancel" then
                        spelltype = "Summoner"
                else
                        if spelltype == "Unknown" then
                                for i=1,#Others do
                                        if spellName:find(Others[i]) then
                                                spelltype = "Other"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#Items do
                                        if spellName:find(Items[i]) then
                                                spelltype = "Item"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#PSpells do
                                        if spellName:find(PSpells[i]) then
                                                spelltype = "P"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#QSpells do
                                        if spellName:find(QSpells[i]) then
                                                spelltype = "Q"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#WSpells do
                                        if spellName:find(WSpells[i]) then
                                                spelltype = "W"
                                        end
                                end
                        end
                        if spelltype == "Unknown" then
                                for i=1,#ESpells do
                                        if spellName:find(ESpells[i]) then
                                                spelltype = "E"
                                        end
                                end
                        end
                end
                for i=1,#MSpells do
                        if spellName == MSpells[i] then
                                spelltype = spelltype.."M"
                        end
                end
                local spellexists = spelltype ~= "Unknown"
                if #spellslist > 0 and not spellexists then
                        for i=1,#spellslist do
                                if spellName == spellslist[i] then
                                        spellexists = true
                                end
                        end
                end
                if not spellexists then
                        table.insert(spellslist, spellName)
                        --writeConfigsspells()
                       -- PrintChat("Skill Detector - Unknown spell: "..spellName)
                end
        end
        for i=1,#casttype2 do
                if spellName == casttype2[i] then casttype = 2 end
        end
        for i=1,#casttype3 do
                if spellName == casttype3[i] then casttype = 3 end
        end
        for i=1,#casttype4 do
                if spellName == casttype4[i] then casttype = 4 end
        end
        for i=1,#casttype5 do
                if spellName == casttype5[i] then casttype = 5 end
        end
        for i=1,#casttype6 do
                if spellName == casttype6[i] then casttype = 6 end
        end
 
        return spelltype, casttype
end


class "iOrbwalker"
function iOrbwalker:__init()
    self.isAttacking = false
    self.bufferAA = false 
    self.nextAA = 0
    self.baseWindUpTime = 3
    self.baseAnimationTime = 0.665
    self.windUpTime = 3
    self.animationTime = 0.665
    self.predHealthLimit = -20
    self.delay = 0.07
    self.lastWait = 0
    self.dataUpdated = false
    self.Menu = nil
    self.target = nil
    self.reset = false
    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
end

function iOrbwalker:RequiresAA()
    if self.reset and ValidTarget(target, AA.Range(target)) then return true
    elseif self.reset then self.reset = false return false 
    else return false end
end

function iOrbwalker:LoadMenu(Menu)

    self.Menu = Menu
    self.Menu:addSubMenu("Drawing Settings", "Draw")
            self.Menu.Draw:addParam("myAARange","My AA Range", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("enemyAARange","Enemy AA Range", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("HoldDraw","Hold position radius", SCRIPT_PARAM_ONOFF, true)
            self.Menu.Draw:addParam("Target","Draw circle target", SCRIPT_PARAM_ONOFF, true)
        self.Menu:addSubMenu("Adjustment Settings", "Adjustment")
            self.Menu.Adjustment:addParam("farmDelay", "Delay on Farm (Req. type of delay)", SCRIPT_PARAM_SLICE, 70, 0, 150, 0)
            self.Menu.Adjustment:addParam("typeOfDelay", "Farm Adjustment", SCRIPT_PARAM_LIST, 1, {"None", "Earlier Hit", "Later Hit"})
            self.Menu.Adjustment:addParam("keyDelay", "Switcher for Farm Adjustment", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("L"))
        self.Menu:addParam("HoldRadius", "Hold position radius", SCRIPT_PARAM_SLICE, 80, 60, 250)
        self.Menu:addParam("minionRange", "Range to analyze minions", SCRIPT_PARAM_SLICE, 550, 300, 900)
        self.Menu:addParam("PriorizeFarm","Priorize Farm over Harass", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Adjustment:permaShow("typeOfDelay")

    AddDrawCallback(function() self:OnDraw() end)
    AddTickCallback(function() self:OnTick() end)
    AddMsgCallback(function(msg, key) self:OnWndMsg(msg, key) end)
    AddCreateObjCallback(function(obj) self:OnCreateObj(obj) end)
end

function iOrbwalker:OnWndMsg(msg, key)

    if msg == KEY_UP then
       if key == self.Menu.Adjustment._param[3].key then
            self.Menu.Adjustment.typeOfDelay = self.Menu.Adjustment.typeOfDelay + 1
            if self.Menu.Adjustment.typeOfDelay == 4 then self.Menu.Adjustment.typeOfDelay = 1 end
       end
    end
end

function iOrbwalker:OnCreateObj(obj)
    if obj == nil then return end
end

function iOrbwalker:OnProcessSpell(unit, spell)
    if unit== nil or spell == nil then return end 
    if unit.isMe then
        if spell.name:lower():find("basicattack") then
            if not self.dataUpdated then
                self.baseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
                self.baseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
                self.dataUpdated = true
            end
            self.animationTime = 1 / (spell.animationTime * myHero.attackSpeed)
            self.windUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
            self.isAttacking = true
            self.nextAA = os.clock() + (self:AnimationTime() - self:Latency()) - 0.2
            local time = math.max(spell.windUpTime - self:Latency() + Config.Misc.bufferAA * 0.01, 0)
            DelayAction(function() self.isAttacking = false self.reset = false end,  time)

        elseif spell.name:lower():find("tiamat") or spell.name:lower():find("hydra") then
            self:ResetAA()
        elseif spell.name:lower():find("rengarq") then
            --DelayAction(function() self:ResetAA() end, self:WindUpTime() - self:Latency() * 2 )
            self:ResetAA()
        end
    end
end



function iOrbwalker:OnTick() 
    if self.Menu == nil then return end
    minionRange = self.Menu.minionRange
    if Config.Keys.Harass or Config.Keys.Clear or Config.Keys.LastHit then
        EnemyMinions:update()
        JungleMinions:update()
    end
    
    if Config.Keys.Combo then
        local target = self:Combo()
        if ValidTarget(target) then self:Orbwalk(target) else self:Orbwalk(nil) end
    elseif Config.Keys.Harass then
        local target, boolean = self:Harass()
        if ValidTarget(target) and boolean then self:Orbwalk(target) else self:Orbwalk(nil) end
    elseif Config.Keys.LastHit then
        local target, boolean = self:LastHit()
        if ValidTarget(target) and boolean then self:Orbwalk(target) else self:Orbwalk(nil) end
    elseif Config.Keys.Clear then
        local killableMinion, farKillableMinion, almostKillableMinion, whileWaitingMinion, bestJungle  = self:LaneClear()
        if ValidTarget(killableMinion) then self:Orbwalk(killableMinion)
        elseif ValidTarget(whileWaitingMinion) then self:Orbwalk(whileWaitingMinion)
        elseif ValidTarget(bestJungle) then self:Orbwalk(bestJungle)
        else self:Orbwalk(nil) end
        
    end
end

function iOrbwalker:CanAttack()
    return self.nextAA <= os.clock() and not self.bufferAA and not self.isAttacking
end

function iOrbwalker:Latency()
    return GetLatency() / 2000
end

function iOrbwalker:WindUpTime()
    return 1 / (myHero.attackSpeed * self.baseWindUpTime)
end
function iOrbwalker:AnimationTime()
    return 1 / (myHero.attackSpeed * self.baseAnimationTime)
end

function iOrbwalker:ResetAA()
    local target = self:getTarget()
    --[[
    if ValidTarget(target) then
        if damage:requiresAA(target) and (Config.Keys.Combo or Config.Keys.Harass) then
            modes:Insert("AA", target, 3)
        elseif not (Config.Keys.Combo or Config.Keys.Harass) then
            modes:Insert("AA", target, 3)
        end
    end
    ]]
    if self.Menu == nil and _G.AutoCarry then 
        _G.AutoCarry.Orbwalker:ResetAttackTimer()
    end
    self.isAttacking = false
    self.nextAA = 0
    self.reset = true
    
end

function iOrbwalker:CanCast()
    if self.Menu == nil then return not self.isAttacking and not self.bufferAA end
    if self.Menu.PriorizeFarm and Config.Keys.Harass then
        local minions = self:getKillableMinions()
        if minions ~= nil then
            if #minions > 0 then 
                 for i, minion in pairs(minions) do
                    if ValidTarget(minion, AA.Range(minion)) then 
                        return false
                    end
                end
            else return true end
        end
    end
    return not self.isAttacking and not self.bufferAA
end

function iOrbwalker:InRange(target)
    return ValidTarget(target) and ValidTarget(target, AA.Range(target))
end

function iOrbwalker:Orbwalk(target)
    if ValidTarget(target, ts.range) then self.target = target else self.target = nil end
    if ValidTarget(target) and self:CanAttack() and self:InRange(target) then
        myHero:Attack(target)
        self.bufferAA = true
        DelayAction(function()
            self.bufferAA = false
        end, self:Latency() * 2)
    else 
        if GetDistance(myHero, mousePos) > Config.Orbwalking.HoldRadius and not self.isAttacking and not self.bufferAA then
            myHero:MoveTo(mousePos.x, mousePos.z)
        end
    end
end

function iOrbwalker:getTarget()
    if self.Menu == nil and _G.AutoCarry then
       return _G.AutoCarry.Crosshair:GetTarget()
    else
        return self.target
    end
end

function iOrbwalker:OnDraw()

    if self.Menu == nil then return end
    if self.Menu.Draw.HoldDraw then
        draw:DrawCircle2(myHero.x, myHero.y, myHero.z, self.Menu.HoldRadius, Colors.Blue, 1)
    end

    if self.Menu.Draw.myAARange then
        draw:DrawCircle2(myHero.x, myHero.y, myHero.z, AA.Range(self:getTarget()), Colors.White, 1)
    end

    if self.Menu.Draw.enemyAARange then
        for idx, enemy in ipairs(GetEnemyHeroes()) do
            if ValidTarget(enemy) and GetDistance(enemy, mousePos) < visionRange then
                draw:DrawCircle2(enemy.x, enemy.y, enemy.z, self:getAARange(enemy), Colors.White, 1)
            end
        end
    end

    if (Config.Keys.Combo or Config.Keys.Harass or Config.Keys.Clear or Config.Keys.LastHit) and self.Menu.Draw.Target then
        if Config.Keys.Combo then
        elseif Config.Keys.Harass then
            local target, boolean = self:Harass()
            if ValidTarget(target) then
                if boolean and target.name:lower():find("minion") then draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Red, 5)
                else draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 1) end
            end
        elseif Config.Keys.LastHit then
            local target, boolean = self:LastHit()
            if ValidTarget(target) then
                if boolean then draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Red, 5)
                else draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 1) end
            end
        elseif Config.Keys.Clear then
            local killableMinion, farKillableMinion, almostKillableMinion, whileWaitingMinion, bestJungle = self:LaneClear()
            if ValidTarget(killableMinion) then local target = killableMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Red, 5) end
            if ValidTarget(farKillableMinion) then local target = farKillableMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 5) end
            if ValidTarget(almostKillableMinion) then local target = almostKillableMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Yellow, 1) end
            if ValidTarget(whileWaitingMinion) then local target = whileWaitingMinion draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.Green, 1) end
            if ValidTarget(bestJungle) then local target = bestJungle draw:DrawCircle2(target.x, target.y, target.z, VP:GetHitBox(target), Colors.White, 1) end
            
        end
    end

end

function iOrbwalker:getAARange(unit)
    return ValidTarget(unit) and unit.range + unit.boundingRadius + myHero.boundingRadius - 10 or 0
end

function iOrbwalker:Combo()
   return ts.target
end

function iOrbwalker:LaneClear()
    local bestMinions = {}
    local killables = self:getKillableMinions()
    local killableMinion = nil
    local almostKillableMinion = nil
    local whileWaitingMinion = nil
    local farKillableMinion = nil
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, AA.Range(minion)) then 
                --table.insert(bestMinions, #bestMinions + 1, minion)
                --return {minion}
                killableMinion = minion
                break
            end
        end
    end
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, minionRange) and GetDistance(myHero, minion) > AA.Range(minion) then 
                if farKillableMinion == nil then
                    farKillableMinion = minion
                elseif GetDistance(myHero, farKillableMinion) > GetDistance(myHero, minion) then
                    farKillableMinion = minion
                end
            end
        end
    end
    --if #bestMinions > 0 then return bestMinions, true, false end

    bestMinions = {}
    local waitMinion = self:ShouldWait() 
    local bestMinion = nil
    if not waitMinion and os.clock() - self.lastWait > 0.5 then
        for i, minion in pairs(EnemyMinions.objects) do
            if ValidTarget(minion, minionRange) then
                local predHealth = prediction:getPredictedHealth(minion, 2)
                if predHealth > 2 * damage:getDamageToMinion(minion) then
                    
                    if bestMinion == nil then bestMinion = minion
                    elseif GetDistance(myHero, bestMinion) > GetDistance(myHero, minion) then bestMinion = minion end
                end
            end
        end
        if bestMinion ~= nil then whileWaitingMinion = bestMinion end
    end
    if waitMinion and not killableMinion then
        almostKillableMinion = waitMinion
    elseif os.clock() - self.lastWait > 0.5 or not ValidTarget(waitMinion) then
        almostKillableMinion = nil
    end
    --if #bestMinions > 0 then return bestMinions, false, true end



    bestMinions = {}
    bestJungle = nil
    for i, minion in pairs(JungleMinions.objects) do
        if ValidTarget(minion, AA.Range(minion)) then
            --[[
            if #bestMinions > 0 then
                local minion2 = bestMinions[#bestMinions]
                 if minion2.maxHealth > minion.maxHealth then
                     table.insert(bestMinions, #bestMinions + 1, minion)
                 else
                     table.insert(bestMinions, #bestMinions, minion)
                 end
            else
                table.insert(bestMinions, 1, minion)
            end]]
            if bestJungle == nil then
                bestJungle = minion
            elseif bestJungle.maxHealth < minion.maxHealth then
                bestJungle = minion
            end
        end
    end

    return killableMinion, farKillableMinion, almostKillableMinion, whileWaitingMinion, bestJungle
    --if #bestMinions > 0 then return bestMinions, false, true end
    --bestMinions = {}
    --return bestMinions, false, false
end

function iOrbwalker:LastHit()
    local killables = self:getKillableMinions()
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, AA.Range(minion)) then 
                return minion, true
            elseif ValidTarget(minion) and GetDistance(myHero, minion) > AA.Range(minion) then 
                return minion, false
            end
        end
    end
    local almostKillables = self:getAlmostKillableMinions()
    for i, minion in pairs(almostKillables) do
        if ValidTarget(minion, minionRange) then 
            return minion, false
        end
    end
    
end

function iOrbwalker:Harass()
    if not self.Menu.PriorizeFarm and ValidTarget(ts.target, AA.Range(ts.target)) then 
        return ts.target, true
    end
    local killables = self:getKillableMinions()
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion, AA.Range(minion)) then 
                return minion, true
            end
        end
    end
    if self.Menu.PriorizeFarm and ValidTarget(ts.target, AA.Range(ts.target) + 50) then 
        return ts.target, true
    end
    if #killables > 0 then
        for i, minion in pairs(killables) do
            if ValidTarget(minion) and GetDistance(myHero, minion) > AA.Range(minion) then
                return minion, false
            end
        end
    end
    local almostKillables = self:getAlmostKillableMinions()
    for i, minion in pairs(almostKillables) do
        if ValidTarget(minion, minionRange) then 
            return minion, false
        end
    end
    

end

function iOrbwalker:getKillableMinions()
    local bestMinions = {}
    local bestBigMinions = {}
    --big minion first
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) and not minion.dead and minion.charName:lower():find("cannon") then
            local predHealth = prediction:getPredictedHealth(minion, 1)
            if damage:getDamageToMinion(minion) > predHealth and predHealth > self.predHealthLimit then
                table.insert(bestBigMinions, #bestBigMinions + 1, minion)
            end
        end
    end
    --small minions after
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) and not minion.dead and not minion.charName:lower():find("cannon") then
            local predHealth = prediction:getPredictedHealth(minion, 1)
            if damage:getDamageToMinion(minion) > predHealth and predHealth > self.predHealthLimit then
                
                if #bestMinions > 0 then
                    local minion2 = bestMinions[#bestMinions]
                    local predHealth2 = prediction:getPredictedHealth(minion2, 1)
                    if predHealth2/minion2.maxHealth < predHealth/minion.maxHealth then
                        table.insert(bestMinions, #bestMinions + 1, minion)
                    else
                        table.insert(bestMinions, #bestMinions, minion)
                    end
                else
                    table.insert(bestMinions, 1, minion)
                end
                
                --table.insert(bestMinions, #bestMinions + 1, minion)
            end
        end
    end
    if #bestBigMinions > 0 then
        for i, bigMinion in pairs(bigMinions) do
            table.insert(bestMinions, i, bigMinion)
        end
    end
    return bestMinions
end

function iOrbwalker:getAlmostKillableMinions()
    bestMinions = {}
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) and not minion.dead then
            local predHealth = prediction:getPredictedHealth(minion, 1)
            if predHealth > self.predHealthLimit then
                if #bestMinions > 0 then
                    local minion2 = bestMinions[#bestMinions]
                    local predHealth2 = prediction:getPredictedHealth(minion2, 1)
                    if predHealth2/minion2.maxHealth < predHealth/minion.maxHealth then
                        table.insert(bestMinions, #bestMinions + 1, minion)
                    else
                        table.insert(bestMinions, #bestMinions, minion)
                    end
                else
                    table.insert(bestMinions, 1, minion)
                end
            end
        end
    end
    return bestMinions
end



function iOrbwalker:ShouldWait()
    for i, minion in pairs(EnemyMinions.objects) do
        if ValidTarget(minion, minionRange) then
            if ValidTarget(minion, AA.Range(minion)) then
                if damage:getDamageToMinion(minion) > prediction:getPredictedHealth(minion, 2) then
                    self.lastWait = os.clock()
                    return minion
                end
            end
        end
    end
end

--farm adjustment
function iOrbwalker:OnWndMsg(msg, key)
    if self.Menu == nil then return end
    if msg == KEY_UP then
       if key == self.Menu.Adjustment._param[3].key then
            self.Menu.Adjustment.typeOfDelay = self.Menu.Adjustment.typeOfDelay + 1
            if self.Menu.Adjustment.typeOfDelay == 4 then self.Menu.Adjustment.typeOfDelay = 1 end
       end
   end
end

function iOrbwalker:getFarmDelay()
    local output = 0
    if self.Menu.Adjustment.typeOfDelay == 3 then
        output = self.Menu.Adjustment.farmDelay/1000
    elseif self.Menu.Adjustment.typeOfDelay == 2 then
        output = (-1) * self.Menu.Adjustment.farmDelay/1000
    end
    return output
end


class "Prediction"
function Prediction:__init()
    self.delay = 0.07
    self.ProjectileSpeed = myHero.range > 100 and VP:GetProjectileSpeed(myHero) or math.huge
end

function Prediction:getPrediction(unit, range, speed, delay, width, source, collision, skillshot)
    if Config.Misc.predictionType == 1 then
        return VP:GetBestCastPosition(unit, delay, width, range, speed, source, collision, skillshot)
    else 
        local pos, info = Prodiction.GetPrediction(unit, range, speed, delay, width, source)
        if collision and skillshot == "line" then
            if not info.mCollision() then 
                return pos, info.hitchance, info.pos
            else return pos, -1, info.pos end
        else
            return pos, info.hitchance, info.pos
        end
    end
end

--farm and more
function Prediction:getTimeMinion(minion, mode)
    local time = 0
    --lasthit
    if mode == 1 then
        time = iOrb:WindUpTime() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - self.delay
    --laneclear
    elseif mode == 2 then
        time = iOrb:AnimationTime() + GetDistance(myHero.pos, minion.pos) / self.ProjectileSpeed - self.delay
        time = time * 2
    end
    return time
end



function Prediction:getPredictedHealth(minion, mode)
    local output = 0
    --lasthit
    if mode == 1 then
        local time = self:getTimeMinion(minion, mode)
        local predHealth, maxdamage, count = VP:GetPredictedHealth(minion, time, 0.07)
        output = predHealth
    --laneclear
    elseif mode == 2 then
        local time = self:getTimeMinion(minion, mode)
        local predHealth, maxdamage, count = VP:GetPredictedHealth2(minion, time)
        output = predHealth
    end
    return output
end

function Prediction:getPredictedPos(unit, delay, speed, from, collision)
    return VP:GetPredictedPos(unit, delay, speed, from, collision)
end

class "Damage"
function Damage:__init()

end

function Damage:getBestCombo(target)
    local q = {false}
    local w = {false}
    local e = {false}
    local r = {false}
    if Q.IsReady() then q = {false, true} end
    if W.IsReady() then w = {false, true} end
    if E.IsReady() then e = {false, true} end
    local bestdmg = 0
    local best = {false, false, false, false}
    local dmg, mana = self:getComboDamage(target, Q.IsReady(), W.IsReady(), E.IsReady(), R.IsReady())
    if dmg > target.health then
        for qCount = 1, #q do
            for wCount = 1, #w do
                for eCount = 1, #e do
                    for rCount = 1, #r do
                        local d, m = self:getComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                        if d > target.health and myHero.mana > m then 
                            if bestdmg == 0 then bestdmg = d best = {q[qCount], w[wCount], e[eCount], r[rCount]}
                            elseif d < bestdmg then bestdmg = d best = {q[qCount], w[wCount], e[eCount], r[rCount]} end
                        end
                    end
                end
            end
        end
        return best[1], best[2], best[3], best[4], bestdmg
    else
        local table2 = {false,false,false,false}
        local bestdmg, mana = self:getComboDamage(target, false, false, false, false)
        for qCount = 1, #q do
            for wCount = 1, #w do
                for eCount = 1, #e do
                    for rCount = 1, #r do
                        local d, m = self:getComboDamage(target, q[qCount], w[wCount], e[eCount], r[rCount])
                        if d > bestdmg and myHero.mana > m then 
                            table2 = {q[qCount],w[wCount],e[eCount],r[rCount]}
                            bestdmg = d
                        end
                    end
                end
            end
        end
        return table2[1],table2[2],table2[3],table2[4], bestdmg
    end
end

function Damage:getComboDamage(target, q, w, e, r)
    local comboDamage = 0
    local currentManaWasted = 0
    if target ~= nil and target.valid then
        if q then
            comboDamage = comboDamage + Q.Damage(target)
            currentManaWasted = currentManaWasted + Q.Mana()
        end
        if w then
            comboDamage = comboDamage + W.Damage(target)
            currentManaWasted = currentManaWasted + W.Mana()
        end
        if e then
            comboDamage = comboDamage + E.Damage(target)
            currentManaWasted = currentManaWasted + E.Mana()
        end
        if r then
            comboDamage = comboDamage + R.Damage(target)
            currentManaWasted = currentManaWasted + R.Mana()
        end
        comboDamage = comboDamage + AA.Damage(target)
        for _, item in pairs(CastableItems) do
            if item.IsReady() then
                comboDamage = comboDamage + item.Damage(target)
            end
        end
    end
    comboDamage = comboDamage * self:getOverkill()
    return comboDamage, currentManaWasted
end

function Damage:getDamageToMinion(minion)
    return VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0)
end

function Damage:getOverkill()
    return (100 + Config.Misc.overkill)/100
end

class "Draw"
function Draw:__init()
    self.Menu = nil
end

function Draw:LoadMenu(menu)
    self.Menu = menu
    self.Menu:addParam("Q","Q Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("W","W Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("E","E Range", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Target","Red Circle on Target", SCRIPT_PARAM_ONOFF, true)
    self.Menu:addParam("Quality", "Quality of Circles", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
    AddDrawCallback(function() self:OnDraw() end)
end

function Draw:OnDraw()
    if myHero.dead or self.Menu == nil then return end
    if self.Menu.Target and ts.target ~= nil and ValidTarget(ts.target) then
        self:DrawCircle2(ts.target.x, ts.target.y, ts.target.z, VP:GetHitBox(ts.target)*1.5, Colors.Red, 3)
    end

    if self.Menu.Q and Q.IsReady() then
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, Q.Range, Colors.White, 1)
    end
    if self.Menu.W and W.IsReady() then
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, W.Range, Colors.White, 1)
    end

    if self.Menu.E and E.IsReady() then
        self:DrawCircle2(myHero.x, myHero.y, myHero.z, E.Range, Colors.White, 1)
    end
end




-- Barasia, vadash, viceversa
function Draw:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
  quality = math.max(8,self:round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end
function Draw:round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function Draw:DrawCircle2(x, y, z, radius, color, width)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        self:DrawCircleNextLvl(x, y, z, radius, width, color, 75 + 2000 * (100 - self.Menu.Quality)/100) 
    end
end

-- Barasia, vadash, viceversa
function Draw:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
  quality = math.max(8,self:round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end
function Draw:round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function Draw:DrawCircle2(x, y, z, radius, color, width)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        self:DrawCircleNextLvl(x, y, z, radius, width, color, 75 + 2000 * (100 - self.Menu.Quality)/100) 
    end
end
