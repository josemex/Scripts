require "Collision"
require "Prodiction"

if myHero.charName ~= "Nidalee" then return end

local Prodict = ProdictManager.GetInstance()
local ProdictQ
local ProdictQCol

local ts = {}
local NidaleeConfig = {}
--SHARED--
local function getHitBoxRadius(target)
	return GetDistance(target, target.minBBox)
	--return GetDistance(target.minBBox, target.maxBBox)/4
end
--END SHARED--


local function CastQ(unit, pos, spell)
	if GetDistance(pos) - getHitBoxRadius(unit)/2 < 1450 and myHero:GetSpellData(_Q).name == "JavelinToss" then
		local willCollide = ProdictQCol:GetMinionCollision(pos, myHero)
		if not willCollide then 
		CastSpell(_Q, pos.x, pos.z)
		end
	end
end

function OnLoad()

	ts = TargetSelector(TARGET_LESS_CAST, 1450, DAMAGE_MAGIC)
	NidaleeConfig = scriptConfig("Nida Lisa", "NidaleeAdv")
	local HK = string.byte("X")
	NidaleeConfig:addParam("Q", "Cast Q", SCRIPT_PARAM_ONKEYDOWN, false, HK)
	NidaleeConfig:addParam("Movement", "Move To Mouse", SCRIPT_PARAM_ONOFF, true)
	NidaleeConfig:addTS(ts)
	
	ts.name = "Nida Lisa"
	
	ProdictQ = Prodict:AddProdictionObject(_Q, 1450, 1300, 0.125, 37, myHero, CastQ)
	ProdictQCol = Collision(1450, 1300, 0.125, 37)
	for I = 1, heroManager.iCount do
		local hero = heroManager:GetHero(I)
		if hero.team ~= myHero.team then
		
			ProdictQ:CanNotMissMode(true, hero)
		end
	end
end

PrintChat("<font color=\"#FF0000\" >>The Nida Lisa by Da Vinci <</font> ")

function OnTick()
	ts:update()
	if ts.target == nil and NidaleeConfig.Q and NidaleeConfig.Movement then
                myHero:MoveTo(mousePos.x, mousePos.z)
  end
	
	if ts.target ~= nil and NidaleeConfig.Q then
		ProdictQ:EnableTarget(ts.target, true)
	end
end


