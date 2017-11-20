--[[
=================================
文件名：UIPeriodView.lua
作者：James Ou
=================================
]]

local PeriodCell =  class("PeriodCell", gp.TableViewCell )

function PeriodCell:ctor(size)
	PeriodCell.super.ctor(self)
    self:setContentSize(size)
        
    self.bg = gp.Scale9Sprite:create("No2Btn_V2.png")
	self.bg:setContentSize(self:getContentSize())
	self:addChild(self.bg)
	_VLP(self.bg, self)

	self.title = gp.Label:create("", 18, gd.FCOLOR.c7)
	self:addChild(self.title)
	_VLP(self.title, self)
end

function PeriodCell:setData(title)
	self.title:setString(title)	
end

function PeriodCell:changeSize( size )
	self:setContentSize(size)
	self.bg:setContentSize(self:getContentSize())
	_VLP(self.bg, self)
	_VLP(self.title, self)
end



local FUNCTION_CELL_SIZE = cc.size(100, 40)

local UIPeriodView = class("UIPeriodView", gp.BaseNode)

function UIPeriodView:ctor(title)
	UIPeriodView.super.ctor(self, title)

	self.dataList = {}
	self.periodList = {}
	self.fromList = {}
	self.toList = {}

	self.periodSelIdx = 0;
	self.fromSelIdx = 0;
	self.toSelIdx = 0;

	self:_initComponents()
end

function UIPeriodView:setPeriodSize( size )
	self.periodBtn:setContentSize(size)
	self.periodTableView:setViewSize(cc.size(size.width, self.periodTableView:getViewSize().height))
	self:_layout()
end

function UIPeriodView:setFromToSize( size )
	self.fromBtn:setContentSize(size)
	self.fromTableView:setViewSize(cc.size(size.width, self.fromTableView:getViewSize().height))
	self.toBtn:setContentSize(size)
	self.toTableView:setViewSize(cc.size(size.width, self.toTableView:getViewSize().height))
	self:_layout()
end

function UIPeriodView:setTableHeight( height )
	if self.periodTableView then
		self.periodTableView:setViewSize(cc.size(self.periodTableView:getViewSize().width, height))
	end
	if self.fromTableView then
		self.fromTableView:setViewSize(cc.size(self.fromTableView:getViewSize().width, height))
	end
	if self.toTableView then
		self.toTableView:setViewSize(cc.size(self.toTableView:getViewSize().width, height))
	end
	self:_layoutTable()
end

function UIPeriodView:setPeriodDataList( dataList )
	self.periodList = dataList
	self.periodSelIdx = 0
end

function UIPeriodView:setFromDataList( dataList )
	self.fromList = dataList
	self.fromSelIdx = 0
end

function UIPeriodView:setToDataList( dataList )
	self.toList = dataList
	self.toSelIdx = 0
end

function UIPeriodView:setPeriodCall( call )
	self.periodCall = call
end

function UIPeriodView:setFromToCall( call )
	self.fromToCall = call
end

function UIPeriodView:setPeriodSel( idx )
	self.periodSelIdx = idx
	if idx>0 and idx<=#self.periodList then
		self.periodBtn:setTitle(self.periodList[idx])
	else
		LOG_WARN("UIPeriodView", "idx[%s] error", tostring(idx))
	end
end

function UIPeriodView:setFromToSel( fromIdx, toIdx )
	if fromIdx>=toIdx then
		LOG_WARN("UIPeriodView", "fromIdx>=toIdx error")
		return
	end
	if toIdx>#self.toList then
		LOG_WARN("UIPeriodView", "toIdx>#self.toList error")
		return
	end
	self.fromSelIdx = fromIdx
	self.fromBtn:setTitle(self.fromList[fromIdx])
	self.toSelIdx = toIdx
	self.toBtn:setTitle(self.toList[toIdx])
	self.totalText:setString(string.format("[%d]", (self.toSelIdx-self.fromSelIdx+1)))
end

function UIPeriodView:setFromSel( idx )	
	if self.toSelIdx<2 then
		self.toSelIdx = #self.fromList
	end
	if idx>0 and idx<=self.toSelIdx and idx<=#self.fromList then
		self.fromSelIdx = idx
		self.fromBtn:setTitle(self.fromList[idx])
		self.totalText:setString(string.format("[%d]", (self.toSelIdx-self.fromSelIdx+1)))
	else
		LOG_WARN("UIPeriodView", "idx[%s] error", tostring(idx))
	end
