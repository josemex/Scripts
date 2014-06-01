if myHero.charName ~= "Sion" then return end

-- Lib Downloader --

local REQUIRED_LIBS = {
    ["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua",
    ["SOW"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua",
    ["SourceLib"] = "https://raw.githubusercontent.com/TheRealSource/public/master/common/SourceLib.lua",
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

require "VPrediction"
require "SourceLib"
require "SOW"

local VP = nil
local ignite = nil
local qRange, wRange, eRange, rRange = 550, 450, 220, 220
local ts
local Sion = {
	Q = {range = math.huge},
	W = {range = math.huge},
	E = {range = math.huge},
	R = {range = math.huge},
}

JungleFocusMobs = {}
JungleMobs = {}

function OnLoad()
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 550 ,DAMAGE_PHYSICAL)
	ts.name = "Sion"
   VP = VPrediction()
    SOWi = SOW(VP)
    LoadMenu()
    Ignite()
		JungleNames()
		Tick = GetTickCount()
end

function OnTick()
    GlobalInfos()
    ts:update()
    if Config.ComboS.Fight then Fight() end
    if UltimateKey then SionUltimate() end
    if Config.jungle.Clear then
		if GetTickCount() - Tick < 750 then return end
		Tick = GetTickCount()
		JungleClear()
	end
end

function LoadMenu()
     Config = scriptConfig("Sion Get Shrek'd", "Die")
     
     Config:addSubMenu("Sion - Combo Settings", "ComboS")          
        Config.ComboS:addParam("Fight", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.ComboS:addParam("Q", "Use 'Q'", SCRIPT_PARAM_ONOFF, true)
	Config.ComboS:addParam("W", "Use 'W'", SCRIPT_PARAM_ONOFF, true)
	Config.ComboS:addParam("E", "Use 'E'", SCRIPT_PARAM_ONOFF, true)
	Config.ComboS:addParam("UltimateKey", "Enable/Disable Auto-Ultimate: ", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("M"))
	Config.ComboS:addSubMenu("Ultimate Settings", "Ultimate")
	Config.ComboS.Ultimate:addParam("UltimateInfo", "--- Enable/disable Ultimate in Combo ---", SCRIPT_PARAM_INFO, "")
	Config.ComboS.Ultimate:addParam("useUltimateIfLow", "Ultimate if below %: ", SCRIPT_PARAM_ONOFF, false)
	Config.ComboS.Ultimate:addParam("useUltimateIfLowSlider", "Health-%: ", SCRIPT_PARAM_SLICE, 20, 0, 100, -1)
	Config.ComboS.Ultimate:addParam("UltimateInfo", "-----------------------------------------------------", SCRIPT_PARAM_INFO, "")
	Config.ComboS.Ultimate:addParam("useUltimateTowerDive", "Ultimate if below % under tower: ", SCRIPT_PARAM_ONOFF, true)
	Config.ComboS.Ultimate:addParam("useUltimateTowerDiveSlider", "Health-%: ", SCRIPT_PARAM_SLICE, 40, 0, 100, -1)
	Config.ComboS.Ultimate:addParam("UltimateInfo", "-----------------------------------------------------", SCRIPT_PARAM_INFO, "")
	Config.ComboS.Ultimate:addParam("useUltimateEnemy", "Ultimate if x-enemys in range and below %: ", SCRIPT_PARAM_ONOFF, false)
	Config.ComboS.Ultimate:addParam("useUltimateEnemySliderNumber", "Number of enemys: ", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)
	Config.ComboS.Ultimate:addParam("useUltimateEnemySliderHealth", "Health-%: ", SCRIPT_PARAM_SLICE, 60, 0, 100, -1)
	Config.ComboS.Ultimate:addParam("useUltimateEnemySliderRange", "Range for enemys: ", SCRIPT_PARAM_SLICE, 500, 0, 1000, 1)

     Config:addSubMenu("Sion - Jungle Clear", "jungle")
        Config.jungle:addParam("Clear", "Clear Jungle", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        Config.jungle:addParam("AA","Auto Attack in 'Jungle'",1,true)
        Config.jungle:addParam("Q", "Clear with (Q)", 1,true)
		Config.jungle:addParam("W", "Clear with (W)", 1,true)
   
    Config:addSubMenu("Sion - Ignite Settings", "lignite")    
        Config.lignite:addParam("igniteOptions", "Ignite Options", SCRIPT_PARAM_LIST, 2, { "Don't use", "Kill Steal"})
        Config.lignite:permaShow("igniteOptions")

    Config:addSubMenu("Sion - Misc Settings", "misc")
        Config.misc:addParam("autoPotions", "Use potions when HP < %", SCRIPT_PARAM_SLICE, 15, 2, 100, 0)
        Config.misc:addParam("KillSteal", "KillSteal With Q", SCRIPT_PARAM_ONOFF, true)
        Config.misc:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	    Config.misc:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	    Config.misc:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu("Sion - Orbwalking", "Orbwalking")
        SOWi:LoadToMenu(Config.Orbwalking)
       
    Config.ComboS:permaShow("Fight")
    Config:addTS(ts)
end

PrintChat("<font color=\"#FF0000\" >>> Sion By Lucas v 0.1<</font> ")

function autoPotions()
	if Config.misc.autoPotions then
		if tickPotions == nil or (GetTickCount() - tickPotions > 1000) then
			PotionSlot = GetInventorySlotItem(2003)
			if PotionSlot ~= nil then --we have potions
				if (myHero.health / myHero.maxHealth * 100) <= Config.misc.autoPotions and not TargetHaveBuff("RegenerationPotion", myHero) and not InFountain() then
					CastSpell(PotionSlot)
				end
			end
			tickPotions = GetTickCount()
		end
	end
end

function autoIgnite()
        if Config.lignite.igniteOptions == 2 then
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

function Ignite()
        if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
        elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2
        end
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
                if GetDistance(ts.target) <= 350 then
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

function KillSteal()
	qDmg = getDmg(_Q, Target, myHero)
    if Config.misc.KillSteal then
        if Target.health < qDmg then
        	if GetDistance(Target, QRange) then
        		if QREADY then
            		CastSpell(_Q, Target)
            	end
            end
        end
    end
end

function Fight()
	if ValidTarget(ts.target) then
	    CastItems(ts.target)
	end 
	if QREADY and ValidTarget(ts.target, qRange) and Config.ComboS.Q then
		CastSpell(_Q, ts.target)
	end

	if WREADY and ValidTarget(ts.target, wRange) and Config.ComboS.W then
		CastSpell(_W)
	end

	if EREADY and ValidTarget(ts.target, eRange) and Config.ComboS.E then
		CastSpell(_E)
	end
end

function SionUltimate()
if not RREADY then return end
		if Config.ComboS.Ultimate.useUltimateIfLow
			then 
				if RREADY and myHero.health < (myHero.maxHealth * (Config.ComboS.Ultimate.useUltimateIfLowSlider/100))
					then CastSpell(_R)
				end
		end
		if Config.ComboS.Ultimate.useUltimateTowerDive
			then
				if CountEnemyHeroInRange(1000) > 0 and UnitAtTower(myHero) and RREADY and myHero.health < (myHero.maxHealth * (Config.ComboS.Ultimate.useUltimateTowerDiveSlider/100))
					then CastSpell(_R)
				end
		end	
		if Config.ComboS.Ultimate.useUltimateEnemy
			then
				if RREADY and CountEnemyHeroInRange(Config.ComboS.Ultimate.useUltimateEnemySliderRange) >= Config.ComboS.Ultimate.useUltimateEnemySliderNumber and myHero.health < (myHero.maxHealth * (Config.ComboS.Ultimate.useUltimateEnemySliderHealth/100))
					then CastSpell(_R)
				end
		end
end

function JungleNames()
	JungleMobNames =
{
	-- Blue Side --
		-- Blue Buff --
		["YoungLizard1.1.2"] = true, ["YoungLizard1.1.3"] = true,
		-- Red Buff --
		["YoungLizard4.1.2"] = true, ["YoungLizard4.1.3"] = true,
		-- Wolf Camp --
		["wolf2.1.2"] = true, ["wolf2.1.3"] = true,
		-- Wraith Camp --
		["LesserWraith3.1.2"] = true, ["LesserWraith3.1.3"] = true, ["LesserWraith3.1.4"] = true,
		-- Golem Camp --
		["SmallGolem5.1.1"] = true,
	-- Purple Side --
		-- Blue Buff --
		["YoungLizard7.1.2"] = true, ["YoungLizard7.1.3"] = true,
		-- Red Buff --
		["YoungLizard10.1.2"] = true, ["YoungLizard10.1.3"] = true,
		-- Wolf Camp --
		["wolf8.1.2"] = true, ["wolf8.1.3"] = true,
		-- Wraith Camp --
		["LesserWraith9.1.2"] = true, ["LesserWraith9.1.3"] = true, ["LesserWraith9.1.4"] = true,
		-- Golem Camp --
		["SmallGolem11.1.1"] = true,
}
-- FocusJungleNames are the names of the important/big Junglemobs --
	FocusJungleNames =
{
	-- Blue Side --
		-- Blue Buff --
		["AncientGolem1.1.1"] = true,
		-- Red Buff --
		["LizardElder4.1.1"] = true,
		-- Wolf Camp --
		["GiantWolf2.1.1"] = true,
		-- Wraith Camp --
		["Wraith3.1.1"] = true,		
		-- Golem Camp --
		["Golem5.1.2"] = true,		
		-- Big Wraith --
		["GreatWraith13.1.1"] = true, 
	-- Purple Side --
		-- Blue Buff --
		["AncientGolem7.1.1"] = true,
		-- Red Buff --
		["LizardElder10.1.1"] = true,
		-- Wolf Camp --
		["GiantWolf8.1.1"] = true,
		-- Wraith Camp --
		["Wraith9.1.1"] = true,
		-- Golem Camp --
		["Golem11.1.2"] = true,
		-- Big Wraith --
		["GreatWraith14.1.1"] = true,
	-- Dragon --
		["Dragon6.1.1"] = true,
	-- Baron --
		["Worm12.1.1"] = true,
}
end
function JungleClear()
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil then
			if FocusJungleNames[object.name] then
				table.insert(JungleFocusMobs, object)
			elseif JungleMobNames[object.name] then
				table.insert(JungleMobs, object)
			end
		end
	end
	local JungleMob = GetJungleMob()
	if JungleMob ~= nil then
		if Config.jungle.AA then
			myHero:Attack(JungleMob)
		end
		if Config.jungle.Q and QREADY then
			CastSpell(_Q, JungleMob)
		end
		if Config.jungle.W and WREADY then
			CastSpell(_W)
		end
	end
end
function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, Sion.Q["range"]) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, Sion.Q["range"]) then return Mob end
	end
end

function UnitAtTower(unit)
	for i, turret in pairs(GetTurrets()) do
		if turret ~= nil then
			if turret.team ~= myHero.team then
				if GetDistance(unit, turret) <= turret.range then
					return true
				end
			end
		end
	end
	return false
end

function OnDraw()
	if Config.misc.drawAA then
		DrawCircle(myHero.x, myHero.y, myHero.z, 250, 0x111111)
	end		
	
	if Config.misc.drawQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x111111)
	end
	
	if Config.misc.drawW then
		DrawCircle(myHero.x, myHero.y, myHero.z, wRange, 0x111111)
	end
end

function KeyBindings()
	UltimateKey = Config.ComboS.UltimateKey
end
