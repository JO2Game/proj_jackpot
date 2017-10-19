
local DCAnalysisMgr = class("DCAnalysisMgr")

--[[
低概率去除因素：
连号，4~6连
全单、全双
最近两期都出现的号码
最值限制[40-170]

可以试下区间取位
]]

function DCAnalysisMgr:ctor()
	self:_initData()
end

function DCAnalysisMgr:_initData()
	self.isAnalysising = false
	self.orgDataList = self:_comb(33, 6)
	
	--真正用于计算的条件
	self.calculation = {}	
	--分析的结果字典
	self.conditionResultMap = {}
end

function DCAnalysisMgr:conditionResult(id)
	return self.conditionResultMap[id]
end

function DCAnalysisMgr:removeConditionResult(id)
	self.conditionResultMap[id] = nil
end

function DCAnalysisMgr:onDelete()
	
end

local function _isKeyInList( list, key )
	for _,v in ipairs(list) do
		if key == v then
			return true
		end
	end
end
--[[把conditionTypes转化为运算用的数据
--conditionTypes自定义的分析类型s
--]]
function DCAnalysisMgr:conditionTypes2Calculation(conditionTypes)
	if conditionTypes==nil then return end

	local calculation = {}
	--[[
	设置限制的连号数
	3，表示有3个或以上的连号，则过滤掉
	0表示不识别连号
	]]
	calculation.evenCnt = 0
	--if _isKeyInList(condition.filterCustomSet, glg.DC.ANALYS_CUSTOM_TYPE_EVEN3) then
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_EVEN3) then
		calculation.evenCnt = 3
	elseif _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_EVEN4_6) then
		calculation.evenCnt = 4
	end
	calculation.even2In3 = false
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_2EVEN_IN3) then
		calculation.even2In3 = true
	end

	--[[
	设置限制的间隔号数
	3，表示有4个或以上的号，则过滤掉
	0表示不识别
	]]
	calculation.intervalCnt = 0
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_INTERVAL4_6) then
		calculation.intervalCnt = 4
	end

    --[[
	设置一注中单数过滤的个数
	0表示不处理单数情况
	]]
	calculation.singleCnt = 0
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_SINGLE5) then
		calculation.singleCnt = 5
	elseif _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_A_SINGLE) then
		calculation.singleCnt = 6
	end
	--[[
	设置一注中双数过滤的个数
	0表示不处理双数情况
	]]	
	calculation.doubleCnt = 0
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_DOUBLE5) then
		calculation.doubleCnt = 5
	elseif _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_A_DOUBLE) then
		calculation.doubleCnt = 6
	end

	--[[号码叠加限制]]
	--calculation.redOver = 0
	-- if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_R_SUM_OVER) then
	-- 	calculation.redOver = 145
	-- end
	--calculation.redLess = 0
	-- if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_R_SUM_LESS) then
	-- 	calculation.redLess = 64
	-- end

	--[[区间限制]]
	calculation.sectionOver = 0
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_SECTION_OVER4) then
		calculation.sectionOver = 4
	elseif _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_SECTION_OVER) then
		calculation.sectionOver = 5
	end
	calculation.section1_2_in3 = false
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_SECTION_1_2_IN3) then
		calculation.section1_2_in3 = true
	end
	calculation.section_each_in3 = false
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_SECTION_EACH_IN3) then
		calculation.section_each_in3 = true
	end
	

	--[[前期红号随机条件限制]]
	calculation.lastSame = false
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_LAST_SAME) then
		calculation.lastSame = true
	end

	--[[前期蓝号限制]]
	calculation.lastBlue = false
	if _isKeyInList(conditionTypes, glg.DC.ANALYS_CUSTOM_TYPE_LAST_BLUE) then
		calculation.lastBlue = true
	end

	--LOG_INFO("DCAnalysisMgr", "condition = %s", gp.table.tostring(self.condition))
	return calculation
end

