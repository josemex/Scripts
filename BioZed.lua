if myHero.charName ~= "Zed" then return end
if VIP_USER then
    PrintChat("<font color=\"#FF0000\" >> BioZed By Lucas v 2.7 <</font> ")
end
 
local RREADY, QREADY, WREADY, EREADY
local VP
local ts
local lastSkin = 0
local UltTargets = GetEnemyHeroes()
local version = 2.7
local scriptName = "BioZed"
local Qrange, Qwidth, Qspeed, Qdelay = 900, 45, 902, 0.25
local QReady, WReady, EReady, RReady = false, false, false, false
local Zed = {
        Q = {range = 900, speed = 902, delay = 0.25},
}
 
-- Change autoUpdate to false if you wish to not receive auto updates.
-- Change silentUpdate to true if you wish not to receive any message regarding updates
local autoUpdate = false
local silentUpdate = false
 
 
-- Lib Downloader --
 
local REQUIRED_LIBS = {
    ["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua",
    ["SOW"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua",
    ["SourceLib"] = "https://raw.githubusercontent.com/TheRealSource/public/master/common/SourceLib.lua",
    ["Selector"] = "http://iuser99.com/scripts/Selector.lua",
}
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
local SELF_NAME = GetCurrentEnv() and GetCurrentEnv().FILE_NAME or ""
 
function AfterDownload()
    DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
    if DOWNLOAD_COUNT == 0 then
        DOWNLOADING_LIBS = false
        print("<b>Required libraries downloaded successfully, please reload (double F9).</b>")
    end
end
 
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
    if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
        require(DOWNLOAD_LIB_NAME)
    else
        DOWNLOADING_LIBS = true
        DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
        DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
    end
end
 
if DOWNLOADING_LIBS then print("Downloading required libraries, please wait...") return end
 
 
require "Prodiction"
 
 
function OnLoad()
   
    UpdateWeb(true, ScriptName, id, HWID)
    ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 900 ,DAMAGE_PHYSICAL)
    ts.name = "AllClass TS"
    if VIP_USER then
        VP = VPrediction()
    end
    SOWi = SOW(VP)
    LoadVariables()
    Selector.Instance()
    TS = SimpleTS(STS_LESS_CAST_MAGIC)
    STS = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
    LoadMenu()
    Ignite()
    for i=1, heroManager.iCount do
        local champ = heroManager:GetHero(i)
        if champ.team ~= myHero.team then
            EnemysInTable = EnemysInTable + 1
            EnemyTable[EnemysInTable] = { hero = champ, Name = champ.charName, p = 0, q = 0, q2 = 0, e = 0, r = 0, IndicatorText = "", IndicatorPos, NotReady = false, Pct = 0}
        end
    end
    PrintFloatText(myHero,11,"LETS RAPE >:D !")
    EnemyMinions = minionManager(MINION_ENEMY, 900, myHero, MINION_SORT_HEALTH_ASC)
    qEnergy = {75, 70, 65, 60, 55}
    wEnergy = {40, 35, 30, 25, 20}
    eCost = 50
    qDelay, qWidth, qRange, qSpeed = 0.25, 45, 900, 902
    wDelay, wWidth, wRange, wSpeed = 0.25, 40, 550, 1600
    wSwap = false
    wCast = false
end
 
function OnTick()
 
        if Config.VIP.skin and skinChanged() then
                GenModelPacket("Zed", Config.VIP.skin1)
                lastSkin = Config.VIP.skin1
        end
    if GetGame().isOver then
        UpdateWeb(false, ScriptName, id, HWID)
        -- This is a var where I stop executing what is in my OnTick()
        startUp = false;
end
    ts:update()
    tstarget = ts.target
    if ValidTarget(tstarget) and tstarget.type == myHero.type then
        Target = tstarget
    else
        Target = nil
    end
    Calculations()
    GlobalInfos()
    HarassKey = Config.harass.harassKey
    if HarassKey then Harass() end
    if (myHero:GetSpellData(_R).name == "ZedR2") then
        for i = 1, heroManager.iCount, 1 do
            local enemyhero = heroManager:getHero(i)
            if enemyhero.team ~= myHero.team and TargetHaveBuff("zedulttargetmark", enemyhero) then
                ts.target = enemyhero
            end
        end
    end
    SetCooldowns()
    if Config.ComboS.Fight then Fight() end
    if Config.ComboS2.Fight2 then Fight2() end
    if Config.lfarm.farmKey then
        EnemyMinions:update()
        for _, minion in pairs(EnemyMinions.objects) do
            if Config.lfarm.farmQ then
                if minion.health <= getDmg("Q", minion, myHero) then
                    if GetDistance(myHero.visionPos, minion) <= qRange then CastSpell(_Q, minion.x, minion.z) end
                end
            end
            if Config.lfarm.FarmE then
                if minion.health <= getDmg("E", minion, myHero) then
                    if GetDistance(myHero.visionPos, minion) <= eRange then CastSpell(_E, myHero) end
                end
            end
        end
    end
end
 
function OnUnload()
    PrintFloatText(myHero,9,"U NO RAPE ?! :,( ")
    UpdateWeb(false, ScriptName, id, HWID)
end
 
function LoadVariables()
 
 
    UseSwap = true
    ChampCount = nil
    wClone, rClone = nil, nil
    RREADY, QREADY, WREADY, EREADY = false, false, false, false
    ignite = nil
    lastW = 0
    delay, qspeed = 235, 1.742
   
    --Helpers
    EnemyTable = {}
    EnemysInTable = 0
    HealthLeft = 0
    PctLeft = 0
    BarPct = 0
    orange = 0xFFFFE303
    green = ARGB(255,0,255,0)
    blue = ARGB(255,0,0,255)
    red = ARGB(255,255,0,0)
    eRange = 280
    Target = nil
    QREADY = nil
    WREADY = nil
    EREADY = nil
    RREADY = nil
    QMana = nil
    WMana = nil
    EMana = nil
    RMana = nil
    MyMana = nil
end
 
function LoadMenu()
    Config = scriptConfig("BioZed by Lucas and Pyr", "Die")
   
    Config:addSubMenu("BioZed - Combo Settings", "ComboS")
    Config.ComboS:addParam("Fight", "BioCombo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Config.ComboS:addParam("SwapUlt","Swap back with ult if hp < %", SCRIPT_PARAM_SLICE, 15, 2, 100, 0)
    Config.ComboS:addParam("NoWWhenUlt","Don't use W when Zed ult", SCRIPT_PARAM_ONOFF, true)
    Config.ComboS:addParam("rSwap", "Swap to R shadow if safer when mark kills", SCRIPT_PARAM_ONOFF, false)
    Config.ComboS:addParam("wSwap", "Swap with W to get closer to target", SCRIPT_PARAM_ONOFF, false)
 
   
    Config:addSubMenu("BioZed - Combo 2 Settings", "ComboS2")
    Config.ComboS2:addParam("Fight2", "BioCombo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    Config.ComboS2:addParam("SwapUlt2","Swap back with ult if hp < %", SCRIPT_PARAM_SLICE, 15, 2, 100, 0)
    Config.ComboS2:addParam("rSwap2", "Swap to R shadow if safer when mark kills", SCRIPT_PARAM_ONOFF, false)
    Config.ComboS2:addParam("wSwap2", "Swap with W to get closer to target", SCRIPT_PARAM_ONOFF, false)
   
    Config:addSubMenu("BioZed - Harass Settings", "harass")
    Config.harass:addParam("harassKey", "Harass Key (T)", SCRIPT_PARAM_ONKEYDOWN, false,string.byte("T"))
    Config.harass:addParam("mode", "True = QWE, False = Q", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("V"))
    Config.harass:permaShow("mode")
   
    Config:addSubMenu("BioZed - Ignite Settings", "lignite")
    Config.lignite:addParam("igniteOptions", "Ignite Options", SCRIPT_PARAM_LIST, 2, { "Don't use", "Burst"})
    Config.lignite:addParam("autoIgnite", "Ks Ignite", SCRIPT_PARAM_ONOFF, true)
   
    Config:addSubMenu("BioZed - Drawing Setting", "draw")
    Config.draw:addParam("DmgIndic","Kill text", SCRIPT_PARAM_ONOFF, true)
    Config.draw:addParam("Edraw", "Draw E", SCRIPT_PARAM_ONOFF, true)
    Config.draw:addParam("Qdraw", "Draw Q", SCRIPT_PARAM_ONOFF, true)
   
    Config:addSubMenu("BioZed - Prediction","SSettings")
    Config.SSettings:addParam("Vpred", "Use Vprediction", SCRIPT_PARAM_ONOFF, true)
    Config.SSettings:addParam("Prod", "Use Prodiction(VIP ONLY)", SCRIPT_PARAM_ONOFF, false)
 
  Config:addSubMenu("BioZed - Skin Changer", "VIP")
        Config.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
        Config.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 7)
 
    Config:addSubMenu("BioZed - Farm", "lfarm")
    Config.lfarm:addParam("farmKey", "Farm", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    Config.lfarm:addParam("farmQ", "Farm With Q", SCRIPT_PARAM_ONOFF, true)
    Config.lfarm:addParam("FarmE", "Farm With E", SCRIPT_PARAM_ONOFF, true)
 
    Config:addSubMenu("BioZed - Target Selector","TS")
        Config.TS:addParam("TS","Target Selector",7,2,{ "AllClass", "Selector"})
    Config.TS:addTS(ts)
               
    Config:addSubMenu("BioZed - Orbwalking", "Orbwalking")
    SOWi:LoadToMenu(Config.Orbwalking)
   
end
 
function autoIgnite()
    if Config.lignite.autoIgnite then
        if iReady then
            local ignitedmg = 0
            for i = 1, heroManager.iCount, 1 do
                local enemyhero = heroManager:getHero(i)
                if ValidTarget(enemyhero,600) then
                    ignitedmg = 50 + 20 * myHero.level
                    if enemyhero.health <= ignitedmg then
                        CastSpell(ignite, enemyhero)
                    end
                end
            end
        end
    end
end
 
function Swap()
    local wDist = nil
    if UseSwap == true then
        if ts.target then
            if wClone and wClone.valid then
                wDist = GetDistance(ts.target, wClone)
            else
                return false
            end
            if GetDistance(ts.target) > 250 then
                if wDist and wDist ~= 0 and (GetDistance(ts.target, myHero) > wDist) and (myHero:CanUseSpell(_W) == READY) and not EREADY then
                    CastSpell(_W)
                end
            end
        end
    end
end
 
function CountEnemies(point, range)
    local ChampCount = 0
    for j = 1, heroManager.iCount, 1 do
        local enemyhero = heroManager:getHero(j)
        if myHero.team ~= enemyhero.team and ValidTarget(enemyhero, 750) then
            if GetDistanceSqr(enemyhero, point) <= range*range then
                ChampCount = ChampCount + 1
            end
        end
    end
    return ChampCount
end
 
function Fight()
if Config.ComboS.wSwap then Swap() end
    if QREADY and EREADY and WREADY and RREADY then
        ts.range = 1200
    else
        ts.range = 900
    end
    if ts.target then
            if not (TargetHaveBuff("JudicatorIntervention", ts.target) or TargetHaveBuff("Undying Rage", ts.target)) then
                    if RREADY and MyMana > (QMana + EMana) then CastR(ts.target) end
                    if not RREADY or rClone ~= nil then
                        if myHero:GetSpellData(_W).name ~= "zedw2" and WREADY and ((GetDistance(ts.target) < 700) or (GetDistance(ts.target) > 125 and not RREADY)) then
                            if not (Config.ComboS.NoWWhenUlt and ((myHero:GetSpellData(_R).name == "ZedR2") or (rClone ~= nil and rClone.valid))) then
                                if MyMana > (WMana+EMana) then
                                    CastSpell(_W, ts.target.x, ts.target.z)
                                end
                            end
                        end
                       
                        if (not WREADY or wClone ~= nil or Config.ComboS.NoWWhenUlt or wUsed) and (not RREADY or rClone ~= nil) then
                            if EREADY then
                                CastE()
                            end
                            if QREADY and GetDistance(ts.target, myHero) < qRange and (myHero:CanUseSpell(_R) == COOLDOWN or myHero:CanUseSpell(_R) == NOTLEARNED or (rClone and rClone.valid)) then
                                CastQ()
                            end
                        end
                    end
                end
               
               
                if Config.lignite.igniteOptions == 2 and TargetHaveBuff("zedulttargetmark", ts.target) then
                    if iReady then
                        if GetDistance(ts.target) <= 600 then
                            CastSpell(ignite, ts.target)
                        end
                    end
                end
                CastItems(ts.target)
                if RREADY and rClone ~= nil and Config.ComboS.rSwap then
                    if isDead then
                        if CountEnemies(myHero, 250) > CountEnemies(rClone, 250) then
                            --PrintChat("DEAD")
                            UseSwap = false
                            CastSpell(_R)
                            DelayAction(function() UseSwap = true end, 5)
                        end
                    end
                end
               
               
                if myHero:GetSpellData(_R).name == "ZedR2" and ((myHero.health / myHero.maxHealth * 100) <= Config.ComboS.SwapUlt) then
               
                        CastSpell(_R)
                end
                if ValidTarget(ts.target) then
                    local UltDmg = (getDmg("AD", ts.target, myHero) + ((.15*(myHero:GetSpellData(_R).level)+.5)*((getDmg("Q", ts.target, myHero, 3)*2) + (getDmg("E", ts.target, myHero, 1)))))
                    if UltDmg >= ts.target.health then
                        if GetDistance(ts.target, myHero) < 1125 and GetDistance(ts.target, myHero) > 750 then
                            local DashPos = myHero + Vector(ts.target.x - myHero.x, 0, ts.target.z - myHero.z):normalized()*550
                            if QREADY and EREADY and RREADY and not wClone and not rClone then
                                --PrintChat("Gapclose")
                                if myHero:GetSpellData(_W).name == "ZedShadowDash" then CastSpell(_W, DashPos.x, DashPos.z) end
                            end
                            if wClone and wClone.valid and not rClone then
                                CastSpell(_W, myHero)
                                CastSpell(_R, ts.target)
                            end
                           
                        end
                    end
                end
            end
        end
 
function Fight2()
    if Config.ComboS2.wSwap then Swap() end
    if QREADY and EREADY and WREADY then
        ts.range = 1200
    else
        ts.range = 900
    end
    if ts.target then
        for i = 1, heroManager.iCount, 1 do
            if not (TargetHaveBuff("JudicatorIntervention", ts.target) or TargetHaveBuff("Undying Rage", ts.target)) then
                for i = 1, heroManager.iCount, 1 do
                    if myHero:GetSpellData(_W).name ~= "zedw2" and WREADY and ((GetDistance(ts.target) < 700) or (GetDistance(ts.target) > 125 )) then
                        if MyMana > (WMana+EMana) then
                            CastSpell(_W, ts.target.x, ts.target.z)
                        end
                    end
                end
               
                if (not WREADY or wClone ~= nil or wUsed) then
                    if EREADY then
                        CastE()
                    end
                    if QREADY then
                        CastQ()
                    end
                end
            end
        end
                if Config.lignite.igniteOptions == 2 and TargetHaveBuff("zedulttargetmark", ts.target) then
                    if iReady then
                        if GetDistance(ts.target) <= 600 then
                            CastSpell(ignite, ts.target)
                        end
                    end
                end
        CastItems(ts.target)
        if RREADY and rClone ~= nil and Config.ComboS2.rSwap then
            if isDead then
                if CountEnemies(myHero, 250) > CountEnemies(rClone, 250) then
                    --PrintChat("DEAD")
                    UseSwap = false
                    CastSpell(_R)
                    DelayAction(function() UseSwap = true end, 5)
                end
            end
        end
       
        if myHero:GetSpellData(_R).name == "ZedR2" and ((myHero.health / myHero.maxHealth * 100) <= Config.ComboS.SwapUlt) then
                CastSpell(_R)
            end
        end
       
    end
 
function Harass()
    ts.range = 1500
    if ts.target then
        if Config.harass.mode then
            if QREADY and WREADY and (GetDistance(ts.target, myHero) < 800) and (MyMana > QMana+WMana+EMana) then
                if myHero:GetSpellData(_W).name ~= "zedw2" and GetTickCount() > lastW + 1000 then
                    CastSpell(_W, ts.target.x, ts.target.z)
                    if wUsed then CastSpell(_E) end
                end
            end
            if wUsed then
                CastQ()
            end
            if not WREADY then
                CastQ()
                CastQClone()
            end
            CastE()
            if GetDistance(ts.target, myHero) < 1450 and GetDistance(ts.target, myHero) > 900 then
                local DashPos = myHero + Vector(ts.target.x - myHero.x, 0, ts.target.z - myHero.z):normalized()*550
                if QREADY and WREADY and (MyMana > QMana+WMana) then
                    --PrintChat("Gapclose")
                    if myHero:GetSpellData(_W).name == "ZedShadowDash" then CastSpell(_W, DashPos.x, DashPos.z) end
                end
                if wClone and wClone.valid then
                    CastQClone()
                end
               
            end
           
        else
           
           
            if not Config.harass.mode then
                if QREADY and GetDistance(ts.target, myHero) < qRange then
                    CastQ()
                                elseif EReady and GetDistance(ts.target, myHero) < eRange then
                                        CastE()
                                elseif wClone and wClone.valid then
                                        CastE()
                                        CastQClone()
                end
            end
        end
       
    end
end
 
function CastQ()
if Config.SSettings.Vpred then
     if ValidTarget(ts.target) and (GetDistance(ts.target, myHero) < qRange or GetDistance(ts.target, wClone) < qRange or GetDistance(ts.target, rClone) < qRange) then
     local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.25, 50, 925, 1700, myHero, false)
        if HitChance >= 2 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)    
        end
    end
    else if Config.SSettings.Prod then
    if QREADY and ValidTarget(ts.target) and not ts.target.dead and ts.target.visible then
        local pos, info = Prodiction.GetPrediction(ts.target, Qrange, Qspeed, Qdelay, Qwidth)
        if pos and pos.x and pos.z and info and info.hitchance >= 1 and GetDistance(pos) < Qrange then
            CastSpell(_Q, pos.x, pos.z)
        end
    end
end
end
end
 
function CastQClone()
    if Config.SSettings.Vpred then
    if ValidTarget(ts.target) and GetDistance(ts.target, wClone) < qRange then
     local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.25, 50, 925, 1700, wClone, false)
        if HitChance >= 2 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)    
        end
    end
    else if Config.SSettings.Prod then
        if QREADY and ValidTarget(ts.target) and not ts.target.dead and ts.target.visible then
        local clone = Vector(wClone)
        local pos, info = Prodiction.GetPrediction(ts.target, Qrange, Qspeed, Qdelay, Qwidth, clone, false)
       if pos and pos.x and pos.z and info and info.hitchance >= 1 and GetDistance(pos) < Qrange then
            CastSpell(_Q, pos.x, pos.z)
    end