end

function UIPeriodView:setToSel( idx )
	if self.fromSelIdx<1 then
		self.fromSelIdx = 1
	end	

	if idx>self.fromSelIdx and idx<=#self.toList then
		self.toSelIdx = idx
		self.toBtn:setTitle(self.toList[idx])
		self.totalText:setString(string.format("[%d]", (self.toSelIdx-self.fromSelIdx+1)))
	else
		LOG_WARN("UIPeriodView", "fromSelIdx %d #toList %d idx[%s] error",self.fromSelIdx, #self.toList, tostring(idx))
	end
end

function UIPeriodView:getSelFromTo(  )
	return self.fromSelIdx, self.toSelIdx
end

function UIPeriodView:onEnter(  )
	UIPeriodView.super.onEnter(self)
	local function _maskBeginCall(  )
		self.periodTableView:setVisible(false)
		self.fromTableView:setVisible(false)
		self.toTableView:setVisible(false)
		self.maskLayer:setVisible(false)
		return true
	end
	gp.touch.newTouch(self.maskLayer, true, _maskBeginCall)
end

function UIPeriodView:onExit(  )
	gp.touch.removeTouch(self.maskLayer)
	UIPeriodView.super.onExit(self)
end

function UIPeriodView:_initComponents()

	self.toText = gp.Label:create("--", 28, gd.FCOLOR.c7)
	self.toText:setAnchorPoint(0,0.5)
	self:addChild(self.toText)

	self.totalText = gp.Label:create("", 20, gd.FCOLOR.c7)
	self.totalText:setAnchorPoint(0,0.5)
	self:addChild(self.totalText)

	local function _btnCall( sender )
		local tag = sender:getTag()
		local beVisible = false
		if tag==1 and self.periodTableView then
			self.periodTableView:setVisible(not self.periodTableView:isVisible())
			if self.periodTableView:isVisible() then
				beVisible = true
				self.dataList = self.periodList
				self.periodTableView:reloadData()
				if self.periodSelIdx>0 then
					self.periodTableView:scrollToIndex(self.periodSelIdx)
				end
			end
		elseif tag==2 and self.fromTableView then
			self.fromTableView:setVisible(not self.fromTableView:isVisible())
			if self.fromTableView:isVisible() then
				beVisible = true
				self.dataList = self.fromList
				self.fromTableView:reloadData()
				if self.fromSelIdx>0 then
					self.fromTableView:scrollToIndex(self.fromSelIdx)
				end
			end
		elseif tag==3 and self.toTableView then
			self.toTableView:setVisible(not self.toTableView:isVisible())
			if self.toTableView:isVisible() then
				beVisible = true
				self.dataList = self.toList
				self.toTableView:reloadData()
				if self.toSelIdx>0 then
					self.toTableView:scrollToIndex(self.toSelIdx)
				end
			end
		end
		self.maskLayer:setVisible(beVisible)
	end

	self.periodBtn = gp.Button:create("Top2Bg_V2.png", _btnCall)
	self.periodBtn:setContentSize(FUNCTION_CELL_SIZE)
	self:addChild(self.periodBtn)
	self.periodBtn:setTag(1)

	self.fromBtn = gp.Button:create("Top2Bg_V2.png", _btnCall)
	self.fromBtn:setContentSize(FUNCTION_CELL_SIZE)
	self:addChild(self.fromBtn)
	self.fromBtn:setTag(2)

	self.toBtn = gp.Button:create("Top2Bg_V2.png", _btnCall)
	self.toBtn:setContentSize(FUNCTION_CELL_SIZE)
	self:addChild(self.toBtn)
	self.toBtn:setTag(3)

	self.maskLayer = gp.BaseNode.new()
	self.maskLayer:setContentSize(gd.VISIBLE_SIZE)
	self.maskLayer:setVisible(false)
	self:addChild(self.maskLayer)

	local _tableTag = 0
	local function _cellSizeForTable(table,idx)
		_tableTag = table:getTag()
		if _tableTag==1 then
			return self.periodBtn:getContentSize(), true
		elseif _tableTag==2 then
			return self.fromBtn:getContentSize(), true
		elseif _tableTag==3 then
			return self.toBtn:getContentSize(), true
		end
	    return FUNCTION_CELL_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
	    if nil == cell then
	        cell = PeriodCell.new(FUNCTION_CELL_SIZE)
	    end
	    _tableTag = table:getTag()
		if _tableTag==1 then
			cell:changeSize(self.periodBtn:getContentSize())
		elseif _tableTag==2 then
			cell:changeSize(self.fromBtn:getContentSize())
		elseif _tableTag==3 then
			cell:changeSize(self.toBtn:getContentSize())
		end

	    local data = self.dataList[idx]
	    cell:setData(data)

	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.dataList
	end
	local function _cellTouchAtIndex(table,idx) 
	    local tag = table:getTag()
	    if tag==1 then
	    	self:setPeriodSel(idx)
	    	if self.periodCall then
	    		self.periodCall(self, idx)
	    	end
	    elseif tag==2 then
	    	self:setFromSel(idx)
	    	if self.fromToCall then
	    		self.fromToCall(self, idx, self.toSelIdx)
	    	end
	    elseif tag==3 then
	    	self:setToSel(idx)
	    	if self.fromToCall then
	    		self.fromToCall(self, self.fromSelIdx, idx)
	    	end
	    end
	    table:setVisible(false)
	    self.maskLayer:setVisible(false)
	end

	self.periodTableView = gp.TableView.new(cc.size(FUNCTION_CELL_SIZE.width+20, gd.VISIBLE_SIZE.height-40))
    self.periodTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    --self.periodTableView:setMargin(10)
	self:addChild(self.periodTableView)
	self.periodTableView:setTag(1)	
	self.periodTableView:setVisible(false)

	self.periodTableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	self.periodTableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	self.periodTableView:setHandler(_tableCellAtIndex, gd.CELL)
	self.periodTableView:setHandler(_cellTouchAtIndex, gd.CELL_TOUCH)
	

	self.fromTableView = gp.TableView.new(cc.size(FUNCTION_CELL_SIZE.width+20, gd.VISIBLE_SIZE.height-40))
	self.fromTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self:addChild(self.fromTableView)
	self.fromTableView:setTag(2)
	self.fromTableView:setVisible(false)

	self.fromTableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	self.fromTableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	self.fromTableView:setHandler(_tableCellAtIndex, gd.CELL)
	self.fromTableView:setHandler(_cellTouchAtIndex, gd.CELL_TOUCH)	

	self.toTableView = gp.TableView.new(cc.size(FUNCTION_CELL_SIZE.width+20, gd.VISIBLE_SIZE.height-40))
	self.toTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self:addChild(self.toTableView)
	self.toTableView:setTag(3)
	self.toTableView:setVisible(false)

	self.toTableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	self.toTableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	self.toTableView:setHandler(_tableCellAtIndex, gd.CELL)
	self.toTableView:setHandler(_cellTouchAtIndex, gd.CELL_TOUCH)
	
	self:_layout()
end

function UIPeriodView:_layout(  )
	local w=0
	local h=self.periodBtn:getContentSize().height
	w = w+self.periodBtn:getContentSize().width+self.fromBtn:getContentSize().width+self.toBtn:getContentSize().width+80
	w = w+self.toText:getContentSize().width+80
	
	if h<self.fromBtn:getContentSize().height then
		h = self.fromBtn:getContentSize().height
	end
	if h<self.toBtn:getContentSize().height then
		h = self.toBtn:getContentSize().height
	end
	h = h+10
	self:setContentSize(cc.size(w,h))

	_VLP(self.periodBtn, self, vl.IN_L)
	_VLP(self.fromBtn, self.periodBtn, vl.OUT_R, cc.p(30,0))
	_VLP(self.toText, self.fromBtn, vl.OUT_R, cc.p(10, 0))
	_VLP(self.toBtn, self.toText, vl.OUT_R, cc.p(10,0))
	_VLP(self.totalText, self.toBtn, vl.OUT_R, cc.p(10,0))
	self:_layoutTable()
end

function UIPeriodView:_layoutTable(  )
	_VLP(self.periodTableView, self.periodBtn, vl.OUT_B)
	_VLP(self.fromTableView, self.fromBtn, vl.OUT_B)
	_VLP(self.toTableView, self.toBtn, vl.OUT_B)
end

return UIPeriodView
