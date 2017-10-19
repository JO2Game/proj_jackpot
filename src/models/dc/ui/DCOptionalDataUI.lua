--[[
=================================
文件名：DCOptionalDataUI.lua
作者：James Ou
显示自选的条件数据
=================================
]]
local OPTIONAL_SIZE = cc.size(210, 40)

local DCOptionalDataUI = class("DCOptionalDataUI", glg.UIDropView)

function DCOptionalDataUI:ctor()
	DCOptionalDataUI.super.ctor(self)

	self.tableView = nil	
	self.titleList = {}
	self.titleCount = 0

	self:_initTableView()
	self:_initScrollView()

	self.title:setString("自选数据")
	
end

function DCOptionalDataUI:setOptionalInfo( infoStr )
	self.contentLb:setString(infoStr)
	local viewSize = self.scroll:getViewSize()
	local lbSize = self.contentLb:getContentSize()
	if viewSize.height<lbSize.height+60 then
		self.scroll:setContentSize(cc.size(OPTIONAL_SIZE.width, self.contentLb:getContentSize().height+60))
	end
	_VLP(self.contentLb, self.scroll:getContainer(), vl.IN_TL, cc.p(4,-2))
	_VLP(self.listBtn, self.scroll:getContainer(), vl.IN_B, cc.p(0,10))
	
	--self.scroll:setContentOffset(cc.p(0,viewSize.height-lbSize.height-4))
	self.scroll:setContentOffset(cc.p(0,self.scroll:minContainerOffset().y))
end

function DCOptionalDataUI:_initTableView()
	local tableView = gp.TableView.new(cc.size(OPTIONAL_SIZE.width, (self:getContentSize().height-80)*0.4))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setMargin(8)
	self:addChild(tableView)
	tableView:setRadioOrMultiselect(gd.CELL_RADIO)
	_VLP(tableView, self, vl.IN_T, cc.p(0,-70))
	self.selId = -1
	
	local function _selDataCall( sender, id, beSel )
		local temp = GMODEL(MOD.DC):getDCStorageMgr():getConditionWithId(id)
		if beSel and temp then
			self.selId = id
			self.unknowSpr:setVisible(false)
			self.removeBtn:setVisible(true)
			self.actionBtn:setVisible(true)
			self.scroll:setVisible(true)
			self:setOptionalInfo(GMODEL(MOD.DC):getDCAnalysisMgr():_toConditionInfo(temp))
		else
			self.selId = -1
			self.unknowSpr:setVisible(true)
			self.removeBtn:setVisible(false)
			self.actionBtn:setVisible(false)
			self.scroll:setVisible(false)
		end
		self:getParent().optionalResultView:setVisible(false)
	end

	local function _cellSizeForTable(table,idx)
	    return OPTIONAL_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
		if nil == cell then
		    cell = glg.UICommonCell.new(OPTIONAL_SIZE, _selDataCall, true)
		end
		local data = self.titleList[idx]
		cell:setData(os.date("%x %X",data), data)

		return cell
	end

	local function _numberOfCellsInTableView(table)
	    return self.titleCount
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)

	--tableView:reloadData()
	self.tableView = tableView
end

