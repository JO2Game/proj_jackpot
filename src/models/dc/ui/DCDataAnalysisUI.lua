--[[
=================================
文件名：DCDataAnalysisUI.lua
作者：James Ou
=================================
]]
local FUNCTION_CELL_SIZE = cc.size(200, 40)
local DESC_CELL_SIZE = cc.size(gd.VISIBLE_SIZE.width-300, 40)


local DataCell =  class("DataCell", gp.TableViewCell )

function DataCell:ctor(size)
	DataCell.super.ctor(self)
	self:setContentSize(size)
	self.cellSize = size

	self.title = gp.Label:create("", 20, gd.FCOLOR.c7)
	self.title:setOutline(1, gd.FCOLOR.c9)
	self.title:setAnchorPoint(cc.p(0, 0.5))
	self.title:setDimensions(size.width, 0);
	self:addChild(self.title)
	_VLP(self.title, self, vl.IN_L)
end

function DataCell:setString( str, size, color )
	if size then
		self.title:setFontSize(size)
	end
	if color then
		self.title:setLabelColor(color)
	end
	self.title:setString(str)
	if self.title:getContentSize().height > self.cellSize.height then
		self:setContentSize(cc.size(self.cellSize.width, self.title:getContentSize().height+10))
	else
		self:setContentSize(self.cellSize)
	end
	_VLP(self.title, self, vl.IN_L)
end


local DCDataAnalysisUI = class("DCDataAnalysisUI", gp.BaseNode)

function DCDataAnalysisUI:ctor()
	DCDataAnalysisUI.super.ctor(self)
	self:setContentSize(cc.size(gd.VISIBLE_SIZE.width, gd.VISIBLE_SIZE.height-74+12))	
	
	self.functList = {}
	self:_initFunctionList()
	self:_initTableView()

	self.descList = {}
	self:_initDescTableView()

	self.appearUI = MCLASS(MOD.DC, "DCAppearAnalysisUI").new()
	self:addChild(self.appearUI)
	_VLP(self.appearUI, self.functTableView, vl.OUT_R)
	self.appearUI:setVisible(false)

	self.sumUI = MCLASS(MOD.DC, "DCSumAnalysisUI").new()
	self:addChild(self.sumUI)
	_VLP(self.sumUI, self.functTableView, vl.OUT_R)
	self.sumUI:setVisible(false)

	self.evenUI = MCLASS(MOD.DC, "DCEvenAnalysisUI").new()
	self:addChild(self.evenUI)
	_VLP(self.evenUI, self.functTableView, vl.OUT_R)
	self.evenUI:setVisible(false)
	
	self.seqRangeUI = MCLASS(MOD.DC, "DCSeqRangeAnalysisUI").new()
	self:addChild(self.seqRangeUI)
	_VLP(self.seqRangeUI, self.functTableView, vl.OUT_R)
	self.seqRangeUI:setVisible(false)

	self.intervalUI = MCLASS(MOD.DC, "DCIntervalAnalysisUI").new()
	self:addChild(self.intervalUI)
	_VLP(self.intervalUI, self.functTableView, vl.OUT_R)
	self.intervalUI:setVisible(false)
	
	
end

function DCDataAnalysisUI:onEnter(  )
	DCDataAnalysisUI.super.onEnter(self)

	GMODEL(MOD.DC):getDCStatisticsMgr():numCount_desc()
	self.descList = gp.table.mergeList(
		 			--GMODEL(MOD.DC):getDCStatisticsMgr():numCount_desc(),
					GMODEL(MOD.DC):getDCStatisticsMgr():lastBlueBallInRed_desc(),
					GMODEL(MOD.DC):getDCStatisticsMgr():sameSection_desc(),
					GMODEL(MOD.DC):getDCStatisticsMgr():even_desc(),
					GMODEL(MOD.DC):getDCStatisticsMgr():twoEven_desc(),
					GMODEL(MOD.DC):getDCStatisticsMgr():Interval3Even_desc()
					)
	gp.table.insertTo(self.descList,{string.format("总组合数:%d条",#GMODEL(MOD.DC):getDCAnalysisMgr().orgDataList)},1)
	self.descTableView:reloadData()
end

function DCDataAnalysisUI:_initTableView()

	local tableView = gp.TableView.new(cc.size(FUNCTION_CELL_SIZE.width+12, self:getContentSize().height-12))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setMargin(10)
    tableView:setRadioOrMultiselect(gd.CELL_RADIO)
	self:addChild(tableView)
	_VLP(tableView, self, vl.IN_L, cc.p(8, -6))

	local function _cellCall(sender, data, beSel)

		self.descTableView:setVisible(not beSel)
		if data==1 then
			self.appearUI:setVisible(beSel)
		elseif data==2 then
			self.sumUI:setVisible(beSel)
		elseif data==3 then
			self.evenUI:setVisible(beSel)
		elseif data==4 then
			self.seqRangeUI:setVisible(beSel)
		elseif data==5 then
			self.intervalUI:setVisible(beSel)
		else
			self.descTableView:setVisible(true)
		end
	end

	local function _cellSizeForTable(table,idx)
	    return FUNCTION_CELL_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)

	    if nil == cell then
	        cell = glg.UICommonCell.new(FUNCTION_CELL_SIZE, _cellCall, true)
	    end
	    local data = self.functList[idx]
	    cell:setData(data.t, data.i)

	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.functList
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)
	
	tableView:reloadData()
	self.functTableView = tableView
end

function DCDataAnalysisUI:_initFunctionList()
	
	table.insert(self.functList,
		{t=_TT("dc","DC45"), i=1}
	)
	table.insert(self.functList,
		{t=_TT("dc","DC65"), i=2}
	)	
	table.insert(self.functList,
		{t=_TT("dc","DC99"), i=3}
	)
	table.insert(self.functList,
		{t="顺序范围", i=4}
	)
	table.insert(self.functList,
		{t="间隔号", i=5}
	)
end

function DCDataAnalysisUI:_initDescTableView()

	self.descTableView = gp.TableView.new(cc.size(DESC_CELL_SIZE.width+20, self:getContentSize().height-100))
    self.descTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.descTableView:setMargin(20)
	self:addChild(self.descTableView)
	_VLP(self.descTableView, self.functTableView, vl.OUT_R, cc.p(40, 0))

	local function _cellSizeForTable(table,idx)
	    return DESC_CELL_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
	    if nil == cell then
	        cell = DataCell.new(DESC_CELL_SIZE)
	    end
	    cell:setString(self.descList[idx])

	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.descList
	end

	self.descTableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	self.descTableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	self.descTableView:setHandler(_tableCellAtIndex, gd.CELL)
	
end

return DCDataAnalysisUI
