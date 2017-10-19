--[[
=================================
文件名：DCConditionUI.lua
作者：James Ou
显示条件过滤信息
=================================
]]

--[[
手动指定的过滤信息
--]]
local PAD_TYPE = {}
PAD_TYPE.FULL = 1
PAD_TYPE.KEYPAD = 2
PAD_TYPE.EVEN = 3
PAD_TYPE.FULL_HIT = 4
PAD_TYPE.PAD_HIT = 5
PAD_TYPE.INTERVAL = 6
PAD_TYPE.NUM_PAD = 7

local TmpSelNumUI = class("TmpSelNumUI", gp.BaseNode)
function TmpSelNumUI:ctor(size, txt, call, numType)
	TmpSelNumUI.super.ctor(self)
	self:setContentSize(size)
	self.call = call
	self.nums = {}
	self.numType = numType
	local function _numPadCall( sender, nums )
		self:setSelNums(nums)
		if self.call then
			self.call(self, self.nums)
		end
	end

	local function _btnCall( sender )
		if self.numType==PAD_TYPE.FULL then
			local fullNum = glg.DCFullNumView.new()
			fullNum:setDefSelNum(self.nums)
			fullNum:setOkCall(_numPadCall)
			if self.unableSelCall then
				local unableData = self.unableSelCall(self)
				fullNum:setUnableSelNum(unableData.nums, unableData.call)
			end
			JOWinMgr:Instance():showWin(fullNum, gd.LAYER_WIN)
		elseif self.numType==PAD_TYPE.KEYPAD then
			local pad = glg.DCKeypadView.new()
			pad:setDefSelNum(self.nums)
			pad:setOkCall(_numPadCall)
			JOWinMgr:Instance():showWin(pad, gd.LAYER_WIN)
		elseif self.numType==PAD_TYPE.EVEN then
			local even = glg.DCEvenNumView.new()
			even:setDefSelNum(self.nums)
			even:setOkCall(_numPadCall)
			JOWinMgr:Instance():showWin(even, gd.LAYER_WIN)
		elseif self.numType==PAD_TYPE.FULL_HIT then
			local fullNum = glg.DCFullNumView.new()
			fullNum:setMaxSelCount(6)
			fullNum:setDefSelNum(self.nums)
			fullNum:setOkCall(_numPadCall)
			if self.unableSelCall then
				local unableData = self.unableSelCall(self)
				fullNum:setUnableSelNum(unableData.nums, unableData.call)
			end
			JOWinMgr:Instance():showWin(fullNum, gd.LAYER_WIN)
		elseif self.numType==PAD_TYPE.INTERVAL then
			local interval = glg.DCIntervalNumView.new()
			interval:setDefSelNum(self.nums)
			interval:setOkCall(_numPadCall)
			JOWinMgr:Instance():showWin(interval, gd.LAYER_WIN)
		elseif self.numType==PAD_TYPE.NUM_PAD then
			local numPad = glg.DCNumpadView.new()
			numPad:setMaxNum(200)
			numPad:setDefNum(self.nums[1])
			numPad:setupData()
			numPad:setOkCall(_numPadCall)
			JOWinMgr:Instance():showWin(numPad, gd.LAYER_WIN)
		end
	end
	self.filterNumBtn = gp.Button:create("Top2Bg_V2.png", _btnCall, true, txt)
	self.filterNumBtn:setContentSize(cc.size(120,38))
	self.filterNumBtn:setTitleArg("", 17, gd.FCOLOR.c1, 0)
	self:addChild(self.filterNumBtn)

	self.filterBg = gp.Scale9Sprite:create("Top1Bg_V2.png")
	self:addChild(self.filterBg)

	self.filterLb = gp.Label:create("",18)
	self.filterLb:setAnchorPoint(cc.p(0,1))
	self.filterLb:setDimensions(size.width-10, 0)
	self.filterBg:addChild(self.filterLb)

	self:_layout()
end

function TmpSelNumUI:setUnableSelCall(unableSelCall)
	self.unableSelCall = unableSelCall
end