end
end
end
end
 
 
 
function CastE()
    if ValidTarget(ts.target) and (GetDistance(ts.target, myHero) < eRange or GetDistance(ts.target, wClone) < eRange or GetDistance(ts.target, rClone) < eRange) then
        CastSpell(_E, myHero)
    end
end
 
 
function CastR()
    if not RREADY then return end
    if ValidTarget(ts.target) then
        if GetDistance(ts.target) <= 625 and RREADY and myHero:GetSpellData(_R).name ~= "ZedR2" then
            CastSpell(_R, ts.target)
        end
    else
        return
    end
end
 
function rUsed()
    if myHero:GetSpellData(_R).name == "ZedR2" then
        return true
    else
        return false
    end
end
 
function GlobalInfos()
    QREADY = (myHero:CanUseSpell(_Q) == READY)
    WREADY = (myHero:CanUseSpell(_W) == READY)
    EREADY = (myHero:CanUseSpell(_E) == READY)
    RREADY = (myHero:CanUseSpell(_R) == READY)
    QMana = myHero:GetSpellData(_Q).mana
    WMana = myHero:GetSpellData(_W).mana
    EMana = myHero:GetSpellData(_E).mana
    RMana = myHero:GetSpellData(_R).mana
    MyMana = myHero.mana
   
    TemSlot = GetInventorySlotItem(3153)
    BOTRKREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Blade Of The Ruined King
   
    TemSlot = GetInventorySlotItem(3144)
    BCREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Bilgewater Cutlass
   
    TemSlot = GetInventorySlotItem(3074)
    HYDRAREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Ravenous Hydra
   
    TemSlot = GetInventorySlotItem(3077)
    TIAMATREADY = (TemSlot ~= nil and myHero:CanUseSpell(TemSlot) == READY) --Tiamat
   
    iReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end
 