function DCAnalysisMgr:_toConditionInfo( conditionData )
	local calculation = self:conditionTypes2Calculation(conditionData.filterCustomSet)
	local evenCnt = calculation.evenCnt
	local singleCnt = calculation.singleCnt
	local doubleCnt = calculation.doubleCnt
	local filterRedSet = conditionData.filterRedSet
	local selRedSet = conditionData.hitRedSet

	local contextArr = {}
	if filterRedSet and #filterRedSet>0 then
		table.insert(contextArr, string.format(_TT("dc","DC31"),table.concat(filterRedSet, ", ")))
	end
	if selRedSet and #selRedSet>0 then
		table.insert(contextArr, string.format(_TT("dc","DC32"),table.concat(selRedSet, ", ")))
	end
	if conditionData.filterEvenSet and #conditionData.filterEvenSet>0 then
		local nStr = {}
		for _,v in ipairs(conditionData.filterEvenSet) do
			table.insert(nStr, string.format("%d~%d",v,v+1))
		end
		table.insert(contextArr, string.format("过滤指定连号:%s",table.concat(nStr, ", ")))
	end
	if conditionData.filterIntervalSet and #conditionData.filterIntervalSet>0 then
		local nStr = {}
		for _,v in ipairs(conditionData.filterIntervalSet) do
			table.insert(nStr, string.format("%d~%d",v,v+2))
		end
		table.insert(contextArr, string.format("过滤指定间隔号:%s",table.concat(nStr, ", ")))
	end
	if conditionData.seqRange1Set and #conditionData.seqRange1Set>0 then
		table.insert(contextArr, string.format("过滤1号位:%s",table.concat(conditionData.seqRange1Set, ", ")))
	end
	if conditionData.seqRange2Set and #conditionData.seqRange2Set>0 then
		table.insert(contextArr, string.format("过滤2号位:%s",table.concat(conditionData.seqRange2Set, ", ")))
	end
	if conditionData.seqRange3Set and #conditionData.seqRange3Set>0 then
		table.insert(contextArr, string.format("过滤3号位:%s",table.concat(conditionData.seqRange3Set, ", ")))
	end
	if conditionData.seqRange4Set and #conditionData.seqRange4Set>0 then
		table.insert(contextArr, string.format("过滤4号位:%s",table.concat(conditionData.seqRange4Set, ", ")))
	end
	if conditionData.seqRange5Set and #conditionData.seqRange5Set>0 then
		table.insert(contextArr, string.format("过滤5号位:%s",table.concat(conditionData.seqRange5Set, ", ")))
	end
	if conditionData.seqRange6Set and #conditionData.seqRange6Set>0 then
		table.insert(contextArr, string.format("过滤6号位:%s",table.concat(conditionData.seqRange6Set, ", ")))
	end
	
	if conditionData.redOver and conditionData.redOver>0 then
		table.insert(contextArr, string.format(_TT("dc","DC71"),conditionData.redOver))
	end
	if conditionData.redLess and conditionData.redLess>0 then
		table.insert(contextArr, string.format(_TT("dc","DC72"),conditionData.redLess))
	end
	
	-----------------------------------
	table.insert(contextArr, string.format(_TT("dc","DC28"),evenCnt))
	if calculation.even2In3==true then
		table.insert(contextArr, _TT("dc","DC19"))
	end
	if calculation.intervalCnt>0 then
		table.insert(contextArr, string.format("过滤%d个或以上间隔号", calculation.intervalCnt))
	end
	table.insert(contextArr, string.format(_TT("dc","DC29"),singleCnt))
	table.insert(contextArr, string.format(_TT("dc","DC30"),doubleCnt))
	
	if calculation.sectionOver and calculation.sectionOver==5 then
		table.insert(contextArr, _TT("dc","DC73"))
	elseif calculation.sectionOver and calculation.sectionOver==4 then
		table.insert(contextArr, _TT("dc","DC76"))
	end
	if calculation.section_each_in3==true then
		table.insert(contextArr, _TT("dc","DC97"))
	elseif calculation.section1_2_in3==true then
		table.insert(contextArr, _TT("dc","DC96"))
	end
	if calculation.lastSame==true then
		table.insert(contextArr, _TT("dc","DC74"))
	end
	if calculation.lastBlue==true then
		table.insert(contextArr, _TT("dc","DC75"))
	end
	
	return table.concat(contextArr, "\n");
