--[[
=================================
文件名：UIDataGraphView.lua
作者：James Ou
=================================
]]

local BTN_SIZE = cc.size(100, 50)
local DATA_CELL_SIZE = cc.size(360, 30)
local GRAPH_CELL_SIZE = cc.size(60, 300)

local SCROLL_COL_WIDTH = 30
local SCROLL_ROW_WIDTH = 40

local SCROLLBALL_CELL_SIZE = cc.size(50, SCROLL_ROW_WIDTH)
local SCROLLSTAGE_CELL_SIZE = cc.size(SCROLL_COL_WIDTH, 30)

local DataCell =  class("DataCell", gp.TableViewCell )

function DataCell:ctor(size)
	DataCell.super.ctor(self)
	self:setContentSize(size)

	self.title = gp.Label:create("", 18, gd.FCOLOR.c12)
	--self.title:setOutline(2, gd.FCOLOR.c9)
	self.title:setAnchorPoint(cc.p(0, 0.5))
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
end

function DataCell:setData(data)
	self.title:setString(string.format(_TT("dc","DC61"), data.ball, data.total))
end

local UIDataGraphView = class("UIDataGraphView", gp.BaseNode)

function UIDataGraphView:ctor(size)
	UIDataGraphView.super.ctor(self, size)
	self:setContentSize(size)

	self.curRateDataList = {}
	self.redRateDataList = {}
	self.blueRateDataList = {}
	
	self:_initBtn()

	self.isShowDataTable = false
	self.isShowCurve = true

	local selfSize = self:getContentSize()
	local contentW = selfSize.width-10
	local contentH = selfSize.height-self.chartBtn:getContentSize().height-16

	self:_initDataTable(cc.size(contentW, contentH))
	self:_initGraphTable(cc.size(contentW, contentH))
	self:_initCurveScrollView(cc.size(contentW, contentH))

	self:_layout()

	self.graphTableView:setVisible(true)
end

function UIDataGraphView:setSize(size)
	self:setContentSize(size)
	local selfSize = self:getContentSize()
	local contentW = selfSize.width-10
	local contentH = selfSize.height-self.chartBtn:getContentSize().height-16
	local subSize = cc.size(contentW, contentH)
	self.dataTableView:setViewSize(subSize)
	self.graphTableView:setSize(subSize)
	self.curveView:setSize(subSize)
	
	self:_layout()
end

--设置是否显示数据列表,默认不显示
function UIDataGraphView:showDataTable(bEnble)
	self.isShowDataTable = bEnble
	if self.isShowDataTable==false then
		if self.chartBtn:getTitleString() == _TT("dc","DC57") then
			self.chartBtn:setTitle(_TT("dc","DC59"))
			self.graphTableView:setVisible(true)
		end
	end
end
--设置是否显示曲线图表,默认显示
function UIDataGraphView:showCurve(bEnble)
	self.isShowCurve = bEnble
	if self.isShowCurve==false then
		if self.chartBtn:getTitleString() == _TT("dc","DC58") then
			self.chartBtn:setTitle(_TT("dc","DC59"))
			self.graphTableView:setVisible(true)
		end
	end
end
--设置Ball按键的回调
function UIDataGraphView:setBallBtnCall(call, title)
	self.ballBtn:setTitle(title)
	self.ballBtn:setCall(call)
end

function UIDataGraphView:setDataList( redRateDataList, blueRateDataList )
	self.redRateDataList = redRateDataList or {}
	self.blueRateDataList = blueRateDataList or {}
	self.curRateDataList = self.redRateDataList
	--self.ballBtn:setTitle(_TT("dc","DC62"))
	self:_updateDataOrder()
	self:reloadData()
end

function UIDataGraphView:reloadData(  )
	if self.dataTableView:isVisible()==true then
		self.dataTableView:reloadData()
	elseif self.graphTableView:isVisible()==true then
		self.graphTableView:reloadData()
	elseif self.curveView:isVisible()==true then
		self:_reloadScroll()
	end
end

function UIDataGraphView:onEnter(  )
	UIDataGraphView.super.onEnter(self)	
end

function UIDataGraphView:onExit(  )	
	UIDataGraphView.super.onExit(self)
