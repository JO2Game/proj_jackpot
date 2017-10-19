local modelRegister = {}

local BEGIN_TAG = 0
local TEMP_MODEL_INFO_MAP = {}
local function bindIdModel( modelPath )
	--if _gcf.ENTER == _gcf.ENTER_GAME then
		BEGIN_TAG = BEGIN_TAG+1
		--local modelInfo = {}
		--modelInfo.class = loadLuaFile(modelPath)
		--modelInfo.path = modelPath
		TEMP_MODEL_INFO_MAP[BEGIN_TAG] = modelPath--modelInfo
		return BEGIN_TAG
	--end
end


MOD = {}

--MOD.DATACENTER = bindIdModel("models/dataCenter/DataCenterModel") --数据管理
MOD.WORLD = bindIdModel("models/world/WorldModel") --游戏世界
MOD.DC = bindIdModel("models/dc/DCModel") --游戏世界
--[[
MOD.ITEM = bindIdModel("models/item/ItemModel") --物品背包
MOD.MAKE = bindIdModel("models/make/MakeModel") --制造系统
MOD.SHOP = bindIdModel("models/shop/ShopModel") --商店
MOD.BUILD = bindIdModel("models/build/BuildModel") --建筑系统
MOD.HERO = bindIdModel("models/hero/HeroModel") --英雄系统
MOD.WORKER = bindIdModel("models/worker/WorkerModel") --工人系统
MOD.ANABASIS = bindIdModel("models/anabasis/AnabasisModel") --远征前的编制及远征中的背包容量
--]]
function modelRegister.register()
	--注册模块的准备调用
	--根据以下加载顺序，可以通过帧队列加载，加强交互感
	for k,v in pairs(TEMP_MODEL_INFO_MAP) do
		--加载Model入口
		local mdCls = loadLuaFile(v)
		if mdCls then
			--处理Model下加载的Lua
			local subClassMap = gp.ModelMgr.modelSubLuas[k]
			if subClassMap then
				for _,scf in ipairs(subClassMap) do
					local pathSplit = gp.str.split(scf, "/")
					gp.ModelMgr:registerModelSubClasses(k, pathSplit[#pathSplit], loadLuaFile(scf))
				end
			end
			--创建Model对象，注册
			local md = mdCls.new()
			gp.ModelMgr:registerModel(k, md)
			md:onInitData()
			md:onInitEvent()
		else
			LOG_ERROR("modelRegister", "Model[%s] fail to new ", v)
		end
	end
	--清空
	gp.ModelMgr.modelSubLuas = {}
end



return modelRegister;


