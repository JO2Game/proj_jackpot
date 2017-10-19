
local HEAD = {
	GLOBAL_BEGIN = 0,

	LOGIN_BEGIN = 100,
	WORLD_BEGIN = 200,
	PLAYER_BEGIN = 300,
	PET_BEGIN = 400,
	LAND_BEGIN = 500,
	ITEM_BEGIN = 600,
	FORMULA_BEGIN = 700,
	FIGHT_BEGIN = 800,
	RESOURCE_BEGIN = 900,
	SKILL_BEGIN = 1000,
	REPORD_BEGIN = 1100,
	QUEST_BEGIN = 1200,
	SHOP_BEGIN = 1300,
}

local acids = {}
--GLOBAL_BEGIN--------------------------------------------------------------------
acids.S2C_CODE_SUCCESS = HEAD.GLOBAL_BEGIN+2 --成功码
acids.S2C_CODE_ERROR = HEAD.GLOBAL_BEGIN+4 --错误码

acids.C2S_HEART_BEAT = HEAD.GLOBAL_BEGIN+5 --心跳包
acids.S2C_HEART_BEAT = HEAD.GLOBAL_BEGIN+6 --心跳包

acids.C2S_SERVER_TIME = HEAD.GLOBAL_BEGIN+7 --获取服务器时间
acids.S2C_SERVER_TIME = HEAD.GLOBAL_BEGIN+8 --获取服务器时间

acids.S2C_CLOSE_SERVER = HEAD.GLOBAL_BEGIN+10 --关闭服务器处理

--LOGIN_BEGIN--------------------------------------------------------------------
acids.LOGIN = HEAD.LOGIN_BEGIN+1

--WORLD_BEGIN--------------------------------------------------------------------
acids.C2S_WORLD_SYNC = HEAD.WORLD_BEGIN+1 --登录完成进入游戏时，C2S请求同步数据
acids.S2C_WORLD_BASE_SYNC = HEAD.WORLD_BEGIN+2 --基础数据（一般不变） 由服务器主动发送
acids.S2C_WORLD_COORD_SYNC = HEAD.WORLD_BEGIN+4 --基础坐标数据（比较少变化） 由服务器主动发送
acids.S2C_WORLD_POINT_SYNC = HEAD.WORLD_BEGIN+6 --基础属性数据（变化较多） 由服务器主动发送

--RESOURCE_BEGIN--------------------------------------------------------------------
acids.C2S_RES_SYNC = HEAD.RESOURCE_BEGIN+1 --请求同步资源信息
acids.S2C_RES_SYNC = HEAD.RESOURCE_BEGIN+2 --同步资源信息
acids.S2C_RES_ADD = HEAD.RESOURCE_BEGIN+4 --增减的资源信息

--PLAYER_BEGIN--------------------------------------------------------------------
acids.C2S_PLAYER_SYNC = HEAD.PLAYER_BEGIN+1 --请求同步玩家数据，（不单指自身）
acids.S2C_PLAYER_SYNC = HEAD.PLAYER_BEGIN+2 --同步对应的玩家数据
acids.C2S_PLAYER_LIST = HEAD.PLAYER_BEGIN+3 --请求一定数量的玩家列表
acids.S2C_PLAYER_LIST = HEAD.PLAYER_BEGIN+4 --同步对应数量的玩家列表

--PET_BEGIN--------------------------------------------------------------------
acids.C2S_PET_DATA = HEAD.PET_BEGIN+1 --请求对应id的宠物数据
acids.S2C_PET_FIXED_DATA = HEAD.PET_BEGIN+2 --同步宠物固定属性数据
acids.S2C_PET_BASE_DATA = HEAD.PET_BEGIN+4 --同步宠物基础数据
acids.S2C_PET_EQUIP_DATA = HEAD.PET_BEGIN+6 --同步宠物装备数据
acids.S2C_PET_SKILL_DATA = HEAD.PET_BEGIN+8 --同步宠物技能数据
acids.C2S_PET_FEED = HEAD.PET_BEGIN+3 --请求喂养宠物
acids.C2S_PET_FAST_FEED = HEAD.PET_BEGIN+5 --一键喂养
acids.C2S_PET_UPDATE = HEAD.PET_BEGIN+7 --请求通过材料升级宠物
acids.C2S_PET_FAST_UPDATE = HEAD.PET_BEGIN+9 --一键升级
acids.C2S_PET_EQUIP_DRESS = HEAD.PET_BEGIN+11 --请求宠物穿戴装备
acids.C2S_PET_FAST_EQUIP_DRESS = HEAD.PET_BEGIN+13 --一键装备
acids.C2S_PET_EQUIP_GETOFF = HEAD.PET_BEGIN+15 --请求卸下装备
acids.C2S_PET_SKILL_EQUIP = HEAD.PET_BEGIN+17 --请求装备技能