end
function DCAnalysisMgr:showConditionView( alertCall, condition )
	local context = self:_toConditionInfo(self.condition)
	if alertCall then
		gp.Factory:alertViewStd(_TT("dc","DC27"), context, alertCall)
	else
		gp.Factory:tipsView(_TT("dc","DC27"), context)
	end
end

function DCAnalysisMgr:showTempConditionView( id )
	local temp = GMODEL(MOD.DC):getDCStorageMgr():getConditionWithId(id)
	if temp then
		gp.Factory:tipsView(_TT("dc","DC27"), self:_toConditionInfo(temp))
	else
		gp.Factory:noiceView("NO CONTIDION DATA")
	end 
end

--[[
从条件数据中，取出一条幸运数据
]]
function DCAnalysisMgr:getTheOne(conditionId, callback)
	local result = self.conditionResultMap[conditionId]
	if result then
		if callback then
			local allData = GMODEL(MOD.DC):getDCMgr():getAllDataMap()
			local tmpResult = {}
			for _,v in ipairs(result) do
				if self:_filter1(v, result) then
					table.insert(tmpResult, v)
				end
			end
			
			local idx = self:_randomIdxOne(tmpResult)
			callback(tmpResult[idx])
		end
	else
		local function _resultCall(resultList, resultCnt)
			if resultCnt>0 then
				if callback then
					local allData = GMODEL(MOD.DC):getDCMgr():getAllDataMap()
					local tmpResult = {}
					for _,v in ipairs(resultList) do
						if self:_filter1(v, resultList) then
							table.insert(tmpResult, v)
						end
					end
					local idx = self:_randomIdxOne(tmpResult)
					callback(tmpResult[idx])
				end
			else
				gp.Factory:noiceView("没有数据可抽取")
			end
		end
		self:start(conditionId, _resultCall)
	end
end

local function _tmpRondom( rondomNum, buse )
	if buse then
		if rondomNum>1 then
			local tmpMid = gp.math.randomEX(0,rondomNum)
			if tmpMid~=rondomNum then
				buse = false
				rondomNum = tmpMid
			end
		end
		return rondomNum, buse
	else
		return gp.math.randomEX(0,9), buse
	end
end
function DCAnalysisMgr:_randomIdxOne(dataList)
	local idx = 1
	local tmpTotal = #dataList
	local tmpMid = 0
	local tmpBMax = true
	if tmpTotal > 1 then
		local oht_u = math.modf(tmpTotal/100000)
		local tt_u = math.modf((tmpTotal-oht_u*100000)/10000)	
		local k_u = math.modf((tmpTotal-oht_u*100000-tt_u*10000)/1000)
		local h_u = math.modf((tmpTotal-oht_u*100000-tt_u*10000-k_u*1000)/100)
		local t_u = math.modf((tmpTotal-oht_u*100000-tt_u*10000-k_u*1000-h_u*100)/10)
		local abit_u = (tmpTotal-oht_u*100000-tt_u*10000-k_u*1000-h_u*100-t_u*10)
		--[[
		print("oht_u "..oht_u)
		print("tt_u "..tt_u)
		print("k_u "..k_u)
		print("h_u "..h_u)
		print("t_u "..t_u)
		print("abit_u "..abit_u)
		--]]
		oht_u, tmpBMax = _tmpRondom(oht_u, tmpBMax)
		tt_u, tmpBMax = _tmpRondom(tt_u, tmpBMax)
		k_u, tmpBMax = _tmpRondom(k_u, tmpBMax)
		h_u, tmpBMax = _tmpRondom(h_u, tmpBMax)
		t_u, tmpBMax = _tmpRondom(t_u, tmpBMax)
		abit_u, tmpBMax = _tmpRondom(abit_u, tmpBMax)

		idx = oht_u*100000+tt_u*10000+k_u*1000+h_u*100+t_u*10+abit_u
		--[[
		print("========================")
		print("oht_u "..oht_u)
		print("tt_u "..tt_u)
		print("k_u "..k_u)
		print("h_u "..h_u)
		print("t_u "..t_u)
		print("abit_u "..abit_u)
		print("idx "..idx)
		--]]
		return idx
	end