function OnCreateObj(obj)
    if obj.valid and obj.name:find("Zed_Clone_idle.troy") then
        if wClone == nil then
            wClone = obj
        elseif rClone == nil then
            rClone = obj
        end
    end
end
 
function OnDeleteObj(obj)
    if obj.valid and wClone and obj == wClone then
        wClone = nil
    elseif obj.valid and rClone and obj == rClone then
        rClone = nil
    end
end
 
function Ignite()
    if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then ignite = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then ignite = SUMMONER_2
    end
end
 
function SetCooldowns()
    QREADY = (myHero:CanUseSpell(_Q) == READY)
    WREADY = (myHero:CanUseSpell(_W) == READY)
    EREADY = (myHero:CanUseSpell(_E) == READY)
    RREADY = (myHero:CanUseSpell(_R) == READY)
    iReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end
 
function CastItems(target)
    if not ValidTarget(target) then
        return
    else
        if GetDistance(ts.target) <=480 then
            CastItem(3144, target) --Bilgewater Cutlass
            CastItem(3153, target) --Blade Of The Ruined King
        end
        if GetDistance(ts.target) <=400 then
            CastItem(3146, target) --Hextech Gunblade
        end
        if GetDistance(ts.target) <= 300 then
            CastItem(3184, target) --Entropy
            CastItem(3143, target) --Randuin's Omen
            CastItem(3074, target) --Ravenous Hydra
            CastItem(3131, target) --Sword of the Divine
            CastItem(3077, target) --Tiamat
            CastItem(3142, target) --Youmuu's Ghostblade
        end
        if GetDistance(ts.target) <= 1000 then
            CastItem(3023, target) --Twin Shadows
        end
    end