function TmpSelNumUI:setSelNums( nums )
	if self.numType==PAD_TYPE.NUM_PAD then
		if nums==nil then
			nums = 0
		end
		self.nums = {}
		table.insert(self.nums, nums)
		self.filterLb:setString(nums)
		self:_layout()
		return
	end
	if nums==nil or (type(nums)=="table" and #nums==0) then
		self.nums = {}
		self.filterLb:setString("")
		self:_layout()
		return
	end
	table.sort(nums)
	self.nums = nums
	if self.numType==PAD_TYPE.EVEN then
		local nStr = {}
		for _,v in ipairs(nums) do
			table.insert(nStr, string.format("%d~%d",v,v+1))
		end
		self.filterLb:setString(table.concat(nStr, ", "))
	elseif self.numType==PAD_TYPE.INTERVAL then
		local nStr = {}
		for _,v in ipairs(nums) do
			table.insert(nStr, string.format("%d~%d",v,v+2))
		end
		self.filterLb:setString(table.concat(nStr, ", "))
	else
		self.filterLb:setString(table.concat(nums, ", "))
	end
	
	self:_layout()
end

function TmpSelNumUI:_layout()
	local lbSize = self.filterLb:getContentSize()
	self.filterBg:setContentSize(cc.size(lbSize.width+10, lbSize.height+8))
	
	self:setContentSize(cc.size(self:getContentSize().width, lbSize.height+50+10))

	_VLP(self.filterNumBtn, self, vl.IN_TL)
	_VLP(self.filterBg, self.filterNumBtn, vl.OUT_B_IN_L, cc.p(0,-6))
	_VLP(self.filterLb)
end

local TmpFilterUI = class("TmpFilterUI", gp.BaseNode)
function TmpFilterUI:ctor(size)
	TmpFilterUI.super.ctor(self)
	self:setContentSize(size)
	self.orgSize = size

	self.condition = {}

	self.scroll = gp.ScrollView.new()
	self:addChild(self.scroll)
	self.scroll:setAnchorPoint(cc.p(0.5,0.5))
	self.scroll:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.scroll:setViewSize(size)
	_VLP(self.scroll)

	local function _btnCall( sender, nums )
		local tag = sender:getTag()
		if tag==1 then
			self.condition.filterRedSet = nums
		elseif tag==2 then
			self.condition.filterBlueSet = nums
		elseif tag==3 then
			self.condition.filterEvenSet = nums
		elseif tag==4 then
			self.condition.hitRedSet = nums
		elseif tag>4 and tag<11 then
			local idx = tag-4
			self.condition["seqRange"..idx.."Set"] = nums
		elseif tag==11 then
			self.condition.filterIntervalSet = nums
		elseif tag==12 then
			self.condition.redOver = nums[1]
		elseif tag==13 then
			self.condition.redLess = nums[1]
		end
		self:reLoadScrollSize()
	end

	local function _unableSelCall(sender)
		local tag = sender:getTag()
		local unableData = {}
		if tag==1 or (tag>4 and tag<11) then
			local function _noiceCall(num)
				gp.Factory:noiceView(string.format("不能过滤指定中的数据[%d]",num))
			end
			unableData.nums = self.condition.hitRedSet
			unableData.call = _noiceCall
		elseif tag==4 then
			local function _noiceCall(num)
				gp.Factory:noiceView(string.format("不能指定过滤中的数据[%d]",num))
			end
			--unableData.nums = self.condition.filterRedSet
			unableData.nums = gp.table.mergeList(self.condition.filterRedSet, self.condition.seqRange1Set, self.condition.seqRange2Set, self.condition.seqRange3Set, self.condition.seqRange4Set, self.condition.seqRange5Set, self.condition.seqRange6Set) 
			unableData.call = _noiceCall
		end
		return unableData
	end

	self.filterRedView = TmpSelNumUI.new(cc.size(size.width,300), "过滤红球", _btnCall, PAD_TYPE.FULL)
	self.filterRedView:setTag(1)
	self.scroll:addChild(self.filterRedView)
	self.filterRedView:setUnableSelCall(_unableSelCall)

	self.filterBlueView = TmpSelNumUI.new(cc.size(size.width,300), "过滤蓝球", _btnCall, PAD_TYPE.KEYPAD)
	self.filterBlueView:setTag(2)
	self.scroll:addChild(self.filterBlueView)

	self.filterEvenView = TmpSelNumUI.new(cc.size(size.width,300), "过滤连号", _btnCall, PAD_TYPE.EVEN)
	self.filterEvenView:setTag(3)
	self.scroll:addChild(self.filterEvenView)

	self.hitRedView = TmpSelNumUI.new(cc.size(size.width,300), "指定红球", _btnCall, PAD_TYPE.FULL_HIT)
	self.hitRedView:setTag(4)
	self.scroll:addChild(self.hitRedView)
	self.hitRedView:setUnableSelCall(_unableSelCall)
	self.hitRedView:setVisible(false)

	for i=1,6 do
		local viewName = "seqRange"..i.."View"
		self[viewName] = TmpSelNumUI.new(cc.size(size.width,300), "过滤顺序"..i, _btnCall, PAD_TYPE.FULL)
		self[viewName]:setTag(i+4)
		self.scroll:addChild(self[viewName])
		self[viewName]:setUnableSelCall(_unableSelCall)
	end

	self.filterIntervalView = TmpSelNumUI.new(cc.size(size.width,300), "过滤间隔号", _btnCall, PAD_TYPE.INTERVAL)
	self.filterIntervalView:setTag(11)
	self.scroll:addChild(self.filterIntervalView)

	self.sumMaxView = TmpSelNumUI.new(cc.size(size.width,300), "总和上限", _btnCall, PAD_TYPE.NUM_PAD)
	self.sumMaxView:setTag(12)
	self.scroll:addChild(self.sumMaxView)

	self.sumMinView = TmpSelNumUI.new(cc.size(size.width,300), "总和下限", _btnCall, PAD_TYPE.NUM_PAD)
	self.sumMinView:setTag(13)
	self.scroll:addChild(self.sumMinView)
	--[[
	self.seqRange1View = TmpSelNumUI.new(cc.size(size.width,300), "过滤顺序1", _btnCall, PAD_TYPE.FULL_HIT)
	self.seqRange1View:setTag(5)
	self.scroll:addChild(self.seqRange1View)
	self.seqRange1View:setUnableSelCall(_unableSelCall)

	self.seqRange2View = TmpSelNumUI.new(cc.size(size.width,300), "过滤顺序2", _btnCall, PAD_TYPE.FULL_HIT)
	self.seqRange2View:setTag(5)
	self.scroll:addChild(self.seqRange2View)
	self.seqRange2View:setUnableSelCall(_unableSelCall)

	self.seqRange3View = TmpSelNumUI.new(cc.size(size.width,300), "过滤顺序3", _btnCall, PAD_TYPE.FULL_HIT)
	self.seqRange3View:setTag(5)
	self.scroll:addChild(self.seqRange3View)
	self.seqRange3View:setUnableSelCall(_unableSelCall)

	self.seqRange4View = TmpSelNumUI.new(cc.size(size.width,300), "过滤顺序4", _btnCall, PAD_TYPE.FULL_HIT)
	self.seqRange4View:setTag(5)
	self.scroll:addChild(self.seqRange4View)
	self.seqRange4View:setUnableSelCall(_unableSelCall)

	self.seqRange5View = TmpSelNumUI.new(cc.size(size.width,300), "过滤顺序5", _btnCall, PAD_TYPE.FULL_HIT)
	self.seqRange5View:setTag(5)
	self.scroll:addChild(self.seqRange5View)
	self.seqRange5View:setUnableSelCall(_unableSelCall)

	self.seqRange6View = TmpSelNumUI.new(cc.size(size.width,300), "过滤顺序6", _btnCall, PAD_TYPE.FULL_HIT)
	self.seqRange6View:setTag(5)
	self.scroll:addChild(self.seqRange6View)
	self.seqRange6View:setUnableSelCall(_unableSelCall)
	--]]

	self:reLoadScrollSize()
end

function TmpFilterUI:setFilterData(condition)
	self.filterRedView:setSelNums(condition.filterRedSet)
	self.filterBlueView:setSelNums(condition.filterBlueSet)
	self.filterEvenView:setSelNums(condition.filterEvenSet)
	self.hitRedView:setSelNums(condition.hitRedSet)
	for i=1,6 do
		self["seqRange"..i.."View"]:setSelNums(condition["seqRange"..i.."Set"])
	end
	self.filterIntervalView:setSelNums(condition.filterIntervalSet)

	self.sumMaxView:setSelNums(condition.redOver)
	self.sumMinView:setSelNums(condition.redLess)
	
	--[[
	self.seqRange1View:setSelNums(condition.seqRange1Set)
	self.seqRange2View:setSelNums(condition.seqRange2Set)
	self.seqRange3View:setSelNums(condition.seqRange3Set)
	self.seqRange4View:setSelNums(condition.seqRange4Set)
	self.seqRange5View:setSelNums(condition.seqRange5Set)
	self.seqRange6View:setSelNums(condition.seqRange6Set)
	--]]
	self.condition = condition
	self:reLoadScrollSize()
	self.scroll:setContentOffset(self.scroll:minContainerOffset())
end

function TmpFilterUI:reLoadScrollSize(  )
	local offset = self.scroll:getContentOffset()
	local h = 0
	h=h+self.filterRedView:getContentSize().height+4
	h=h+self.filterBlueView:getContentSize().height+4
	h=h+self.filterEvenView:getContentSize().height+4
	h=h+self.filterIntervalView:getContentSize().height+4
	--h=h+self.hitRedView:getContentSize().height+4
	h=h+self.sumMaxView:getContentSize().height+4
	h=h+self.sumMinView:getContentSize().height+4
	for i=1,6 do
		h=h+self["seqRange"..i.."View"]:getContentSize().height+4
	end
	local scrollSize = cc.size(self.orgSize.width, h)
	local container = self.scroll:getContainer()
	if scrollSize.height<self.orgSize.height then
		scrollSize = self.orgSize
	end
	self.scroll:setContentSize(scrollSize)
	
	_VLP(self.filterRedView, container, vl.IN_T)
	_VLP(self.filterBlueView, self.filterRedView, vl.OUT_B, cc.p(0,-4))
	_VLP(self.filterEvenView, self.filterBlueView, vl.OUT_B, cc.p(0,-4))
	_VLP(self.filterIntervalView, self.filterEvenView, vl.OUT_B, cc.p(0,-4))
	--_VLP(self.hitRedView, self.filterIntervalView, vl.OUT_B, cc.p(0,-4))
	_VLP(self.sumMinView, self.filterIntervalView, vl.OUT_B, cc.p(0,-4))
	_VLP(self.sumMaxView, self.sumMinView, vl.OUT_B, cc.p(0,-4))
	local vlTarget = self.sumMaxView
	for i=1,6 do
		_VLP(self["seqRange"..i.."View"], vlTarget, vl.OUT_B, cc.p(0,-4))
		vlTarget = self["seqRange"..i.."View"]
	end
	self.scroll:setContentOffset(offset)
end
------------------------------------------------------------------------------------
--[[
智能的条件信息
--]]
local TmpAIUI = class("TmpAIUI", gp.BaseNode)
function TmpAIUI:ctor(size)
	TmpAIUI.super.ctor(self)
	self:setContentSize(size)
	self.orgSize = size

	self.tcBtns = {}
	self.selConditions = {}

	self.scroll = gp.ScrollView.new()
	self:addChild(self.scroll)
	self.scroll:setAnchorPoint(cc.p(0.5,0.5))
	self.scroll:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)	
	self.scroll:setViewSize(cc.size(size.width, size.height-50))
	_VLP(self.scroll, self, vl.IN_B, cc.p(0, 10))

	local function _clearCall( sender )
		for _,v in pairs(self.tcBtns) do
			v:setBtnState(gd.BTN_NOR)
		end
		self.selConditions = {}
	end
	self.clearBtn = gp.Button:create("Top2Bg_V2.png", _clearCall, true, "清空")
	self.clearBtn:setContentSize(cc.size(100,38))
	self.clearBtn:setTitleArg("", 17, gd.FCOLOR.c1, 0)
	self:addChild(self.clearBtn)
	_VLP(self.clearBtn, self.scroll, vl.OUT_T_IN_L, cc.p(0,6))

	local function _checkCall(sender, beSel)
		local key = sender:getTag()
		if beSel==false then
			self.selConditions[key] = nil
		else
			self.selConditions[key] = true
			self:_setCheckKey(key)
		end
	end
	
	local dataCnt = gp.table.nums(glg.DC.ANALYS_CUSTOM)
	
	self.scroll:setContentSize(cc.size(self.orgSize.width, dataCnt*40))
	self.scroll:setContentOffset(cc.p(0,self.scroll:minContainerOffset().y))

	local analysKey = gp.table.keys(glg.DC.ANALYS_CUSTOM)
	table.sort(analysKey)

	local relationTarget = self.scroll:getContainer()
	local relationType = vl.IN_TL
	local relationPos = cc.p(0,0)
	local otherPos = cc.p(0,-10)
	for _,k in ipairs(analysKey) do
		local v = glg.DC.ANALYS_CUSTOM[k]
		local tc = gp.TextCheck.new("gui_box7.png", "gui_btn8.png", v, 14)
		tc:setCallback(_checkCall)
		tc:setTag(k)
		self.scroll:addChild(tc)
		self.tcBtns[k] = tc
		_VLP(tc, relationTarget, relationType, relationPos)
		
		relationTarget = tc
		relationType = vl.OUT_B_IN_L
		relationPos = otherPos
	end