end

--[[
开始筛选条件数据
]]
function DCAnalysisMgr:start(conditionId, callback)
	local condition = GMODEL(MOD.DC):getDCStorageMgr():getConditionWithId(conditionId)
	if condition==nil or callback==nil then return end

	if self.isAnalysising == true then
		gp.Factory:noiceView("正在进行分析工作，请稍候再试")
		return
	end
	local result = self.conditionResultMap[conditionId]
	if result then
		callback(result, #result)
		return
	end
	

	gp.Factory:waitView()
	self.conditionId = conditionId
	self.condition = condition
	self.condition.filterRedSet = self.condition.filterRedSet or {}
	self.condition.hitRedSet = self.condition.hitRedSet or {}
	self.condition.filterEvenSet = self.condition.filterEvenSet or {}
	self.condition.filterIntervalSet= self.condition.filterIntervalSet or {}
	self.condition.seqRange1Set = self.condition.seqRange1Set or {}
	self.condition.seqRange2Set = self.condition.seqRange2Set or {}
	self.condition.seqRange3Set = self.condition.seqRange3Set or {}
	self.condition.seqRange4Set = self.condition.seqRange4Set or {}
	self.condition.seqRange5Set = self.condition.seqRange5Set or {}
	self.condition.seqRange6Set = self.condition.seqRange6Set or {}
	self.condition.redOver = self.condition.redOver or 0
	self.condition.redLess = self.condition.redLess or 0

	self.calculation = self:conditionTypes2Calculation(condition.filterCustomSet)
	
	self.tempResultCall = callback
	self.tempRetList = {}
	self.filterCnt = 1

	self.filterLen = #self.orgDataList
	
	self.isAnalysising = true

	gp.TickMgr:register(self)
end

function DCAnalysisMgr:tick(  )	
	local v = nil
	for i=1,8000 do
		v = self.orgDataList[self.filterCnt]
		if self:_customFilter(v) then
			table.insert(self.tempRetList, v)
		end

		self.filterCnt = self.filterCnt+1

		if self.filterCnt>=self.filterLen then
			gp.TickMgr:unRegister(self)			
			self.isAnalysising = false
			local resultCnt = #self.tempRetList
			LOG_INFO("", "RESULT NUM = %d", resultCnt)
			self.conditionResultMap[self.conditionId] = self.tempRetList
			if self.tempResultCall then
				self.tempResultCall(self.tempRetList, resultCnt)
			end
			JOWinMgr:Instance():clear(gd.LAYER_WAIT)
			--gp.MessageMgr:dispatchEvent(gei.DC_ANALYSIS_RESULT)

			return
		end
	end
end


--[[
过滤往期组合
]]
function DCAnalysisMgr:_filter1(data, allDataMap)
	--local key = table.concat(data,",")
	--local key = string.format("%02d,%02d,%02d,%02d,%02d,%02d",data[1],data[2],data[3],data[4],data[5],data[6])
	local key = data[1]+data[2]*100+data[3]*10000+data[4]*1000000+data[5]*100000000+data[6]*10000000000
	if allDataMap[key] then
		return false
	end
	return true
end
--[[
自定义过滤条件
]]
local _evenTime = 0
local _evenCount = 0
local _evenLastData1 = nil

local _singleCnt = 0 --判断是不是全单
local _doubleCnt = 0 --判断是不是全单
local _redSum = 0 --检测红球相加的总和数
local _beFindHitRedNum = false
function DCAnalysisMgr:_customFilter(data)
	if self:_filterNum(data) or
		--self:_fixedHitNum(data) or
		self:_filterSequenceRange(data) or
		self:_filterRedOverLess(data) or 
		self:_filterSingle_Double(data) or
		self:_filterEven(data) or 
		self:_filterInterval(data) or
		self:_filterFixedEven(data) or
		self:_filterFixedInterval(data) or
		self:_filterSectionOver(data) or
		self:_filterLastSame(data) --or 
		--self:_filterLastBlue(data)
		 then
		--LOG_INFO("", gp.table.tostring(data))
		return false
	end

	return true
end
--被过滤的，返回true
--去除3\4~6连号
function DCAnalysisMgr:_filterEven( data )
	if self.calculation.evenCnt<2 then return false end
	_evenTime = 0
	_evenCount = 1
	_evenLastData1 = -1

	for _,v in ipairs(data) do
		if v==_evenLastData1+1 then
			_evenCount = _evenCount+1
		else
			if _evenCount>1 then
				_evenTime = _evenTime+1
				_evenCount = 1
			end
		end
		
		if _evenCount>=self.calculation.evenCnt then
			return true
		end
		_evenLastData1 = v
	end

	if self.calculation.even2In3==true and _evenTime>1 then
		return true
	end
end

--去除全单\全双
function DCAnalysisMgr:_filterSingle_Double( data )
	if self.calculation.singleCnt<1 and self.calculation.doubleCnt<1 then
		return false
	end
	_singleCnt = 0 --判断是不是全单
	_doubleCnt = 0 --判断是不是全单
	
	for _,v in ipairs(data) do
		if v%2 == 0 then
			_doubleCnt = _doubleCnt+1
		else
			_singleCnt = _singleCnt+1
		end
	end
	if _doubleCnt>=self.calculation.doubleCnt then
		return true
	end
	if _singleCnt>=self.calculation.singleCnt then
		return true
	end
end

function DCAnalysisMgr:_filterInterval( data )
	if self.calculation.intervalCnt<2 then return false end
	_evenTime = 0
	_evenCount = 1
	_evenLastData1 = -1

	for _,v in ipairs(data) do
		if v==_evenLastData1+2 then
			_evenCount = _evenCount+1
		else
			if _evenCount>1 then
				_evenTime = _evenTime+1
				_evenCount = 1
			end
		end
		
		if _evenCount>=self.calculation.intervalCnt then
			return true
		end
		_evenLastData1 = v
	end
	--默认过滤一条数据有3组间隔号的情况
	if _evenTime==3 then
		return true
	end
end

--去除指定号码
function DCAnalysisMgr:_filterNum( data )
	--if not self.condition.filterRedSet then return false end
	for _,k in ipairs(self.condition.filterRedSet) do		
		for _,v in ipairs(data) do
			if k==v then
				return true
			end
		end
	end
end

local findFixed = false
--确认有指定号码
function DCAnalysisMgr:_fixedHitNum( data )		
	--if not self.condition.hitRedSet then return false end
	for _,k in ipairs(self.condition.hitRedSet) do
		findFixed = false
		for _,v in ipairs(data) do
			if v==k then
				findFixed = true
				break
			end
		end
		if findFixed==false then
			return true
		end
	end
end

--过滤指定连号
function DCAnalysisMgr:_filterFixedEven( data )
	--if not self.condition.filterEvenSet then return false end
	
	for _,k in ipairs(self.condition.filterEvenSet) do
		_evenLastData1 = -1
		for _,v in ipairs(data) do
			if k==v then
				_evenLastData1 = k
			elseif _evenLastData1==k and k+1==v then
				return true
			end
		end
	end
end

function DCAnalysisMgr:_filterFixedInterval( data )
	--if #self.condition.filterIntervalSet==0 then return false end
	
	for _,k in ipairs(self.condition.filterIntervalSet) do
		_evenLastData1 = -1
		for _,v in ipairs(data) do
			if k==v then
				_evenLastData1 = k
			elseif _evenLastData1==k and k+2==v then
				return true
			end
		end
	end
end
--去除总和超过的数据
function DCAnalysisMgr:_filterRedOverLess( data )
	if self.condition.redOver<1 and self.condition.redLess<1 then return false end
	_redSum = 0
	for _,v in ipairs(data) do
		_redSum=_redSum+v
	end
	if _redSum>self.condition.redOver then
		return true
	end
	if _redSum<self.condition.redLess then
		return true
	end
end
--去除顺序范围的数据
function DCAnalysisMgr:_filterSequenceRange(data)
	--if not self.condition.seqRange1Set then return false end
	for _,k in ipairs(self.condition.seqRange1Set) do
		if data[1]==k then
			return true
		end
	end
	for _,k in ipairs(self.condition.seqRange2Set) do
		if data[2]==k then
			return true
		end
	end
	for _,k in ipairs(self.condition.seqRange3Set) do
		if data[3]==k then
			return true
		end
	end
	for _,k in ipairs(self.condition.seqRange4Set) do
		if data[4]==k then
			return true
		end
	end
	for _,k in ipairs(self.condition.seqRange5Set) do
		if data[5]==k then
			return true
		end
	end
	for _,k in ipairs(self.condition.seqRange6Set) do
		if data[6]==k then
			return true
		end
	end
end


local function _inTen1Section( v )
	if v<11 then
		return true
	end
end
local function _inTen2Section( v )
	if v>10 and v<21 then
		return true
	end
end
local function _inTen3Section( v )
	if v>20 and v<34 then
		return true
	end
end

local tenCnt = 0
local ten2Cnt = 0
local ten3Cnt = 0

--过滤同区间4\5个或以上组合
function DCAnalysisMgr:_filterSectionOver( data )
	if self.calculation.sectionOver<1 then return false end	
	tenCnt = 0
	ten2Cnt = 0
	ten3Cnt = 0
	for _,v in ipairs(data) do
		if _inTen1Section(v) then
			tenCnt = tenCnt+1
		elseif _inTen2Section(v) then
			ten2Cnt = ten2Cnt+1
		elseif _inTen3Section(v) then
			ten3Cnt = ten3Cnt+1
		end
	end
	if tenCnt>=self.calculation.sectionOver or ten2Cnt>=self.calculation.sectionOver or ten3Cnt>=self.calculation.sectionOver then
		return true
	end

	if self.calculation.section_each_in3==true then
		if (tenCnt==3 and ten2Cnt==3) or (tenCnt==3 and ten3Cnt==3) or (ten3Cnt==3 and ten2Cnt==3) then
			return true
		end
	elseif self.calculation.section1_2_in3==true then
		if tenCnt==3 and ten2Cnt==3 then
			return true
		end
	end

end

local lastSameCnt = 0
--过滤与最新期有3或以上相同
function DCAnalysisMgr:_filterLastSame( data )
	if self.calculation.lastSame~=true then return false end
	lastSameCnt = 0
	local newd = GMODEL(MOD.DC):getDCMgr():getNewDCData()
	--LOG_DEBUG(" ", gp.table.tostring(newd))
	for _,v in ipairs(data) do
		--if v==newd.r1 or v==newd.r2 or v==newd.r3 or v==newd.r4 or v==newd.r5 or v==newd.r6 then
		if v==newd.r[1] or v==newd.r[2] or v==newd.r[3] or v==newd.r[4] or v==newd.r[5] or v==newd.r[6] then
			lastSameCnt = lastSameCnt+1
		end
	end

	if lastSameCnt>3 then
		--LOG_DEBUG(" ", gp.table.tostring(newd))
		--LOG_DEBUG(" ", gp.table.tostring(data))
		--LOG_DEBUG(" ", "lastSameCnt "..lastSameCnt)
		return true
	end
end

--忽略上期蓝球
function DCAnalysisMgr:_filterLastBlue( data )
	if self.calculation.lastBlue~=true then return false end
	local newd = GMODEL(MOD.DC):getDCMgr():getNewDCData()
	for _,v in ipairs(data) do
		if v==newd.b1 then
			return true		
		end
	end
end

function DCAnalysisMgr:_comb(total, cnt)
	local dataList = {}
	local i=1
	local j=1
	local a = {}
	a[1] = 1
	while(true) do
		if a[i]-(i-1)<=total-cnt+1 then
			if (i==cnt) then
				local data = {}
				for j=1, cnt do
					table.insert(data, a[j])
				end
				table.insert(dataList, data)
				a[i] = a[i]+1
			else
				i=i+1
				a[i] = a[i-1]+1
			end
		else
			if i==1 then
				break
			end
			i = i-1
			a[i] = a[i]+1
		end
	end
	return dataList
end

return DCAnalysisMgr
