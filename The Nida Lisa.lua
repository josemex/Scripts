if myHero.charName ~= "Nidalee" then return end


require "Collision"
require "Prodiction"

local Prodict = ProdictManager.GetInstance()
local ProdictQ
local ProdictQCol
local ignite = nil
local ts = {}
local NidaleeConfig = {}

local function getHitBoxRadius(target)
	return GetDistance(target, target.minBBox)
end

local function CastQ(unit, pos, spell)
	if GetDistance(pos) - getHitBoxRadius(unit)/2 < 1500 and myHero:GetSpellData(_Q).name == "JavelinToss" then
		local willCollide = ProdictQCol:GetMinionCollision(pos, myHero)
		if not willCollide then CastSpell(_Q, pos.x, pos.z) end
	end
end

function OnLoad()

	ts = TargetSelector(TARGET_LESS_CAST, 1500, DAMAGE_MAGIC)
	NidaleeConfig = scriptConfig("Da Vinci's Nidalee", "NidaleeAdv")
	NidaleeConfig:addParam("Q", "Cast Q", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	NidaleeConfig:addParam("AutoIgnite", "KillSteal Ignite",  SCRIPT_PARAM_ONOFF, true)
	NidaleeConfig:addParam("sbtwHealSlider", "Auto Heal if Health below %: ",  SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
	NidaleeConfig:addTS(ts)
	
	ts.name = "Da Vinci's Nidalee"
	
	ProdictQ = Prodict:AddProdictionObject(_Q, 1500, 1300, 0.125, 30, myHero, CastQ)
	ProdictQCol = Collision(1500, 1300, 0.125, 30)
	for I = 1, heroManager.iCount do
		local hero = heroManager:GetHero(I)
		if hero.team ~= myHero.team then
			ProdictQ:CanNotMissMode(true, hero)
		end
	end
end
PrintChat("<font color=\"#FF0000\" >> The Nida Lisa by Da Vinci <</font> ")
function OnTick()
	GlobalInfos()
	ts:update()
	if ts.target ~= nil and NidaleeConfig.Q then
		ProdictQ:EnableTarget(ts.target, true)
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
        DrawCircleNextLvl(x, y, z, radius, 1, color, Menu.Draw.LFC.CL) 
    end
end

function OnDraw()
	if ts.target ~= nil then
		local dist = getHitBoxRadius(ts.target)/2
		DrawCircle(myHero.x, myHero.y, myHero.z, 1500, 0x7F006E)
		if GetDistance(ts.target) - dist < 1500 then
			DrawCircle(ts.target.x, ts.target.y, ts.target.z, dist, 0x7F006E)
		end
	end
end

function UseSelfHeal()
    if myHero.health < (myHero.maxHealth *(NidaleeConfig.sbtwHealSlider/100)) and EREADY then
            CastSpell(_E, myHero)
    end
end

function Ignite()
        if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
        elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2
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
       
        IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
        end

function AutoIgnite(enemy)
        if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
            then
                if IREADY then CastSpell(ignite, enemy) end
        end
end