end

local function _norSort( a, b )
	if a.ball < b.ball then
		return true
	end
	return false
end

local function _ascendingSort( a, b )
	if a.total < b.total then
		return true
	end
	return false
end

local function _descendingSort( a, b )
	if a.total > b.total then
		return true
	end
	return false
end

function UIDataGraphView:_updateDataOrder()
	if self.functionBtn:getTitleString() == _TT("dc","DC55") then
		table.sort(self.redRateDataList, _ascendingSort)
		table.sort(self.blueRateDataList, _ascendingSort)
	elseif self.functionBtn:getTitleString() == _TT("dc","DC56") then
		table.sort(self.redRateDataList, _descendingSort)
		table.sort(self.blueRateDataList, _descendingSort)
	elseif self.functionBtn:getTitleString() == _TT("dc","DC54") then
		table.sort(self.redRateDataList, _norSort)
		table.sort(self.blueRateDataList, _norSort)
	end
end
function UIDataGraphView:_initBtn()
	local function _btnCall( sender )
		local tag = sender:getTag()
		if tag==1 then
			if sender:getTitleString() == _TT("dc","DC54") then
				sender:setTitle(_TT("dc","DC55"))
				table.sort(self.redRateDataList, _ascendingSort)
				table.sort(self.blueRateDataList, _ascendingSort)
			elseif sender:getTitleString() == _TT("dc","DC55") then
				sender:setTitle(_TT("dc","DC56"))
				table.sort(self.redRateDataList, _descendingSort)
				table.sort(self.blueRateDataList, _descendingSort)
			elseif sender:getTitleString() == _TT("dc","DC56") then
				sender:setTitle(_TT("dc","DC54"))
				table.sort(self.redRateDataList, _norSort)
				table.sort(self.blueRateDataList, _norSort)
			end
			self:reloadData()
		elseif tag==2 then
			self.graphTableView:setVisible(false)
			self.dataTableView:setVisible(false)
			self.curveView:setVisible(false)
			
			if self.isShowDataTable==false or self.isShowCurve==false then

				if sender:getTitleString() == _TT("dc","DC57") then
					if self.isShowCurve==false and self.isShowDataTable==false then
						sender:setTitle(_TT("dc","DC57"))
						self.graphTableView:setVisible(true)
					elseif self.isShowCurve==false then
						sender:setTitle(_TT("dc","DC58"))
						self.dataTableView:setVisible(true)
					elseif self.isShowDataTable==false then
						sender:setTitle(_TT("dc","DC59"))
						self.curveView:setVisible(true)
					end
				else
					sender:setTitle(_TT("dc","DC57"))
					self.graphTableView:setVisible(true)
				end
			else
				if sender:getTitleString() == _TT("dc","DC57") then
					sender:setTitle(_TT("dc","DC58"))
					self.dataTableView:setVisible(true)
				elseif sender:getTitleString() == _TT("dc","DC58") then
					sender:setTitle(_TT("dc","DC59"))
					self.curveView:setVisible(true)
				elseif sender:getTitleString() == _TT("dc","DC59") then
					sender:setTitle(_TT("dc","DC57"))
					self.graphTableView:setVisible(true)
				end
			end
			
			self:reloadData()
		elseif tag==3 then
			if sender:getTitleString() == _TT("dc","DC62") and self.blueRateDataList and #self.blueRateDataList>0 then
				sender:setTitle(_TT("dc","DC63"))
				self.curRateDataList = self.blueRateDataList
				self:reloadData()
			elseif sender:getTitleString() == _TT("dc","DC63") then
				sender:setTitle(_TT("dc","DC62"))
				self.curRateDataList = self.redRateDataList
				self:reloadData()
			end
		end
	end
	self.functionBtn = gp.Button:create("gui_box8.png", _btnCall, _TT("dc","DC54"))
	self.functionBtn:setContentSize(BTN_SIZE)
	self:addChild(self.functionBtn, 2)
	self.functionBtn:setTag(1)

	self.chartBtn = gp.Button:create("gui_box8.png", _btnCall, _TT("dc","DC57"))
	self.chartBtn:setContentSize(BTN_SIZE)
	self:addChild(self.chartBtn, 2)
	self.chartBtn:setTag(2)

	self.ballBtn = gp.Button:create("gui_box8.png", _btnCall, _TT("dc","DC62"))
	self.ballBtn:setContentSize(BTN_SIZE)
	self:addChild(self.ballBtn, 2)
	self.ballBtn:setTag(3)

