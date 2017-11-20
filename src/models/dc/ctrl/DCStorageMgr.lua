
local DCStorageMgr = class("DCStorageMgr")

--[[
用于数据储存的管理类
]]

function DCStorageMgr:ctor()
	self:loadCondition()
	self:loadConditionSet()
	self:loadDrawResult()
end
--[[用于帮助理解其数据结构而已
function DCStorageMgr:_initData()
	
	--用户当前设置的条件
	self.condition = {}
	self.condition.even2In3 = false
	self.condition.evenCnt = 0
	self.condition.singleCnt = 0
	self.condition.doubleCnt = 0
	self.condition.redOver = 0

	self.condition.filterRedSet = {}
	self.condition.filterBlueSet = {}
	self.condition.hitRedSet = {}
	self.condition.hitBlueSet = {}
	self.condition.filterEvenSet = {}

	self.condition.filterCustomSet = {}
	--用户以往保存的条件集合
	self.conditionSet = {}	
end
--]]
function DCStorageMgr:onDelete()
	
end

--条件数据
function DCStorageMgr:loadCondition( )
	local jStr = cc.UserDefault:getInstance():getStringForKey(glg.DC.USEDEF_KEY.CONDITION)
	self.condition = gp.json.jsonTableFromString(jStr) or {}
	self.condition.filterCustomSet = self.condition.filterCustomSet or {}
end

function DCStorageMgr:saveCondition( )
	local tableStr = gp.json.jsonTableToJString(self.condition)
	cc.UserDefault:getInstance():setStringForKey(glg.DC.USEDEF_KEY.CONDITION, tableStr)
end

function DCStorageMgr:getCondition( )
	return self.condition
end
--[[
function DCStorageMgr:setCondition( condition )
	self.condition = condition
end
--]]

function DCStorageMgr:saveConditionToSet()
	--有相等的，不用保存
	for k,v in pairs(self.conditionSet) do
		if gp.table.equal(v, self.condition)==true then
			gp.Factory:noiceView(string.format("条件与%s相同, 被忽略!", os.date("%x %X",data)))
			return
		end
	end
	local key = tostring(os.time())
	--print(key)
	self.conditionSet[key] = gp.table.copy(self.condition)
	--table.insert(self.conditionSet, self.condition)
	self:saveConditionSet()
	gp.MessageMgr:dispatchEvent(ENT.DC_ADD_CONDITION_DATA)
end

--条件数据集合
function DCStorageMgr:loadConditionSet( )
	local jStr = cc.UserDefault:getInstance():getStringForKey(glg.DC.USEDEF_KEY.CONDITION_SET)
	--LOG_INFO("DCStorageMgr", " afd "..jStr)
	self.conditionSet = gp.json.jsonTableFromString(jStr) or {}
end

function DCStorageMgr:saveConditionSet( )
	local tableStr = gp.json.jsonTableToJString(self.conditionSet)
	--LOG_INFO("DCStorageMgr", tableStr)
	cc.UserDefault:getInstance():setStringForKey(glg.DC.USEDEF_KEY.CONDITION_SET, tableStr)
end

function DCStorageMgr:getConditionSet( )
	return self.conditionSet
end

function DCStorageMgr:getConditionWithId(id)
	return self.conditionSet[id]
end

function DCStorageMgr:removeConditionWithId( id )
	if self.conditionSet[id] then
		self.conditionSet[id] = nil
		self:saveConditionSet()
	end
end

--筛选后抽取的结束
function DCStorageMgr:loadDrawResult( )
	local jStr = cc.UserDefault:getInstance():getStringForKey(glg.DC.USEDEF_KEY.DRAW_RESULT)
	self.drawResult = gp.json.jsonTableFromString(jStr) or {}
end

function DCStorageMgr:saveDrawResult( )
	local tableStr = gp.json.jsonTableToJString(self.drawResult)
	cc.UserDefault:getInstance():setStringForKey(glg.DC.USEDEF_KEY.DRAW_RESULT, tableStr)
end

function DCStorageMgr:getDrawResult( )
	return self.drawResult
end

function DCStorageMgr:insertDrawData(data)
	if data then
		table.insert(self.drawResult, data)
		self:saveDrawResult()
		gp.MessageMgr:dispatchEvent(ENT.DC_DRAW_RESULT)
	end
end

function DCStorageMgr:removeDrawData(dcData)
	for i,v in ipairs(self.drawResult) do
		if v==dcData then
			table.remove(self.drawResult, i)
			self:saveDrawResult()
			return
		end
	end
end

function DCStorageMgr:clearDrawResult()
	self.drawResult = {}
	self:saveDrawResult()
end


return DCStorageMgr
