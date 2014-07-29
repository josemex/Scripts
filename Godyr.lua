if myHero.charName ~= "Udyr" then return end

--Auto Download Required LIBS

local REQUIRED_LIBS = {
		["VPrediction"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua",
		["SOW"] = "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua",
		["SourceLib"] = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua",
		["Selector"] = "http://iuser99.com/scripts/Selector.lua",

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
local version = 1.1
local scriptName = "Godyr"

-- Change autoUpdate to false if you wish to not receive auto updates.
-- Change silentUpdate to true if you wish not to receive any message regarding updates
local autoUpdate   = true
local silentUpdate = false



require "VPrediction"
require "SourceLib"
require "SOW"

local VP = nil
local levelSequence = {4,1,3,4,4,3,4,3,4,3,3,1,1,1,1,2,2,2} 
local levelSequence2 = {1,2,3,1,1,3,1,3,1,3,3,2,2,2,2,4,4,4}
local ignite = nil
local stunTarget = nil
local lastCast = "none"
local lastSkin = 0
local AAcount = 0
local lastNameTarget = myHero.name
local UdyrConfig, ts
local qRange, wRange, eRange, rRange = 200, 200, 200, 200
local     orange = 0xFFFFE303
local green = ARGB(255,0,255,0)
local blue = ARGB(255,0,0,255)
local red = ARGB(255,255,0,0)
--local enemyMinions = minionManager(MINION_ENEMY, 600, myHero.visionPos, MINION_SORT_HEALTH_ASC)
local Udyr = {
	Q = {range = math.huge},
	W = {range = math.huge},
	E = {range = math.huge},
	R = {range = 200}
}

JungleFocusMobs = {}
JungleMobs = {}



function OnLoad()
	 ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 600 ,DAMAGE_PHYSICAL)
   ts.name = "Udyr"
	UpdateWeb(true, ScriptName, id, HWID)
   VP = VPrediction()
   SOWi = SOW(VP)
   LoadMenu()
   JungleNames()
   Selector.Instance()
	Tick = GetTickCount()
   Ignite()
	JMinions = minionManager(MINION_JUNGLE, qRange, myHero)
   PrintFloatText(myHero, 11, "LETS DISRESPECT!")
end

function OnUnload()
	UpdateWeb(false, ScriptName, id, HWID)
end

function OnTick()
	ts:update()
	if Config.VIP.skin and skinChanged() then
		GenModelPacket("Udyr", Config.VIP.skin1)
		lastSkin = Config.VIP.skin1
	end
    JMinions:update()
    GlobalInfos()
    if Config.misc.spame then
    	CastSpell(_E)
    end
		if Config.ComboS.RunNStun then RunNStun() end
		if Config.ComboS.StunCycle then StunCycle() end
		--if Config.lane.laneclear then laneclear() end
    if ts.target and Config.ComboS.RunNStun then
                myHero:MoveTo(mousePos.x, mousePos.z)
        end
    if Config.ComboS.Fight then Fight() end
    if Config.jungle.Clear then
		if GetTickCount() - Tick < 750 then return end
		Tick = GetTickCount()
		JungleClear()
	end

		if Config.misc.autoLevel  == 2 then
		autoLevelSetSequence(levelSequence)
		elseif Config.misc.autoLevel  == 3 then
			autoLevelSetSequence(levelSequence2)
	end
	end



function LoadMenu()
     Config = scriptConfig("Godyr My Way", "Die")
     
     Config:addSubMenu("Godyr - Combo Settings", "ComboS")          
        Config.ComboS:addParam("Fight", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	    Config.ComboS:addParam("StunCycle", "Stun Everyone Around", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	    Config.ComboS:addParam("RunNStun", "Run and Stun", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))

    Config:addSubMenu("Godyr - Jungle Clear", "jungle")
        Config.jungle:addParam("Clear", "Clear Jungle", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        Config.jungle:addParam("AA","Auto Attack in 'Jungle'",1,true)
        Config.jungle:addParam("Q", "Clear with (Q)", 1,true)
		Config.jungle:addParam("W", "Clear with (W)", 1,true)
		Config.jungle:addParam("E", "Clear with (E)", 1,true)
		Config.jungle:addParam("R", "Clear with (R)", 1,true)
   
    Config:addSubMenu("Godyr - Ignite Settings", "lignite")    
        Config.lignite:addParam("igniteOptions", "Ignite Options", SCRIPT_PARAM_LIST, 2, { "Don't use", "Kill Steal"})

    Config:addSubMenu("Godyr - Misc Settings", "misc")
        Config.misc:addParam("autoPotions", "Use potions when HP < %", SCRIPT_PARAM_SLICE, 15, 2, 100, 0)
		Config.misc:addParam("autoLevel", "Auto Level", SCRIPT_PARAM_LIST, 1, { "Don't use", "Godyr", "Tigerdyr"})
		Config.misc:addParam("draw", "Draw Range", SCRIPT_PARAM_ONOFF, false)
		Config.misc:addParam("spame", "Marathon Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("M"))

    Config:addSubMenu("Godyr - Skin Changer", "VIP")
		Config.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
		Config.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 7)
		
    Config:addSubMenu("BioZed - Target Selector","TS")
        Config.TS:addParam("TS","Target Selector",7,2,{ "AllClass", "Selector"})

    Config:addSubMenu("Godyr - Orbwalking", "Orbwalking")
        SOWi:LoadToMenu(Config.Orbwalking)
       Config:addTS(ts)
end

PrintChat("<font color=\"#FF0000\" >>> Godyr By Lucas v 1.1 <</font> ")

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
			CastSpell(_Q)
		end
		if Config.jungle.W and WREADY then
			CastSpell(_W)
		end
		if Config.jungle.E and EREADY then
			CastSpell(_E)
		end
		if Config.jungle.R and RREADY then
			CastSpell(_R)
		end
	end
end
function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, Udyr.R["range"]) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, Udyr.R["range"]) then return Mob end
	end
end

function laneclear()
if Config.lane.laneclear then
	enemyMinions:update()
			for _, minion in pairs(enemyMinions.objects) do
				if  ValidTarget(minion) then
					if Config.jungle.AA then
			myHero:Attack(enemyMinion)
		end
		if Config.lane.Q and QREADY then
			CastSpell(_Q)
		end
		if Config.lane.W and WREADY then
			CastSpell(_W)
		end
		if Config.lane.E and EREADY then
			CastSpell(_E)
		end
		if Config.lane.R and RREADY then
			CastSpell(_R)
		end
	end
end
end
end

function RunNStun()
	if Config.ComboS.RunNStun then
  stunTarget = findClosestEnemy()
		if EREADY then
				CastSpell(_E)
			end
		if stunTarget ~= nil and GetDistance(stunTarget) <= 600 then
			myHero:Attack(stunTarget)
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
ScriptName = "Godyr"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