end
 
function GrabTarget()
        if _G.Selector_Enabled and Config.TS.TS == 2 then
            return Selector.GetTarget(LESSCASTADVANCED, 'AD', {distance = Spells.R.range})
        elseif Config.TS.TS == 1 then
            ts.range = MaxRange()
            ts:update()
            return ts.target
        end
    end
		
function MaxRange()
        if QREADY then
            return Zed.Q["range"]
        end
        return myHero.range + 50
    end
 
function Calculations()
    QREADY = (myHero:CanUseSpell(_Q) == READY)
    WREADY = (myHero:CanUseSpell(_W) == READY)
    EREADY = (myHero:CanUseSpell(_E) == READY)
    RREADY = (myHero:CanUseSpell(_R) == READY)
    QMana = myHero:GetSpellData(_Q).mana
    WMana = myHero:GetSpellData(_W).mana
    EMana = myHero:GetSpellData(_E).mana
    RMana = myHero:GetSpellData(_R).mana
    MyMana = myHero.mana
    for i=1, EnemysInTable do
       
        local enemy = EnemyTable[i].hero
        if ValidTarget(enemy) and enemy.visible then
            caaDmg = getDmg("AD",enemy,myHero)
            cqDmg = getDmg("Q", enemy, myHero)
            ceDmg = getDmg("E", enemy, myHero)
            ciDmg = getDmg("IGNITE", enemy, myHero)
           
            UltExtraDmg = 0
            cItemDmg = 0
            cTotal = 0
           
            if BCREADY then
                cItemDmg = cItemDmg + getDmg("BWC", enemy, myHero)
            end
            if BOTRKREADY then
                cItemDmg = cItemDmg + getDmg("RUINEDKING", enemy, myHero, 2)
            end
            if HYDRAREADY then
                cItemDmg = cItemDmg + getDmg("HYDRA", enemy, myHero)
            end
            if TIAMATREADY then
                cItemDmg = cItemDmg + getDmg("TIAMAT", enemy, myHero)
            end
           
           
            EnemyTable[i].q = cqDmg
           
            if WillQCol then
                EnemyTable[i].q = EnemyTable[i].q / 2
            end
            EnemyTable[i].q2 = EnemyTable[i].q + (cqDmg / 2)
           
            EnemyTable[i].e = ceDmg
            if RREADY then
                UltExtraDmg = myHero.totalDamage
                if WREADY then
                    UltExtraDmg = UltExtraDmg + (.15*myHero:GetSpellData(_R).level+5) * (EnemyTable[i].q2 + EnemyTable[i].e + EnemyTable[i].p + caaDmg)
                else
                    UltExtraDmg = UltExtraDmg + (.15*myHero:GetSpellData(_R).level+5) * (EnemyTable[i].q + EnemyTable[i].e + EnemyTable[i].p + caaDmg)
                end
                UltExtraDmg = myHero:CalcDamage(enemy, UltExtraDmg)
            end
            EnemyTable[i].r = UltExtraDmg
           
           
            if enemy.health < EnemyTable[i].e then
                EnemyTable[i].IndicatorText = "E Kill"
                EnemyTable[i].IndicatorPos = 0
                if not EReady then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
            elseif enemy.health < EnemyTable[i].q then
                EnemyTable[i].IndicatorText = "Q Kill"
                EnemyTable[i].IndicatorPos = 0
                if not QREADY then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
            elseif enemy.health < EnemyTable[i].q2 then
                EnemyTable[i].IndicatorText = "W+Q Kill"
                EnemyTable[i].IndicatorPos = 0
                if QMana + WMana > MyMana or not QREADY or not WREADY then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
            elseif enemy.health < EnemyTable[i].q2 + EnemyTable[i].e then
                EnemyTable[i].IndicatorText = "W+E+Q Kill"
                EnemyTable[i].IndicatorPos = 0
                if QMana + WMana + EMana > MyMana or not QREADY or not WREADY or not EREADY then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
                elseif enemy.health < EnemyTable[i].q2 + EnemyTable[i].e + caaDmg then
                EnemyTable[i].IndicatorText = "W+E+Q+AA Kill"
                EnemyTable[i].IndicatorPos = 0
                if QMana + WMana + EMana > MyMana or not QREADY or not WREADY or not EREADY then
                EnemyTable[i].NotReady = true
                else
                EnemyTable[i].NotReady = false
                end
            elseif (not RREADY) and enemy.health < EnemyTable[i].q2 + EnemyTable[i].e + caaDmg + ciDmg + cItemDmg then
                EnemyTable[i].IndicatorText = "Use Combo 2"
                EnemyTable[i].IndicatorPos = 0
                if (QMana + WMana + EMana > MyMana) or not QREADY or not WREADY or not EREADY then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
            elseif (not WREADY) and enemy.health < EnemyTable[i].q + EnemyTable[i].e + EnemyTable[i].r + caaDmg + ciDmg + cItemDmg then
                EnemyTable[i].IndicatorText = "Kill Without W"
                EnemyTable[i].IndicatorPos = 0
                if QMana + EMana > MyMana or not QREADY or not EREADY or not RREADY then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
            elseif enemy.health < EnemyTable[i].q2 + EnemyTable[i].e + EnemyTable[i].r + caaDmg + ciDmg + cItemDmg then
                EnemyTable[i].IndicatorText = "Pff All in Kill"
                EnemyTable[i].IndicatorPos = 0
                if QMana + WMana + EMana + RMana > MyMana or not QREADY or not WREADY or not EREADY or not RREADY then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
            else
                cTotal = cTotal + EnemyTable[i].q2 + EnemyTable[i].e + EnemyTable[i].r + caaDmg
               
                HealthLeft = math.round(enemy.health - cTotal)
                PctLeft = math.round(HealthLeft / enemy.maxHealth * 100)
                BarPct = PctLeft / 103 * 100
                EnemyTable[i].Pct = PctLeft
                EnemyTable[i].IndicatorPos = BarPct
                EnemyTable[i].IndicatorText = PctLeft .. "% Harass"
                if not qReady or not wReady or not eReady then
                    EnemyTable[i].NotReady = true
                else
                    EnemyTable[i].NotReady = false
                end
            end
        end
    end