end

function UIDataGraphView:_initDataTable( size )
	self.dataTableView = gp.TableView.new(size)
	self.dataTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self:addChild(self.dataTableView)	
	self.dataTableView:setVisible(false)

	local function _cellSizeForTable(table,idx)		
	    return DATA_CELL_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
	    if nil == cell then
	        cell = DataCell.new(DATA_CELL_SIZE)
	    end
	    
	    local data = self.curRateDataList[idx]
	    cell:setData(data)

	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.curRateDataList
	end

	self.dataTableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	self.dataTableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	self.dataTableView:setHandler(_tableCellAtIndex, gd.CELL)

end

function UIDataGraphView:_initGraphTable( size )
	self.graphTableView = MCLASS(MOD.DC, "UICylinderGraphView").new(size)
	local function _dataSource( sender, idx )
		local d = self.curRateDataList[idx]
		return d.ball, d.total, d.percent
	end
	local function _dataSourceNum( sender )
		return #self.curRateDataList
	end
	self.graphTableView:setDataSource(_dataSource)
	self.graphTableView:setSourceNumberCall(_dataSourceNum)
	self.graphTableView:setCellSize(GRAPH_CELL_SIZE)
	self.graphTableView:setLineColor(cc.c4f(0.3,0.5,0.1,1), cc.c4f(0.7,0.6,0.25,1))

	self:addChild(self.graphTableView)
end

function UIDataGraphView:_initCurveScrollView( size )

	local function _leftCall( sender, idx )
		return self.scrollBallList[idx]
	end

	local function _bottomCall( sender, idx )
		return self.scrollStageList[idx]
	end

	local function _curveCall( sender, row, col )
		local rateData = self.curRateDataList[row]
		return rateData.stageInfos[col].flag
	end
	self.curveView = MCLASS(MOD.DC, "UICurveGraphView").new(size)
	self:addChild(self.curveView)
	self.curveView:setVisible(false)
	--self.curveView:setLeft_BottomDataSourceInfo(#self.scrollBallList, SCROLLBALL_CELL_SIZE, #self.scrollStageList, SCROLLSTAGE_CELL_SIZE)
	self.curveView:setLeftDataSource(_leftCall)
	self.curveView:setBottomDataSource(_bottomCall)
	self.curveView:setCurveDataSource(_curveCall)
end

function UIDataGraphView:_layout(  )	
	_VLP(self.chartBtn, self, vl.IN_TR)
	_VLP(self.functionBtn, self.chartBtn, vl.OUT_L, cc.p(-20, 0))
	_VLP(self.ballBtn, self.functionBtn, vl.OUT_L, cc.p(-20, 0))

	_VLP(self.dataTableView, self, vl.IN_B)
	_VLP(self.graphTableView, self, vl.IN_B)
	_VLP(self.curveView, self, vl.IN_B)
end

function UIDataGraphView:_reloadScroll(  )

	if self.curRateDataList and #self.curRateDataList>0 then
		local info = self.curRateDataList[1]
		local stageInfos = info.stageInfos
		local totalStage = #stageInfos
		
		self.scrollBallList = {}
		self.scrollStageList = {}

		for i,v in ipairs(stageInfos) do
			if i==1 or i==totalStage or i%6==0 then
				table.insert(self.scrollStageList, v.stage)
			else
				table.insert(self.scrollStageList, " ")
			end
		end

		for i,v in ipairs(self.curRateDataList) do
			table.insert(self.scrollBallList, v.ball)		
		end
		self.curveView:setLeft_BottomDataSourceInfo(#self.scrollBallList, SCROLLBALL_CELL_SIZE, #self.scrollStageList, SCROLLSTAGE_CELL_SIZE)
		self.curveView:reloadData()
	end
end


return UIDataGraphView
