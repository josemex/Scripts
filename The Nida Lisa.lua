	if myHero.charName ~= "Nidalee" then return end

	--Auto Download Required LIBS

	local REQUIRED_LIBS = {
			["SOW"] = "https://raw.github.com/honda7/BoL/master/Common/SOW.lua",
			["SourceLib"] = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua",

	}

	local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
	local SELF_NAME = GetCurrentEnv() and GetCurrentEnv().FILE_NAME or ""

	function AfterDownload()
		DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
		if DOWNLOAD_COUNT == 0 then
			DOWNLOADING_LIBS = false
			print("<b>[Nidalee]: Required libraries downloaded successfully, please reload (double F9).</b>")
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


	require "Collision"
	require "Prodiction"
	require "SourceLib"
	require "SOW"
	require "VPrediction"

	local Prodict = ProdictManager.GetInstance()
	local ProdictQ
	local ProdictQCol
	local VP = nil
	local ignite = nil
	local ts = {}
	local Q, NidaleeConfig
local SRadius = 180
local DRadius = 100
local SRadiusSqr = SRadius * SRadius
local RecordLocations = false
local RecordedLocations = {}
local DrawS = {myHero.charName, 'Flash'}


local JumpSlot = 
{
	['Nidalee'] = _W,

}

local JumpSpots = 
{
	

	['Nidalee'] = 
	{
		{From = Vector(6478.0454101563, -64.045028686523, 8342.501953125),  To = Vector(6751, 56.019004821777, 8633), CastPos = Vector(6751, 56.019004821777, 8633)},
		{From = Vector(6447, 56.018882751465, 8663),  To = Vector(6413, -62.786361694336, 8289), CastPos = Vector(6413, -62.786361694336, 8289)},
		{From = Vector(6195.8334960938, -65.304061889648, 8559.810546875),  To = Vector(6327, 56.517200469971, 8913), CastPos = Vector(6327, 56.517200469971, 8913)},
		{From = Vector(7095, 56.018997192383, 8763),  To = Vector(7337, 55.616943359375, 9047), CastPos = Vector(7337, 55.616943359375, 9047)},
		{From = Vector(7269, 55.611968994141, 9055),  To = Vector(7027, 56.018997192383, 8767), CastPos = Vector(7027, 56.018997192383, 8767)},
		{From = Vector(5407, 55.045528411865, 10095),  To = Vector(5033, -63.082427978516, 10119), CastPos = Vector(5033, -63.082427978516, 10119)},
		{From = Vector(5047, -63.08129119873, 10113),  To = Vector(5423, 55.007797241211, 10109), CastPos = Vector(5423, 55.007797241211, 10109)},
		{From = Vector(4747, -62.445854187012, 9463),  To = Vector(4743, -63.093593597412, 9837), CastPos = Vector(4743, -63.093593597412, 9837)},
		{From = Vector(4769, -63.086654663086, 9677),  To = Vector(4775, -63.474864959717, 9301), CastPos = Vector(4775, -63.474864959717, 9301)},
		{From = Vector(6731, -64.655540466309, 8089),  To = Vector(7095, 56.051624298096, 8171), CastPos = Vector(7095, 56.051624298096, 8171)},
		{From = Vector(7629.0434570313, 55.042400360107, 9462.6982421875),  To = Vector(8019, 53.530429840088, 9467), CastPos = Vector(8019, 53.530429840088, 9467)},
		{From = Vector(7994.2685546875, 53.530174255371, 9477.142578125),  To = Vector(7601, 55.379856109619, 9441), CastPos = Vector(7601, 55.379856109619, 9441)},
		{From = Vector(6147, 54.117427825928, 11063),  To = Vector(6421, 54.63500213623, 10805), CastPos = Vector(6421, 54.63500213623, 10805)},
		{From = Vector(5952.1977539063, 54.240119934082, 11382.287109375),  To = Vector(5889, 39.546829223633, 11773), CastPos = Vector(5889, 39.546829223633, 11773)},
		{From = Vector(6003.1401367188, 39.562377929688, 11827.516601563),  To = Vector(6239, 54.632926940918, 11479), CastPos = Vector(6239, 54.632926940918, 11479)},
		{From = Vector(3947, 51.929698944092, 8013),  To = Vector(3647, 54.027297973633, 7789), CastPos = Vector(3647, 54.027297973633, 7789)},
		{From = Vector(1597, 54.923656463623, 8463),  To = Vector(1223, 50.640468597412, 8455), CastPos = Vector(1223, 50.640468597412, 8455)},
		{From = Vector(1247, 50.737510681152, 8413),  To = Vector(1623, 54.923782348633, 8387), CastPos = Vector(1623, 54.923782348633, 8387)},
		{From = Vector(2440.49609375, 53.364398956299, 10038.1796875),  To = Vector(2827, -64.97053527832, 10205), CastPos = Vector(2827, -64.97053527832, 10205)},
		{From = Vector(2797, -65.165946960449, 10213),  To = Vector(2457, 53.364398956299, 10055), CastPos = Vector(2457, 53.364398956299, 10055)},
		{From = Vector(2797, 53.640556335449, 9563),  To = Vector(3167, -63.810096740723, 9625), CastPos = Vector(3167, -63.810096740723, 9625)},
		{From = Vector(3121.9699707031, -63.448329925537, 9574.16015625),  To = Vector(2755, 53.722351074219, 9409), CastPos = Vector(2755, 53.722351074219, 9409)},
		{From = Vector(3447, 55.021110534668, 7463),  To = Vector(3581, 54.248985290527, 7113), CastPos = Vector(3581, 54.248985290527, 7113)},
		{From = Vector(3527, 54.452239990234, 7151),  To = Vector(3372.861328125, 55.13143157959, 7507.2211914063), CastPos = Vector(3372.861328125, 55.13143157959, 7507.2211914063)},
		{From = Vector(2789, 55.241321563721, 6085),  To = Vector(2445, 60.189605712891, 5941), CastPos = Vector(2445, 60.189605712891, 5941)},
		{From = Vector(2573, 60.192783355713, 5915),  To = Vector(2911, 55.503971099854, 6081), CastPos = Vector(2911, 55.503971099854, 6081)},
		{From = Vector(3005, 55.631782531738, 5797),  To = Vector(2715, 60.190528869629, 5561), CastPos = Vector(2715, 60.190528869629, 5561)},
		{From = Vector(2697, 60.190807342529, 5615),  To = Vector(2943, 55.629695892334, 5901), CastPos = Vector(2943, 55.629695892334, 5901)},
		{From = Vector(3894.1960449219, 53.4684715271, 7192.3720703125),  To = Vector(3641, 54.714691162109, 7495), CastPos = Vector(3641, 54.714691162109, 7495)},
		{From = Vector(3397, 55.605663299561, 6515),  To = Vector(3363, 53.412925720215, 6889), CastPos = Vector(3363, 53.412925720215, 6889)},
		{From = Vector(3347, 53.312397003174, 6865),  To = Vector(3343, 55.605716705322, 6491), CastPos = Vector(3343, 55.605716705322, 6491)},
		{From = Vector(3705, 53.67945098877, 7829),  To = Vector(4009, 51.996047973633, 8049), CastPos = Vector(4009, 51.996047973633, 8049)},
		{From = Vector(7581, -65.361351013184, 5983),  To = Vector(7417, 54.716590881348, 5647), CastPos = Vector(7417, 54.716590881348, 5647)},
		{From = Vector(7495, 53.744125366211, 5753),  To = Vector(7731, -64.48851776123, 6045), CastPos = Vector(7731, -64.48851776123, 6045)},
		{From = Vector(7345, -52.344753265381, 6165),  To = Vector(7249, 55.641929626465, 5803), CastPos = Vector(7249, 55.641929626465, 5803)},
		{From = Vector(7665.0073242188, 54.999004364014, 5645.7431640625),  To = Vector(7997, -62.778995513916, 5861), CastPos = Vector(7997, -62.778995513916, 5861)},
		{From = Vector(7995, -61.163398742676, 5715),  To = Vector(7709, 56.321662902832, 5473), CastPos = Vector(7709, 56.321662902832, 5473)},
		{From = Vector(8653, 55.073780059814, 4441),  To = Vector(9027, -61.594711303711, 4425), CastPos = Vector(9027, -61.594711303711, 4425)},
		{From = Vector(8931, -62.612571716309, 4375),  To = Vector(8557, 55.506855010986, 4401), CastPos = Vector(8557, 55.506855010986, 4401)},
		{From = Vector(8645, 55.960289001465, 4115),  To = Vector(9005, -63.280235290527, 4215), CastPos = Vector(9005, -63.280235290527, 4215)},
		{From = Vector(8948.08203125, -63.252712249756, 4116.5078125),  To = Vector(8605, 56.22159576416, 3953), CastPos = Vector(8605, 56.22159576416, 3953)},
		{From = Vector(9345, 67.37971496582, 2815),  To = Vector(9375, 67.509948730469, 2443), CastPos = Vector(9375, 67.509948730469, 2443)},
		{From = Vector(9355, 67.649841308594, 2537),  To = Vector(9293, 63.953853607178, 2909), CastPos = Vector(9293, 63.953853607178, 2909)},
		{From = Vector(8027, 56.071315765381, 3029),  To = Vector(8071, 54.276405334473, 2657), CastPos = Vector(8071, 54.276405334473, 2657)},
		{From = Vector(7995.0229492188, 54.276401519775, 2664.0703125),  To = Vector(7985, 55.659393310547, 3041), CastPos = Vector(7985, 55.659393310547, 3041)},
		{From = Vector(5785, 54.918552398682, 5445),  To = Vector(5899, 51.673694610596, 5089), CastPos = Vector(5899, 51.673694610596, 5089)},
		{From = Vector(5847, 51.673683166504, 5065),  To = Vector(5683, 54.923862457275, 5403), CastPos = Vector(5683, 54.923862457275, 5403)},
		{From = Vector(6047, 51.67359161377, 4865),  To = Vector(6409, 51.673400878906, 4765), CastPos = Vector(6409, 51.673400878906, 4765)},
		{From = Vector(6347, 51.673400878906, 4765),  To = Vector(5983, 51.673580169678, 4851), CastPos = Vector(5983, 51.673580169678, 4851)},
		{From = Vector(6995, 55.738128662109, 5615),  To = Vector(6701, 61.461639404297, 5383), CastPos = Vector(6701, 61.461639404297, 5383)},
		{From = Vector(6697, 61.083110809326, 5369),  To = Vector(6889, 55.628131866455, 5693), CastPos = Vector(6889, 55.628131866455, 5693)},
		{From = Vector(11245, -62.793098449707, 4515),  To = Vector(11585, 52.104347229004, 4671), CastPos = Vector(11585, 52.104347229004, 4671)},
		{From = Vector(11491.91015625, 52.506042480469, 4629.763671875),  To = Vector(11143, -63.063579559326, 4493), CastPos = Vector(11143, -63.063579559326, 4493)},
		{From = Vector(11395, -62.597496032715, 4315),  To = Vector(11579, 51.962089538574, 4643), CastPos = Vector(11579, 51.962089538574, 4643)},
		{From = Vector(11245, 53.017200469971, 4915),  To = Vector(10869, -63.132637023926, 4907), CastPos = Vector(10869, -63.132637023926, 4907)},
		{From = Vector(10923.66015625, -63.288948059082, 4853.9931640625),  To = Vector(11295, 53.402942657471, 4913), CastPos = Vector(11295, 53.402942657471, 4913)},
		{From = Vector(10595, 54.870422363281, 6965),  To = Vector(10351, 55.198459625244, 7249), CastPos = Vector(10351, 55.198459625244, 7249)},
		{From = Vector(10415, 55.269580841064, 7277),  To = Vector(10609, 54.870502471924, 6957), CastPos = Vector(10609, 54.870502471924, 6957)},
		{From = Vector(12645, 53.343021392822, 4615),  To = Vector(12349, 56.222766876221, 4849), CastPos = Vector(12349, 56.222766876221, 4849)},
		{From = Vector(12395, 52.525123596191, 4765),  To = Vector(12681, 53.853294372559, 4525), CastPos = Vector(12681, 53.853294372559, 4525)},
		{From = Vector(11918.497070313, 57.399909973145, 5471),  To = Vector(11535, 54.801097869873, 5471), CastPos = Vector(11535, 54.801097869873, 5471)},
		{From = Vector(11593, 54.610706329346, 5501),  To = Vector(11967, 56.541202545166, 5477), CastPos = Vector(11967, 56.541202545166, 5477)},
		{From = Vector(11140.984375, 65.858421325684, 8432.9384765625),  To = Vector(11487, 53.453464508057, 8625), CastPos = Vector(11487, 53.453464508057, 8625)},
		{From = Vector(11420.7578125, 53.453437805176, 8608.6923828125),  To = Vector(11107, 65.090522766113, 8403), CastPos = Vector(11107, 65.090522766113, 8403)},
		{From = Vector(11352.48046875, 57.916156768799, 8007.10546875),  To = Vector(11701, 55.458843231201, 8165), CastPos = Vector(11701, 55.458843231201, 8165)},
		{From = Vector(11631, 55.45885848999, 8133),  To = Vector(11287, 58.037368774414, 7979), CastPos = Vector(11287, 58.037368774414, 7979)},
		{From = Vector(10545, 65.745803833008, 7913),  To = Vector(10555, 55.338600158691, 7537), CastPos = Vector(10555, 55.338600158691, 7537)},
		{From = Vector(10795, 55.354972839355, 7613),  To = Vector(10547, 65.771072387695, 7893), CastPos = Vector(10547, 65.771072387695, 7893)},
		{From = Vector(10729, 55.352409362793, 7307),  To = Vector(10785, 54.87170791626, 6937), CastPos = Vector(10785, 54.87170791626, 6937)},
		{From = Vector(10745, 54.871494293213, 6965),  To = Vector(10647, 55.350120544434, 7327), CastPos = Vector(10647, 55.350120544434, 7327)},
		{From = Vector(10099, 66.309921264648, 8443),  To = Vector(10419, 66.106910705566, 8249), CastPos = Vector(10419, 66.106910705566, 8249)},
		{From = Vector(9203, 63.777507781982, 3309),  To = Vector(9359, -63.260040283203, 3651), CastPos = Vector(9359, -63.260040283203, 3651)},
		{From = Vector(9327, -63.258842468262, 3675),  To = Vector(9185, 65.192367553711, 3329), CastPos = Vector(9185, 65.192367553711, 3329)},
		{From = Vector(10045, 55.140678405762, 6465),  To = Vector(10353, 54.869094848633, 6679), CastPos = Vector(10353, 54.869094848633, 6679)},
		{From = Vector(10441.002929688, 65.793014526367, 8315.2333984375),  To = Vector(10133, 64.52165222168, 8529), CastPos = Vector(10133, 64.52165222168, 8529)},
		{From = Vector(8323, 54.89501953125, 9137),  To = Vector(8207, 53.530456542969, 9493), CastPos = Vector(8207, 53.530456542969, 9493)},
		{From = Vector(8295, 53.530418395996, 9363),  To = Vector(8359, 54.895038604736, 8993), CastPos = Vector(8359, 54.895038604736, 8993)},
		{From = Vector(8495, 52.768348693848, 9763),  To = Vector(8401, 53.643203735352, 10125), CastPos = Vector(8401, 53.643203735352, 10125)},
		{From = Vector(8419, 53.59920501709, 9997),  To = Vector(8695, 51.417175292969, 9743), CastPos = Vector(8695, 51.417175292969, 9743)},
		{From = Vector(7145, 55.597702026367, 5965),  To = Vector(7413, -66.513969421387, 6229), CastPos = Vector(7413, -66.513969421387, 6229)},
		{From = Vector(6947, 56.01900100708, 8213),  To = Vector(6621, -62.816535949707, 8029), CastPos = Vector(6621, -62.816535949707, 8029)},
		{From = Vector(6397, 54.634998321533, 10813),  To = Vector(6121, 54.092365264893, 11065), CastPos = Vector(6121, 54.092365264893, 11065)},
		{From = Vector(6247, 54.6325340271, 11513),  To = Vector(6053, 39.563938140869, 11833), CastPos = Vector(6053, 39.563938140869, 11833)},
		{From = Vector(4627, 41.618049621582, 11897),  To = Vector(4541, 51.561706542969, 11531), CastPos = Vector(4541, 51.561706542969, 11531)},
		{From = Vector(5179, 53.036727905273, 10839),  To = Vector(4881, -63.11701965332, 10611), CastPos = Vector(4881, -63.11701965332, 10611)},
		{From = Vector(4897, -63.125648498535, 10613),  To = Vector(5177, 52.773872375488, 10863), CastPos = Vector(5177, 52.773872375488, 10863)},
		{From = Vector(11367, 50.348838806152, 9751),  To = Vector(11479, 106.51720428467, 10107), CastPos = Vector(11479, 106.51720428467, 10107)},
		{From = Vector(11489, 106.53769683838, 10093),  To = Vector(11403, 50.349449157715, 9727), CastPos = Vector(11403, 50.349449157715, 9727)},
		{From = Vector(12175, 106.80973052979, 9991),  To = Vector(12143, 50.354927062988, 9617), CastPos = Vector(12143, 50.354927062988, 9617)},
		{From = Vector(12155, 50.354919433594, 9623),  To = Vector(12123, 106.81489562988, 9995), CastPos = Vector(12123, 106.81489562988, 9995)},
		{From = Vector(9397, 52.484146118164, 12037),  To = Vector(9769, 106.21959686279, 12077), CastPos = Vector(9769, 106.21959686279, 12077)},
		{From = Vector(9745, 106.2202835083, 12063),  To = Vector(9373, 52.484580993652, 12003), CastPos = Vector(9373, 52.484580993652, 12003)},
		{From = Vector(9345, 52.689178466797, 12813),  To = Vector(9719, 106.20919799805, 12805), CastPos = Vector(9719, 106.20919799805, 12805)},
		{From = Vector(4171, 109.72004699707, 2839),  To = Vector(4489, 54.030017852783, 3041), CastPos = Vector(4489, 54.030017852783, 3041)},
		{From = Vector(4473, 54.04020690918, 3009),  To = Vector(4115, 110.06342315674, 2901), CastPos = Vector(4115, 110.06342315674, 2901)},
		{From = Vector(2669, 105.9382019043, 4281),  To = Vector(2759, 57.061370849609, 4647), CastPos = Vector(2759, 57.061370849609, 4647)},
		{From = Vector(2761, 57.062965393066, 4653),  To = Vector(2681, 106.2310256958, 4287), CastPos = Vector(2681, 106.2310256958, 4287)},
		{From = Vector(1623, 108.56233215332, 4487),  To = Vector(1573, 56.13228225708, 4859), CastPos = Vector(1573, 56.13228225708, 4859)},
		{From = Vector(1573, 56.048126220703, 4845),  To = Vector(1589, 108.56234741211, 4471), CastPos = Vector(1589, 108.56234741211, 4471)},
		{From = Vector(2355.4450683594, 60.167724609375, 6366.453125),  To = Vector(2731, 54.617771148682, 6355), CastPos = Vector(2731, 54.617771148682, 6355)},
		{From = Vector(2669, 54.488224029541, 6363),  To = Vector(2295, 60.163955688477, 6371), CastPos = Vector(2295, 60.163955688477, 6371)},
		{From = Vector(2068.5336914063, 54.921718597412, 8898.5322265625),  To = Vector(2457, 53.765918731689, 8967), CastPos = Vector(2457, 53.765918731689, 8967)},
		{From = Vector(2447, 53.763805389404, 8913),  To = Vector(2099, 54.922241210938, 8775), CastPos = Vector(2099, 54.922241210938, 8775)},
		{From = Vector(1589, 49.631057739258, 9661),  To = Vector(1297, 38.928337097168, 9895), CastPos = Vector(1297, 38.928337097168, 9895)},
		{From = Vector(1347, 39.538192749023, 9813),  To = Vector(1609, 50.499561309814, 9543), CastPos = Vector(1609, 50.499561309814, 9543)},
		{From = Vector(3997, -63.152000427246, 10213),  To = Vector(3627, -64.785446166992, 10159), CastPos = Vector(3627, -64.785446166992, 10159)},
		{From = Vector(3709, -63.07014465332, 10171),  To = Vector(4085, -63.139434814453, 10175), CastPos = Vector(4085, -63.139434814453, 10175)},
		{From = Vector(9695, 106.20919799805, 12813),  To = Vector(9353, 95.629013061523, 12965), CastPos = Vector(9353, 95.629013061523, 12965)},
		{From = Vector(5647, 55.136940002441, 9563),  To = Vector(5647, -65.224411010742, 9187), CastPos = Vector(5647, -65.224411010742, 9187)},
		{From = Vector(2315, 108.66681671143, 4377),  To = Vector(2403, 56.444217681885, 4743), CastPos = Vector(2403, 56.444217681885, 4743)},
		{From = Vector(10345, 54.86909866333, 6665),  To = Vector(10009, 55.126476287842, 6497), CastPos = Vector(10009, 55.126476287842, 6497)},
		{From = Vector(12419, 54.801849365234, 6119),  To = Vector(12787, 57.748607635498, 6181), CastPos = Vector(12787, 57.748607635498, 6181)},
		{From = Vector(12723, 57.326282501221, 6253),  To = Vector(12393, 54.80948638916, 6075), CastPos = Vector(12393, 54.80948638916, 6075)},

	},

}

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
        Q = Queuer()
		ts = TargetSelector(TARGET_LESS_CAST, 1700, DAMAGE_MAGIC)
		NidaleeConfig = scriptConfig("Da Vinci's Nidalee", "NidaleeAdv")
		NidaleeConfig:addParam("Q", "Cast Q", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		NidaleeConfig:addParam("AutoIgnite", "KillSteal Ignite",  SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig:addParam("sbtwHealSlider", "Auto Heal if Health below %: ",  SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
		NidaleeConfig:addParam("Movement", "Move To Mouse", SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig:addSubMenu("Nidalee - Jumper", "Queuer")
		NidaleeConfig.Queuer:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig.Queuer:addParam("Queue", "Queue orders",  SCRIPT_PARAM_ONKEYDOWN, false, 17)
		NidaleeConfig.Queuer:addParam("QFlash", "Queue Flash",  SCRIPT_PARAM_ONKEYDOWN, false, string.byte("F"))
		NidaleeConfig.Queuer:addParam("DrawD", "Don't draw circles if the distance >", SCRIPT_PARAM_SLICE, 2000, 0, 10000, 0)
	
	if JumpSpots[myHero.charName] then
		NidaleeConfig.Queuer:addSubMenu(myHero.charName.." jump helper", myHero.charName)
		NidaleeConfig.Queuer[myHero.charName]:addParam("Enabled", "Enabled",  SCRIPT_PARAM_ONOFF, true)
		
		NidaleeConfig.Queuer[myHero.charName]:addParam("DrawJ", "Draw jump points",  SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig.Queuer[myHero.charName]:addParam("DrawL", "Draw landing points",  SCRIPT_PARAM_ONOFF, false)

		NidaleeConfig.Queuer[myHero.charName]:addSubMenu("Colors", "Colors")
		NidaleeConfig.Queuer[myHero.charName].Colors:addParam("JColor", "Jump point color", SCRIPT_PARAM_COLOR, {100, 0, 100, 255})
		NidaleeConfig.Queuer[myHero.charName].Colors:addParam("LColor", "Landing point color", SCRIPT_PARAM_COLOR, {100, 255, 255, 0})

	end

	if (GetFlashSlot() ~= nil) then
		NidaleeConfig.Queuer:addSubMenu("Flash helper", "Flash")
		NidaleeConfig.Queuer.Flash:addParam("Enabled", "Enabled",  SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig.Queuer.Flash:addParam("Cooldown", "Show spots only if we have ward(s) available",  SCRIPT_PARAM_ONOFF, true)

		NidaleeConfig.Queuer.Flash:addParam("DrawJ", "Draw Flash points",  SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig.Queuer.Flash:addParam("DrawL", "Draw landing points",  SCRIPT_PARAM_ONOFF, false)

		NidaleeConfig.Queuer.Flash:addSubMenu("Colors", "Colors")
		NidaleeConfig.Queuer.Flash.Colors:addParam("JColor", "Flash point color", SCRIPT_PARAM_COLOR, {100, 255, 255, 0})
		NidaleeConfig.Queuer.Flash.Colors:addParam("LColor", "Landing point color", SCRIPT_PARAM_COLOR, {100, 0, 255, 0})
	end
		NidaleeConfig:addTS(ts)
		
		ts.name = "Da Vinci's Nidalee"
		
		ProdictQ = Prodict:AddProdictionObject(_Q, 1500, 1250, 0.250, 30, myHero, CastQ)
	ProdictQCol = Collision(1500, 1300, 0.125, 30)
		for I = 1, heroManager.iCount do
			local hero = heroManager:GetHero(I)
			if hero.team ~= myHero.team then
				ProdictQ:CanNotMissMode(true, hero)
			end
		end
	end
	PrintChat("<font color=\"#FF0000\" >>The Nida Lisa by Da Vinci <</font> ")
	function OnTick()
		if ts.target == nil and NidaleeConfig.Q and NidaleeConfig.Movement then
                myHero:MoveTo(mousePos.x, mousePos.z)
        end
		GlobalInfos()
		ts:update()
		if ts.target ~= nil and NidaleeConfig.Q then
			ProdictQ:EnableTarget(ts.target, true)
		end
		if not NidaleeConfig.Queuer.Enabled then return end

	if NidaleeConfig.Queuer.Queue and NidaleeConfig.Queuer.QFlash and (not Q:GetLastAction() or Q:GetLastAction().type ~= "Flash") and #Q.queue > 0 then
		local Action = CastToPosQ(GetFlashSlot(), Vector(mousePos))
		Q:AddAction(Action)
	end

	
	if RecordLocations and Timer and (os.clock() - Timer) > 2 then
		if not RecordingWards then
			LandingPos = Vector(myHero.visionPos)
			print(LandingPos)
		else
			LandingPos = WardPoint
		end
		Timer = math.huge
		table.insert(RecordedLocations, {To = LandingPos, From = MyPosition, CastPos = CastPosition})
		print("Location saved")
		local from = MyPosition
		local cp = CastPosition
		local to = LandingPos
		Text = "\t\t{From = Vector("..from.x..", "..from.y..", "..from.z.."),  To = Vector("..to.x..", "..to.y..", "..to.z.."), CastPos = Vector("..cp.x..", "..cp.y..", "..cp.z..")},\n"
		SetClipboardText(Text)
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

-----------------------------------
--ULTRA JUMPER
-----------------------------------

class "Queuer"
function Queuer:__init()
	AddTickCallback(function() self:OnTick() end)
	self.queue = {}
	self.currentaction = nil
end

function Queuer:OnTick()
	if not self.currentaction and #self.queue > 0 then
		local action = self.queue[1]
		self.currentaction = action
		if self.currentaction.onstartcallback then
			if self.currentaction.onstartcallback() then
				action:start(self)
			end
		else
			action:start()
		end
		
		table.remove(self.queue, 1)
	elseif self.currentaction then
		if self.currentaction:checkfinished() then
			self.currentaction:OnFinish(self)
			self.currentaction = nil
		end
	end
end

function Queuer:AddAction(action, pos)
	table.insert(self.queue, pos or (#self.queue + 1), action)
end

function Queuer:GetLastAction()
	if self.currentaction and #self.queue == 0 then
		return self.currentaction
	elseif #self.queue > 0 then
		return self.queue[#self.queue]
	end
end

function Queuer:ClearQueue()
	self.queue = {}
end

function Queuer:StopCurrentAction()
	self.currentaction = nil
end

function Queuer:Draw()
	if self.currentaction then
		local from = Vector(myHero)
		local to = Vector(myHero)
		
		to = self.currentaction.to and self.currentaction.to or to

		self.currentaction:Draw(from, to)

		for i, action in ipairs(self.queue) do
			from = to
			if action.target and ValidTarget(action.target) then
				action.to = Vector(action.target)
			end
			to = action.to and action.to or to
			action:Draw(from, to)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "MoveQ"
function MoveQ:__init(to)
	self.to = to
end

function MoveQ:start()
	WayPointManager.AddCallback(function(n) self:OnNewWaypoints(n) end)
	self.WaypointsReceived = false
	Packet('S_MOVE',{x = self.to.x, y = self.to.z, type = 2}):send()
end

function MoveQ:checkfinished()
	if self.WaypointsReceived or GetDistanceSqr(myHero.visionPos, self.to) < 400 then
		local waypoints = WayPointManager:GetWayPoints(myHero)
		if GetDistanceSqr(myHero.visionPos, waypoints[#waypoints]) <=  (myHero.ms * (GetLatency()/2000 + 0.1))^2  or #waypoints == 1 then
			return true
		end
	end
	Packet('S_MOVE',{x = self.to.x, y = self.to.z, type = 2}):send()
	return false
end

function MoveQ:OnNewWaypoints(networkID)
	if networkID == myHero.networkID then
		self.WaypointsReceived = true
	end
end

function MoveQ:OnFinish(parent)
end

function MoveQ:Draw(from, to)
	if self.WaypointsReceived then
		local waypoints = WayPointManager:GetWayPoints(myHero)
		for i = 1, #waypoints - 1 do
			from = Vector(waypoints[i].x, 0, waypoints[i].y)
			to = Vector(waypoints[i + 1].x, 0, waypoints[i + 1].y)

			DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, self.color or ARGB(100, 0, 255, 0), 1)
		end
	else
		DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, self.color or ARGB(100, 0, 255, 0), 1)
	end
end



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "DelayQ"
function DelayQ:__init(time)
	self.time = time
end

function DelayQ:start()
	self.startTime = os.clock()
end

function DelayQ:checkfinished()
	if (os.clock() - self.startTime >= self.time) then
		return true
	end
	return false
end

function DelayQ:OnFinish(parent)
end

function DelayQ:Draw(from, to)
	if self.startTime then
		DrawText3D(tostring(math.floor((os.clock() - self.startTime)* 1000)), from.x, from.y, from.z, 13, self.color or ARGB(100, 255, 255, 255))
	else
		DrawText3D(tostring(math.floor(self.time * 1000)), from.x, from.y, from.z, 13, self.color or ARGB(100, 255, 255, 255))
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "CastToPosQ"
function CastToPosQ:__init(slot, to)
	self.slot = slot
	self.to = to
	self.casted = false
end

function CastToPosQ:start()
	CastSpell(self.slot, self.to.x, self.to.z)
	self.casted = true
end

function CastToPosQ:checkfinished()
	if self.casted and myHero:CanUseSpell(self.slot) ~= READY then
		return true
	end
	return false
end

function CastToPosQ:OnFinish(parent)
end

function CastToPosQ:Draw(from, to)
	DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, self.color or ARGB(100, 0, 0, 255), 1)
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "CastToTargetQ"
function CastToTargetQ:__init(slot, target)
	self.to = target
	self.target = target
	self.slot = slot
	self.originalname = myHero:GetSpellData(self.slot).name
end

function CastToTargetQ:start()
end

function CastToTargetQ:checkfinished()
	if myHero:CanUseSpell(self.slot) == READY and not self.casted then
		CastSpell(self.slot, self.target)
		self.casted = true
	end

	if self.casted and (myHero:CanUseSpell(self.slot) ~= READY or myHero:GetSpellData(self.slot).name ~= self.originalname)then
		return true
	end
	return false
end

function CastToTargetQ:OnFinish(parent)
end

function CastToTargetQ:Draw(from, to)
	DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, self.color or ARGB(100, 0, 0, 255), 1)
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

class "WaitForObjectQ"
function WaitForObjectQ:__init(name, distance, timeout)
	self.name = name
	self.found = false
	self.startTime = math.huge
	self.timeout = timeout
	self.distancesqr = distance * distance
	AddCreateObjCallback(function(o) self:OnCreateObject(o) end)
end

function WaitForObjectQ:start()
	self.startTime = os.clock()
end

function WaitForObjectQ:OnCreateObject(obj)
	if obj and obj.valid and obj.name and obj.name:lower():find(self.name) and GetDistanceSqr(obj) < self.distancesqr then
		DelayAction(function(o) self:setobject(o) end, 0.0001, {obj})
		self.object = obj
	end
end

function WaitForObjectQ:setobject(o)
	if o.networkID ~= 0 then
		self.object = o
		self.found = true
	end
end

function WaitForObjectQ:OnFinish(parent)
	if (#parent.queue > 0) and self.object then
		parent.queue[1].target = self.object
		parent.queue[1].to = self.object
	end
end

function WaitForObjectQ:checkfinished()
	if (os.clock() - self.startTime) > self.timeout or self.found then
		return true
	end
	return false
end

function WaitForObjectQ:Draw(from, to)
	DrawText3D(tostring(self.name), from.x, from.y, from.z, 13, self.color or ARGB(255, 255, 255, 255))
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


class "WaitUntil"
function WaitUntil:__init(f, args)
	self.f = f
	self.args = args
end

function WaitUntil:start()
end

function WaitUntil:OnFinish(parent)
end

function WaitUntil:checkfinished()
	return self.f(table.unpack(self.args or {}))
end

function WaitUntil:Draw(from, to)
	DrawText3D(tostring("Wait"), from.x, from.y, from.z, 13, self.color or ARGB(255, 255, 255, 255))
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





function GetFlashSlot()
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerFlash") then
		return SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerFlash") then
		return SUMMONER_2
	end
end

function OnSendPacket(p)
	if NidaleeConfig.Queuer.Enabled and NidaleeConfig.Queuer.Queue and p.header == Packet.headers.S_MOVE then
		local packet = Packet(p)
		local to = Vector(packet:get('x'), myHero.y, packet:get('y'))
		local target = packet:get('targetNetworkId')
		local Added = false

		local Spots = JumpSpots[myHero.charName]
		if Spots and NidaleeConfig.Queuer[myHero.charName].Enabled then
			local MaxDistance = NidaleeConfig.Queuer.DrawD
			for i, spot in ipairs(Spots) do
				if GetDistanceSqr(spot.From) < MaxDistance*MaxDistance then
					if GetDistanceSqr(spot.From, to) < SRadiusSqr then
						--Nidalee and riven
						if myHero.charName == 'Nidalee' or myHero.charName == 'Riven' then
							local v = Vector(spot.From) - 40 * (Vector(spot.To) - Vector(spot.From)):normalized()
							Q:AddAction(MoveQ(v))
							Q:AddAction(DelayQ(0.05))
							Q:AddAction(MoveQ(spot.From))
							Q:AddAction(DelayQ(0.05))
							Q:AddAction(CastToPosQ(JumpSlot[myHero.charName], spot.CastPos))
							Q:AddAction(DelayQ(0.1))

						--Ward jumps
						elseif (myHero.charName == 'LeeSin' or myHero.charName == 'Katarina' or myHero.charName == 'Jax') and GetWardsSlot() then
							Q:AddAction(MoveQ(spot.From))
							Q:AddAction(WardJumpQ(GetWardsSlot(), JumpSlot[myHero.charName], spot.CastPos))
						elseif (myHero.charName == 'Yasuo') then
							Q:AddAction(MoveQ(spot.From))

							if myHero:CanUseSpell(_W) == READY then
								Q:AddAction(CastToPosQ(_W, spot.CastPos))
							elseif GetWardsSlot()  then
								Q:AddAction(CastToPosQ(GetWardsSlot(), spot.CastPos))
							end

							Q:AddAction(WaitForJungleMob(475, 2))
							Q:AddAction(CastToTargetQ(JumpSlot[myHero.charName], myHero))
						--Normal dashes and blinks
						else
							Q:AddAction(MoveQ(spot.From))
							Q:AddAction(CastToPosQ(JumpSlot[myHero.charName], spot.CastPos))
						end
						Added = true
						break
					end
				end
			end
		end

		Spots = JumpSpots['Flash']
		if Spots and NidaleeConfig.Queuer['Flash'] and NidaleeConfig.Queuer['Flash'].Enabled and not Added then
			local MaxDistance = NidaleeConfig.Queuer.DrawD
			for i, spot in ipairs(Spots) do
				if GetDistanceSqr(spot.From) < MaxDistance*MaxDistance then
					if GetDistanceSqr(spot.From, to) < SRadiusSqr then

						Q:AddAction(MoveQ(spot.From))
						Q:AddAction(CastToPosQ(GetFlashSlot(), spot.CastPos))

						Added = true
						break
					end
				end
			end
		end

		if not Added then
			if target == 0 then
				local Action = MoveQ(to)
				Q:AddAction(Action)
			else
				local unit = objManager:GetObjectByNetworkId(target)
				if ValidTarget(unit) then
					local Action = AttackQ(unit)
					Q:AddAction(Action)
					Q:AddAction(DelayQ(0.1))
				end
			end
		end

		p:Block()
	elseif NidaleeConfig.Queuer.Enabled and p.header == Packet.headers.S_MOVE then
		Q:ClearQueue()
		Q:StopCurrentAction()
	end

	if RecordLocations and p.header == Packet.headers.S_CAST then
		local packet = Packet(p)
		MyPosition = Vector(myHero.visionPos)
		CastPosition = Vector(math.floor(packet:get('toX')), 0, math.floor(packet:get('toY')))
		CastPosition = Vector(mousePos)
		Timer = os.clock()
	end
end

function OnWndMsg(msg, key)
	if RecordLocations then
		if msg == KEY_DOWN and key == string.byte("R") then
			print("Locations saved to clipboard")
			local Text = ""--"['"..myHero.charName.."'] = \n"
			--Text = Text .. "{\n"
			for i, spot in ipairs(RecordedLocations) do
				local from = spot.From
				local to = spot.To
				local cp = spot.CastPos
				Text = Text .. "\t\t{From = Vector("..from.x..", "..from.y..", "..from.z.."),  To = Vector("..to.x..", "..to.y..", "..to.z.."), CastPos = Vector("..cp.x..", "..cp.y..", "..cp.z..")},\n"
			end
			--Text = Text .. "}\n"
			SetClipboardText(Text)
		elseif msg == KEY_DOWN and key == string.byte("D") then
			print("Last location removed")
			if #RecordedLocations > 0 then
				table.remove(RecordedLocations, #RecordedLocations)
			end
		elseif msg == KEY_DOWN and key == string.byte("C") then
			--Q:AddAction(WardJumpQ(GetWardsSlot(), _W, Vector(mousePos)))
			print(Vector(mousePos))
		end
	end
end

function TARGB(t)
	return ARGB(t[1], t[2], t[3], t[4])
end

function DrawCoolArrow(from, to, color)
	DrawLineBorder3D(from.x, myHero.y, from.z, to.x, myHero.y, to.z, 2, color, 1)
end

function OnDraw()
	if not NidaleeConfig.Queuer.Enabled then return end

	for i, s in ipairs(DrawS) do
		local Spots = JumpSpots[s]
		if Spots and NidaleeConfig.Queuer[s] and NidaleeConfig.Queuer[s].Enabled then
			local MaxDistance = NidaleeConfig.Queuer.DrawD
			for i, spot in ipairs(Spots) do
				if GetDistanceSqr(spot.From) < MaxDistance*MaxDistance and (s ~= 'Wards' or GetWardsSlot()) then
					if NidaleeConfig.Queuer[s].DrawJ then
						local color = TARGB(NidaleeConfig.Queuer[s].Colors.JColor)
						local pos = s ~= 'Wards' and spot.From or spot.CastPos
						if GetDistanceSqr(pos, mousePos) < SRadiusSqr then
							color = ARGB(100, 255, 61, 236)
							DrawCoolArrow(pos, spot.To, color)
						end
						DrawCircle2(pos.x, myHero.y, pos.z, DRadius, color)
					end

					if NidaleeConfig.Queuer[s].DrawL then
						local color = TARGB(NidaleeConfig.Queuer[s].Colors.LColor)
						local pos = spot.To
						DrawCircle2(pos.x, myHero.y, pos.z, DRadius, color)
					end
				end
			end
		end
	end
	
	for i, loc in ipairs(RecordedLocations) do
		DrawCircle2(loc.From.x, myHero.y, loc.From.z, DRadius, ARGB(100, 255, 255, 255))
	end

	Q:Draw()
end

--[[Credits to barasia, vadash and viceversa for anti-lag circles]]
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(16,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))

	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvl(x, y, z, radius, 2, color, 75)	
	end
end

function OnCreateObj(object)
	--print(object)
	if RecordLocations and (object.name:find("Ward")) and RecordLocations then
		WardPoint = Vector(object.x, object.y, object.z)
	end
end