end
--CallBacks--
 
function OnCreateObj(obj)
    if obj.valid and obj.name:find("Zed_Clone_idle.troy") then
        if wUsed and wClone == nil then
            wClone = obj
        elseif rClone == nil then
            rClone = obj
        end
    end
    if obj.valid and obj.name:find("Zed_Base_R_buf_tell.troy") then
        isDead = true
        PrintFloatText(myHero,9,"Dead By Mark")
        PrintAlert("TARGET DEAD!!!", 4, 255, 0, 0)
        PrintAlert("TARGET DEAD!!!", 4, 255, 0, 0)
    end
end
 
function OnDeleteObj(obj)
    if obj.valid and wClone and obj == wClone then
        wUsed = false
        wClone = nil
    elseif obj.valid and rClone and obj == rClone then
        rClone = nil
    end
    if obj.valid and obj.name:find("Zed_Base_R_buf_tell.troy") then
        isDead = false
    end
end
 
function OnProcessSpell(unit, spell)
    if unit.isMe and spell.name == "ZedShadowDash" then
        wUsed = true
        lastW = GetTickCount()
        wCast = true
    end
        --if spell.name:lower():find("dazzle") then
                --CastR()
                --PrintChat("Dodged?")
        --end
end
 
 
function OnAnimation(unit, animationName)
    if unit.isMe and lastAnimation ~= animationName then lastAnimation = animationName end
