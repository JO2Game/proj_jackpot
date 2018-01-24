
local MENU_LAYER = 10
local UIAnalysisView = class("UIAnalysisView", gp.BaseNode)

function UIAnalysisView:ctor()
	UIAnalysisView.super.ctor(self)
	self:setCatchTouch(true)
	local selfSize = cc.size(gd.VISIBLE_SIZE.width-260, gd.VISIBLE_SIZE.height-74+12)
	self:setContentSize(selfSize)

	self:_initPeriodUI()
	self:_initGraph()
	
end

function UIAnalysisView:setPeriodVisible(visible)
	self.period:setVisible(visible)
	self.startBtn:setVisible(visible)
end
--由子类实现
function UIAnalysisView:onSelStageRange(fromStage, toStage)
	--self.graph:setDataList(redRateDataList, blueRateDataList)
end

function UIAnalysisView:_initPeriodUI( )
	local period = MCLASS(MOD.DC, "UIPeriodView").new()
	period:setPeriodSize(cc.size(100, 40))
	period:setFromToSize(cc.size(100, 40))
	period:setTableHeight(self:getContentSize().height-period:getContentSize().height-80)
	self:addChild(period, MENU_LAYER)
	_VLP(period, self, vl.IN_TL, cc.p(20, -10))

	local allData = GMODEL(MOD.DC):getDCMgr():getAllData()
	local yearKeys = gp.table.keys(allData)
	table.sort( yearKeys, _yearSort )
	local periodDatas = {"自定义", "全部", "最近100", "最近200"}
	for _,v in ipairs(yearKeys) do
		table.insert(periodDatas, v)
	end
	period:setPeriodDataList(periodDatas)
	period:setPeriodSel(2)
	
	local stageMap = GMODEL(MOD.DC):getDCMgr():getAllStage()
	self.allStage = gp.table.keys(stageMap)
	table.sort(self.allStage)
	period:setFromDataList(self.allStage)
	period:setToDataList(self.allStage)
	period:setFromSel(1)
	period:setToSel(#self.allStage)

	local function _periodCall( sender, idx )
		local yearIdx = idx-5
		local totalLen = #self.allStage
		local fromIdx = 1
		if idx==1 then
			return		
		elseif idx==3 then
			fromIdx = totalLen-99
		elseif idx==4 then
			fromIdx = totalLen-199
		elseif yearIdx>0 then
			fromIdx = 1
			local curYear = 2003
			local targetYear = yearKeys[yearIdx]
			for i=1, targetYear-2003 do
				fromIdx = fromIdx+gp.table.nums(allData[curYear])
				curYear = curYear+1
			end
			totalLen = gp.table.nums(allData[targetYear])+fromIdx-1		
		end
		if fromIdx<1 then
			fromIdx = 1
		end
		period:setFromToSel(fromIdx, totalLen)
	end

	local function _fromToCall( sender, fromIdx, toIdx )
		if fromIdx < 1 then
			fromIdx = 1
		end
		if toIdx < 1 then
			toIdx = #self.allStage
		end
		period:setPeriodSel(1)
		period:setFromSel(fromIdx)
		period:setToSel(toIdx)
	end

	period:setPeriodCall(_periodCall)
	period:setFromToCall(_fromToCall)
	self.period = period

	local function _call( sender )
		local from, to = self.period:getSelFromTo()
		self:onSelStageRange(self.allStage[from], self.allStage[to])
	end
	self.startBtn = gp.Button:create("DoBtn_V2.png", _call)
	self.startBtn:setScale(0.68)
	self:addChild(self.startBtn, MENU_LAYER)
	_VLP(self.startBtn, self.period, vl.OUT_R, cc.p(20,0))
end

function UIAnalysisView:_initGraph( )
	local selfSize = self:getContentSize()
	local graph = MCLASS(MOD.DC, "UIDataGraphView").new(cc.size(selfSize.width, selfSize.height-self.period:getContentSize().height-60))
	self:addChild(graph)
	_VLP(graph, self, vl.IN_B, cc.p(0, 10))

	self.graph = graph
end

return UIAnalysisView