--ITEM_BEGIN--------------------------------------------------------------------
acids.C2S_ITEM_SYNC = HEAD.ITEM_BEGIN+1 --请求同步所有物品
acids.S2C_ITEM_SYNC = HEAD.ITEM_BEGIN+2 --同步所有物品
acids.C2S_ITEM_USE = HEAD.ITEM_BEGIN+3 --使用物品
acids.S2C_ITEM_ADD = HEAD.ITEM_BEGIN+4 --增减物品

--FORMULA_BEGIN--------------------------------------------------------------------
acids.C2S_FORMULA_SYNC = HEAD.FORMULA_BEGIN+1 --请求已点亮配方
acids.S2C_FORMULA_SYNC = HEAD.FORMULA_BEGIN+2 --同步可用配方列表
acids.C2S_FORMULA_LIGHT = HEAD.FORMULA_BEGIN+3 --请求点亮配方
acids.C2S_FORMULA_SYNTHETISE = HEAD.FORMULA_BEGIN+5 --请求合成对应配方物品
acids.C2S_FORMULA_UPATE = HEAD.FORMULA_BEGIN+7 --请求物品升级


--LAND_BEGIN--------------------------------------------------------------------
acids.C2S_LAND_SYNC = HEAD.LAND_BEGIN+1 --请求同步所有已开垦的土地
acids.S2C_LAND_SYNC = HEAD.LAND_BEGIN+2 --同步所有已开垦的土地 或 具体某几个土地
acids.C2S_LAND_COLLECT = HEAD.LAND_BEGIN+3 --收集
acids.C2S_LAND_UPDATE = HEAD.LAND_BEGIN+5 --升级
acids.C2S_LAND_SECTION = HEAD.LAND_BEGIN+7 --请求领土的关卡信息
acids.S2C_LAND_SECTION = HEAD.LAND_BEGIN+8 --返回领土的关卡信息


--SKILL_BEGIN--------------------------------------------------------------------
acids.C2S_SKILL_SYNC = HEAD.SKILL_BEGIN+1 --请求同步指定宠物习得的技能列表
--acids.S2C_SKILL_SYNC = HEAD.SKILL_BEGIN+2 --更新技能数据
acids.C2S_SKILL_UPDATE = HEAD.SKILL_BEGIN+3 --升级技能


--REPORD_BEGIN--------------------------------------------------------------------
acids.C2S_REPORD_SYNC = HEAD.REPORD_BEGIN+1 --请求同步所有报告事件
acids.S2C_REPORD_SYNC = HEAD.REPORD_BEGIN+2 --同步所有报告事件
acids.S2C_REPORD_ADD = HEAD.REPORD_BEGIN+4 --新报告事件产生

--QUEST_BEGIN--------------------------------------------------------------------
acids.C2S_QUEST_SYNC = HEAD.QUEST_BEGIN+1 --请求同步当前可接任务状态
acids.S2C_QUEST_SYNC = HEAD.QUEST_BEGIN+2 --同步更新任务状态
acids.C2S_QUEST_COMMIT = HEAD.QUEST_BEGIN+3 --请求提示任务

--SHOP_BEGIN--------------------------------------------------------------------
acids.C2S_SHOP_SYNC = HEAD.SHOP_BEGIN+1 --请求刷新指定类型的商店
acids.S2C_SHOP_SYNC = HEAD.SHOP_BEGIN+2 --同步商店的商品
acids.C2S_SHOP_BUY = HEAD.SHOP_BEGIN+3 --请求购买商品

--FIGHT_BEGIN--------------------------------------------------------------------
acids.C2S_FIGHT_ATTACK_PALYER = HEAD.FIGHT_BEGIN+1 --请求攻打某玩家
acids.C2S_FIGHT_ATTACK_PALYER_RESULT = HEAD.FIGHT_BEGIN+3 --请求传送攻打某玩家结果
acids.S2C_FIGHT_ATTACK_PALYER_RESULT = HEAD.FIGHT_BEGIN+4 --同步攻打玩家的战斗结果
acids.C2S_FIGHT_ATTACK_SECTION = HEAD.FIGHT_BEGIN+5 --请求攻打某关卡
acids.C2S_FIGHT_ATTACK_SECTION_RESULT = HEAD.FIGHT_BEGIN+7 --请求传送攻打某关卡结果
acids.S2C_FIGHT_ATTACK_SECTION_RESULT = HEAD.FIGHT_BEGIN+8 --同步攻打关卡的战斗结果


--------------------------------------------------------------------

local function checkDuplicateError( )
	local t = {}
	for k,v in pairs(acids) do
		if t[v] == true then
			LOG_ERROR("ActionDefines", "==========ACTIONID DUPLICATE %d", v)
		end
		t[v] = true
	end	
end 

checkDuplicateError()

return acids