end
 
--Lagfree Circles by barasia, vadash and viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
    quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
    quality = 2 * math.pi / quality
    radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end
 
function round(num)
    if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
 
function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
    end
end
 
 
function OnDraw()
    if Config.draw.Qdraw then
       
        DrawCircle(myHero.x, myHero.y, myHero.z, 900, ARGB(255,255,0,0))
       
    end
    if Config.draw.Edraw then
        DrawCircle(myHero.x, myHero.y, myHero.z, 290, ARGB(255,255,0,0))
       
    end
   
   
    if Config.draw.DmgIndic then
        for i=1, EnemysInTable, 1 do
            local enemy = EnemyTable[i].hero
            if ValidTarget(enemy) then
                -- enemy.barData = GetEnemyBarData()
                local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
                local PosX = barPos.x - 35
                local PosY = barPos.y - 50
                -- local barPosOffset = GetUnitHPBarOffset(enemy)
                -- local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
                -- local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
                -- local BarPosOffsetX = 171
                -- local BarPosOffsetY = 46
                -- local CorrectionY = 14.5
                -- local StartHpPos = 31
                -- local IndicatorPos = EnemyTable[i].IndicatorPos
                local Text = EnemyTable[i].IndicatorText
                -- barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos
                -- barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY
                if EnemyTable[i].NotReady == true then
                   
                    DrawText(tostring(Text),15,PosX ,PosY ,orange)
                    -- DrawText("|",13,barPos.x+IndicatorPos ,barPos.y ,orange)
                    -- DrawText("|",13,barPos.x+IndicatorPos ,barPos.y-9 ,orange)
                    -- DrawText("|",13,barPos.x+IndicatorPos ,barPos.y-18 ,orange)
                else
                    DrawText(tostring(Text),15,PosX ,PosY ,ARGB(255,0,255,0))
                    -- DrawText("|",13,barPos.x+IndicatorPos ,barPos.y ,ARGB(255,0,255,0))
                    -- DrawText("|",13,barPos.x+IndicatorPos ,barPos.y-9 ,ARGB(255,0,255,0))
                    -- DrawText("|",13,barPos.x+IndicatorPos ,barPos.y-18 ,ARGB(255,0,255,0))
                end
            end
        end
    end
end
 
function GenModelPacket(champ, skinId)
        p = CLoLPacket(0x97)
        p:EncodeF(myHero.networkID)
        p.pos = 1
        t1 = p:Decode1()
        t2 = p:Decode1()
        t3 = p:Decode1()
        t4 = p:Decode1()
        p:Encode1(t1)
        p:Encode1(t2)
        p:Encode1(t3)
        p:Encode1(bit32.band(t4,0xB))
        p:Encode1(1)--hardcode 1 bitfield
        p:Encode4(skinId)
        for i = 1, #champ do
                p:Encode1(string.byte(champ:sub(i,i)))
        end
        for i = #champ + 1, 64 do
                p:Encode1(0)
        end
        p:Hide()
        RecvPacket(p)
end
 
function skinChanged()
        return Config.VIP.skin1 ~= lastSkin
end
 
function OnBugsplat()
        UpdateWeb(false, ScriptName, id, HWID)
end
 
-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 53
ScriptName = "BioZed"
 
-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