end

function TmpAIUI:getSelConditions()
	return self.selConditions
end

function TmpAIUI:setFilterData(condition)
	if condition and condition.filterCustomSet then
		for k,v in pairs(self.tcBtns) do
			v:setBtnState(gd.BTN_NOR)
			self.selConditions[k] = nil
		end
		for _,k in ipairs(condition.filterCustomSet) do
			self.selConditions[k] = true
			local tc = self.tcBtns[k]
			if tc then
				tc:setBtnState(gd.BTN_SEL)
			end
		end
	end
end


local NOR_TYPE_LIST = {
glg.DC.ANALYS_CUSTOM_TYPE_EVEN4_6,
glg.DC.ANALYS_CUSTOM_TYPE_EVEN3,
glg.DC.ANALYS_CUSTOM_TYPE_2EVEN_IN3,

glg.DC.ANALYS_CUSTOM_TYPE_A_SINGLE,
glg.DC.ANALYS_CUSTOM_TYPE_A_DOUBLE,
glg.DC.ANALYS_CUSTOM_TYPE_SINGLE5,
glg.DC.ANALYS_CUSTOM_TYPE_DOUBLE5,
glg.DC.ANALYS_CUSTOM_TYPE_R_SUM_OVER,
glg.DC.ANALYS_CUSTOM_TYPE_R_SUM_LESS,

--glg.DC.ANALYS_CUSTOM_TYPE_SECTION_OVER,
--glg.DC.ANALYS_CUSTOM_TYPE_SECTION_1_2_IN3
}