function DCOptionalDataUI:_initScrollView()
	self.scroll = gp.ScrollView.new()
	self:addChild(self.scroll)
	self.scroll:setAnchorPoint(cc.p(0.5,0.5))
	self.scroll:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	local scrollSize = cc.size(OPTIONAL_SIZE.width, (self:getContentSize().height-80)*0.6-50)
	self.scroll:setViewSize(scrollSize)
	_VLP(self.scroll, self.tableView, vl.OUT_B, cc.p(0, -50))
	self.scroll:setVisible(false)
	self.scroll:setContentSize(scrollSize)
	self.contentLb = gp.Label:create("", 16)
	self.contentLb:setDimensions(OPTIONAL_SIZE.width-8, 0)

	self.scroll:addChild(self.contentLb)


	local function _resultCall(resultList, resultCnt)
		if resultCnt>0 then
			self:getParent().optionalResultView:setupData(resultList, resultCnt)
			--self.resultView:setupData(resultList, resultCnt)
		else
			self:getParent().optionalResultView:setupData(nil, 0)
			gp.Factory:noiceView("没有数据")
		end
	end

	local function _getOneCall(data)
		local function _alertCall(sender, tag)
			if tag == gd.ALERT_OK then
				GMODEL(MOD.DC):getDCStorageMgr():insertDrawData(data)
			end
		end
		gp.Factory:alertViewStd(nil, string.format(_TT("dc","DC40"), table.concat(data, ",")) , _alertCall)	
	end

	local function _btnCall( sender )
		local tag = sender:getTag()
		if tag==1 then
			GMODEL(MOD.DC):getDCStorageMgr():removeConditionWithId(self.selId)
			GMODEL(MOD.DC):getDCAnalysisMgr():removeConditionResult(self.selId)
			self:setupData()
			self.selId = -1
			self.unknowSpr:setVisible(true)
			self.removeBtn:setVisible(false)
			self.actionBtn:setVisible(false)
			self.scroll:setVisible(false)

			self.tableView:clearSel()
			self:getParent().optionalResultView:setVisible(false)
		elseif tag==2 then
			local theLottery = MCLASS(MOD.DC, "DCTheLotteryUI").new()
			theLottery:setSelId(self.selId)
			JOWinMgr:Instance():showWin(theLottery, gd.LAYER_TIPS)
			self:getParent().drawResultUI:setVisible(true)
			--GMODEL(MOD.DC):getDCAnalysisMgr():getTheOne(self.selId, _getOneCall)
			--self:getParent().optionalResultView:setVisible(false)
		elseif tag==3 then
			local resultView = self:getParent().optionalResultView
			local beVisible = resultView:isVisible()
			if not beVisible then
				GMODEL(MOD.DC):getDCAnalysisMgr():start(self.selId, _resultCall)
			end
			resultView:setVisible(not beVisible)
			-- if beVisible then
			-- 	_VLP(self.resultView, self, vl.OUT_R)
			-- end
		end
	end

	self.removeBtn = gp.Button:create("Btn_Small_Red.png", _btnCall, true, "删除")
	self.removeBtn:setContentSize(cc.size(100,40))
	self.removeBtn:setTitleArg("", 18)
	self.removeBtn:setTag(1)
	self:addChild(self.removeBtn)
	self.removeBtn:setVisible(false)
	_VLP(self.removeBtn, self.tableView, vl.OUT_B_IN_L, cc.p(0,-2))

	self.actionBtn = gp.Button:create("Btn_Small_Gold.png", _btnCall, true, "开奖")
	self.actionBtn:setContentSize(cc.size(100,40))
	self.actionBtn:setTitleArg("", 18)
	self.actionBtn:setTag(2)
	self:addChild(self.actionBtn)
	self.actionBtn:setVisible(false)
	_VLP(self.actionBtn, self.tableView, vl.OUT_B_IN_R, cc.p(0,-2))

	self.listBtn = gp.Button:create("Btn_Small_Gold.png", _btnCall, true, "列表")
	self.listBtn:setContentSize(cc.size(100,40))
	self.listBtn:setTitleArg("", 18)
	self.listBtn:setTag(3)
	self.scroll:addChild(self.listBtn)
	_VLP(self.listBtn, self.scroll:getContainer(), vl.IN_B, cc.p(0,10))
	
	self.unknowSpr = gp.Sprite:create("defaultNull.png")
	self:addChild(self.unknowSpr)
	--self.unknowSpr:setScale(2)
	_VLP(self.unknowSpr, self.scroll, vl.CENTER, cc.p(0, 20))
	
end

function DCOptionalDataUI:setupData()
	local function _tmpSort(a, b)
		if a>b then
			return true
		end
		return false
	end
	local tmpSet = GMODEL(MOD.DC):getDCStorageMgr():getConditionSet()
	local keys = gp.table.keys(tmpSet)
	table.sort(keys, _tmpSort)
	self.titleList = keys
	self.titleCount = #self.titleList
	self.tableView:reloadData()
end

function DCOptionalDataUI:onEnter(  )
	DCOptionalDataUI.super.onEnter(self)

	local function _ADD_CONDITION_DATA_Handle()
		self.selId = -1
		self.unknowSpr:setVisible(true)
		self.removeBtn:setVisible(false)
		self.actionBtn:setVisible(false)
		self.scroll:setVisible(false)

		
		self:getParent().optionalResultView:setVisible(false)
		self.tableView:clearSel()
	end
	
	gp.MessageMgr:registerEvent(self.sn, gei.DC_ADD_CONDITION_DATA, _ADD_CONDITION_DATA_Handle)
end


function DCOptionalDataUI:onExit()
	gp.MessageMgr:unRegisterAll(self.sn)
	DCOptionalDataUI.super.onExit(self)
end

return DCOptionalDataUI
