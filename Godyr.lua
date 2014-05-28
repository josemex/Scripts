if myHero.charName ~= "Udyr" then return end

--Auto Download Required LIBS

local REQUIRED_LIBS = {
		["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua",
		["SOW"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua",
		["SourceLib"] = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua",

}

local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
local SELF_NAME = GetCurrentEnv() and GetCurrentEnv().FILE_NAME or ""

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b>[Udyr]: Required libraries downloaded successfully, please reload (double F9).</b>")
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

if DOWNLOADING_LIBS then return end
--End auto downloading LIBS

require "VPrediction"
require "SourceLib"
require "SOW"

local VP = nil
local levelSequence = {4,1,3,4,4,3,4,3,4,3,3,1,1,1,1,2,2,2} 
local ignite = nil
local stunTarget = nil
local lastCast = "none"
local AAcount = 0
local lastNameTarget = myHero.name
local UdyrConfig, ts
local qRange, wRange, eRange, rRange = 200, 200, 200, 200

function OnLoad()
   ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 600 ,DAMAGE_PHYSICAL)
   ts.name = "Udyr"
   VP = VPrediction()
   SOWi = SOW(VP)
   LoadMenu()
   Ignite()
   EnemyMinions = minionManager(MINION_ENEMY, 600, myHero, MINION_SORT_HEALTH_ASC)
	 JMinions = minionManager(MINION_JUNGLE, qRange, myHero)
   PrintFloatText(myHero, 11, "LETS DISRESPECT!")
end

function OnTick()
    JMinions:update()
    GlobalInfos()
    ts:update()
    if Config.ComboS.Fight then Fight() end
		if Config.misc.autoLevel then
		autoLevelSetSequence(levelSequence)
		
		if Config.jungle.Clear then
	 	for i, minion in pairs(JMinions.objects) do
			if minion and minion.valid and not minion.dead and (GetDistance(minion) <= 200) then
				myHero:Attack(minion)
		if Config.jungle.jungleQ and GetDistance(minion) <= qRange then CastSpell(_Q)  end
		if Config.jungle.jungleW and GetDistance(minion) <= wRange then CastSpell(_W)  end
		if Config.jungle.jungleE and GetDistance(minion) <= eRange then CastSpell(_E)  end
		if Config.jungle.jungleR and GetDistance(minion) <= rRange then CastSpell(_R)  end
			end
		end
	end
	end
end


function LoadMenu()
     Config = scriptConfig("Godyr My Way", "Die")
     
     Config:addSubMenu("Godyr - Combo Settings", "ComboS")          
        Config.ComboS:addParam("Fight", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	    Config.ComboS:addParam("StunCycle", "Stun Everyone Around", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

    Config:addSubMenu("Godyr - Jungle Clear", "jungle")
        Config.jungle:addParam("Clear", "Clear Jungle", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        Config.jungle:addParam("jungleQ", "Clear with (Q)", SCRIPT_PARAM_ONOFF, true)
		Config.jungle:addParam("jungleW", "Clear with (W)", SCRIPT_PARAM_ONOFF, false)
		Config.jungle:addParam("jungleE", "Clear with (E)", SCRIPT_PARAM_ONOFF, false)
		Config.jungle:addParam("jungleR", "Clear with (R)", SCRIPT_PARAM_ONOFF, true)
   
    Config:addSubMenu("Godyr - Ignite Settings", "lignite")    
        Config.lignite:addParam("igniteOptions", "Ignite Options", SCRIPT_PARAM_LIST, 2, { "Don't use", "Kill Steal"})
        Config.lignite:permaShow("igniteOptions")

    Config:addSubMenu("Godyr - Misc Settings", "misc")
        Config.misc:addParam("autoPotions", "Use potions when HP < %", SCRIPT_PARAM_SLICE, 15, 2, 100, 0)
	Config.misc:addParam("autoLevel", "Auto level spells R+E+Q+W", SCRIPT_PARAM_ONOFF, false)			
	Config.misc:addParam("draw", "Draw Range", SCRIPT_PARAM_ONOFF, false)

    Config:addSubMenu("Godyr - Orbwalking", "Orbwalking")
        SOWi:LoadToMenu(Config.Orbwalking)
       
    Config.ComboS:permaShow("Fight")
    Config:addTS(ts)
end

PrintChat("<font color=\"#FF0000\" >>>Godyr By Lucas v 0.1<</font> ")

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

function Fight()
  if myHero:GetSpellData(_Q).level >= 1 and myHero:GetSpellData(_W).level >= 1 and myHero:GetSpellData(_E).level >= 1 and myHero:GetSpellData(_R).level >= 1 then
			if EREADY and TargetHaveBuff("udyrbearstuncheck", ts.target) == false then
				CastSpell(_E)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and QREADY then
				CastSpell(_Q)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and RREADY then
				CastSpell(_R)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and WREADY then
				CastSpell(_W)
			end

		elseif myHero:GetSpellData(_W).level >= 1 and myHero:GetSpellData(_E).level >= 1 and myHero:GetSpellData(_R).level >= 1 and myHero:GetSpellData(_Q).level == 0 then
			if EREADY and TargetHaveBuff("udyrbearstuncheck", ts.target) == false then
				CastSpell(_E)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and RREADY then
				CastSpell(_R)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and WREADY then
				CastSpell(_W)
			end

		elseif myHero:GetSpellData(_W).level >= 1 and myHero:GetSpellData(_E).level >= 1 and myHero:GetSpellData(_Q).level >= 1 and myHero:GetSpellData(_R).level == 0 then
			if EREADY and TargetHaveBuff("udyrbearstuncheck", ts.target) == false then
				CastSpell(_E)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and QREADY then
				CastSpell(_Q)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and WREADY then
				CastSpell(_W)
			end

		elseif myHero:GetSpellData(_W).level >= 1 and myHero:GetSpellData(_E).level == 0 and myHero:GetSpellData(_Q).level >= 1 and myHero:GetSpellData(_R).level >= 1 then
			if QREADY then
				CastSpell(_Q)
			elseif WREADY then
				CastSpell(_W)
			elseif RREADY then
				CastSpell(_R)
			end

		elseif myHero:GetSpellData(_W).level == 0 and myHero:GetSpellData(_E).level >= 1 and myHero:GetSpellData(_R).level >= 1 and myHero:GetSpellData(_Q).level == 0 then
			if EREADY and TargetHaveBuff("udyrbearstuncheck", ts.target) == false then
				CastSpell(_E)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and RREADY then
				CastSpell(_R)
			end

		elseif myHero:GetSpellData(_W).level == 0 and myHero:GetSpellData(_E).level >=1 and myHero:GetSpellData(_Q).level >= 1 and myHero:GetSpellData(_R).level >= 1 then
			if EREADY and TargetHaveBuff("udyrbearstuncheck", ts.target) == false then
				CastSpell(_E)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and QREADY then
				CastSpell(_Q)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and RREADY then
				CastSpell(_R)
			end

		elseif myHero:GetSpellData(_W).level >= 1 and myHero:GetSpellData(_R).level >= 1 and myHero:GetSpellData(_Q).level == 0 and myHero:GetSpellData(_E).level == 0 then
			if RREADY then
				CastSpell(_R)
			elseif WREADY then
				CastSpell(_W)
			end

		elseif myHero:GetSpellData(_W).level == 0 and myHero:GetSpellData(_R).level == 0 and myHero:GetSpellData(_Q).level >= 1 and myHero:GetSpellData(_E).level >= 1 then
			if EREADY and TargetHaveBuff("udyrbearstuncheck", ts.target) == false then
				CastSpell(_E)
			elseif TargetHaveBuff("udyrbearstuncheck", ts.target) == true and QREADY then
				CastSpell(_Q)
			end

		elseif (myHero:GetSpellData(_Q).level >= 1 or myHero:GetSpellData(_R).level >= 1) and myHero:GetSpellData(_W).level == 0 and myHero:GetSpellData(_E).level == 0 then
			if QREADY then CastSpell(_Q) end
			if RREADY then CastSpell(_R) end
		end
		CastItems(ts.target)
	end

function StunCycle()
	if Config.ComboS.StunCycle then
		stunTarget = findClosestEnemy()
		if stunTarget ~= nil and GetDistance(stunTarget) <= 600 then
			if EREADY then
				CastSpell(_E)
			end
			myHero:Attack(stunTarget)
		end
	end
end

function findClosestEnemy()
	local closestEnemy = nil
	local currentEnemy = nil
	for i=1, heroManager.iCount do
		currentEnemy = heroManager:GetHero(i)
		if ValidTarget(currentEnemy, 600) then
			if closestEnemy == nil then
				closestEnemy = currentEnemy
			elseif GetDistance(currentEnemy) < GetDistance(closestEnemy) then
				closestEnemy = currentEnemy
			end
		end
	end
	return closestEnemy
end

function ResetAACount()
if ts.target ~= nil then
		if ts.target.name ~= lastNameTarget then
			lastNameTarget = ts.target.name
			AAcount = 0
			lastCast = "none"
		end
	else
		AAcount = 0
		lastCast = "none"
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

function ArrangePrioritys()
    for i, target in pairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.AD_Carry, target, 1)
        SetPriority(priorityTable.AP, target, 2)
        SetPriority(priorityTable.Support, target, 3)
        SetPriority(priorityTable.Bruiser, target, 4)
        SetPriority(priorityTable.Tank, target, 5)
    end
end

function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end
    end
end

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
	if not myHero.dead and Config.misc.draw then
		if ts.target ~= nil then
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, 150, 0x7A24DB)
		end
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0xC2743C)
	end
end