function TmpAIUI:_setCheckKey( key )
	if key == glg.DC.ANALYS_CUSTOM_TYPE_ALL then
		for k,v in pairs(self.tcBtns) do
			v:setBtnState(gd.BTN_SEL)
			self.selConditions[k] = true
		end
	elseif key == glg.DC.ANALYS_CUSTOM_TYPE_NOR then
		for _,k in ipairs(NOR_TYPE_LIST) do
			local val = self.tcBtns[k]
			if val then
				val:setBtnState(gd.BTN_SEL)
				self.selConditions[k] = true
			end
		end	
	end
end

------------------------------------------------------------------------------------
--[[
条件信息主显示窗
--]]
local DCConditionUI = class("DCConditionUI", glg.UIDropView)

function DCConditionUI:ctor()
	DCConditionUI.super.ctor(self)

	self.title:setString("条件信息")
	
	local btn1 = gp.Button:create("Btn_Small_Gold.png", nil, true, "过滤条件")
	btn1:setContentSize(cc.size(100,40))
	btn1:setTitleArg("", 18)
	btn1:setTag(1)
	self:addChild(btn1)
	_VLP(btn1, self.title, vl.OUT_B_IN_L, cc.p(0, -34))

	local btn2 = gp.Button:create("Btn_Small_Gold.png", nil, true, "智能条件")
	btn2:setContentSize(cc.size(100,40))
	btn2:setTitleArg("", 18)
	btn2:setTag(2)
	self:addChild(btn2)
	_VLP(btn2, btn1, vl.OUT_R, cc.p(20, 0))

	
	local SUB_UI_SIZE = self:getContentSize()
	SUB_UI_SIZE.width = SUB_UI_SIZE.width-8
	SUB_UI_SIZE.height = SUB_UI_SIZE.height-130-80

	self.filterUI = TmpFilterUI.new(SUB_UI_SIZE)
	self:addChild(self.filterUI)
	_VLP(self.filterUI, self, vl.IN_B, cc.p(0, 64))
	self.filterUI:setVisible(false)

	self.aiUI = TmpAIUI.new(SUB_UI_SIZE)
	self:addChild(self.aiUI)
	_VLP(self.aiUI, self, vl.IN_B, cc.p(0, 64))
	self.aiUI:setVisible(false)

	local function _tabCall( key, tag )
		if key==1 then
			self.filterUI:setVisible(true)
			self.aiUI:setVisible(false)
		else
			self.aiUI:setVisible(true)
			self.filterUI:setVisible(false)
		end
	end

	local btnMap = {}
	btnMap[1] = btn1
	btnMap[2] = btn2
	local tabCtrl = gp.TabCtrl.new(btnMap, _tabCall)
	tabCtrl:setSelKey(1)

	local function _saveCall( sender )
		self.conditionData.filterRedSet = self.filterUI.condition.filterRedSet
		self.conditionData.filterBlueSet = self.filterUI.condition.filterBlueSet
		self.conditionData.filterEvenSet = self.filterUI.condition.filterEvenSet
		self.conditionData.hitRedSet = self.filterUI.condition.hitRedSet
		for i=1,6 do
			self.conditionData["seqRange"..i.."Set"] = self.filterUI.condition["seqRange"..i.."Set"]
		end
		local selConditions = self.aiUI:getSelConditions()
		local filterCustomSet = gp.table.keys(selConditions)
		self.conditionData.filterCustomSet = filterCustomSet
		GMODEL(MOD.DC):getDCStorageMgr():saveCondition()
	end

	local btn3 = gp.Button:create("Btn_Small_Red.png", _saveCall, true, "保存")
	btn3:setContentSize(cc.size(90,40))
	btn3:setTitleArg("", 18)
	btn3:setTag(3)
	self:addChild(btn3)
	_VLP(btn3, self, vl.IN_BR, cc.p(0, 10))

	local function _addCall( sender )
		GMODEL(MOD.DC):getDCStorageMgr():saveConditionToSet()
	end
	local btn4 = gp.Button:create("Btn_Small_Red.png", _addCall, true, "添加")
	btn4:setContentSize(cc.size(90,40))
	btn4:setTitleArg("", 18)
	btn4:setTag(4)
	self:addChild(btn4)
	_VLP(btn4, self, vl.IN_BL, cc.p(0, 10))
end

function DCConditionUI:setupData()
	self.conditionData = GMODEL(MOD.DC):getDCStorageMgr():getCondition()
	self.filterUI:setFilterData(self.conditionData)
	self.aiUI:setFilterData(self.conditionData)
end

function DCConditionUI:onEnter(  )
	DCConditionUI.super.onEnter(self)
	
	--[[
	LOG_INFO("", gp.table.tostring(self.conditionData.hitRedSet))
	LOG_INFO("", gp.table.tostring(self.conditionData.hitBlueSet))
	LOG_INFO("", gp.table.tostring(self.conditionData.filterRedSet))
	LOG_INFO("", gp.table.tostring(self.conditionData.filterBlueSet))
	LOG_INFO("", gp.table.tostring(self.conditionData.filterCustomSet))	
	--]]
end

return DCConditionUI
