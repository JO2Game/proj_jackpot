--[[
=================================
文件名：UICurveGraphView.lua
作者：James Ou
=================================
]]

local DataCell =  class("DataCell", gp.TableViewCell )

function DataCell:ctor(size)
	DataCell.super.ctor(self)
	self:setContentSize(size)

	self.title = gp.Label:create("", 18, gd.FCOLOR.c12)
	--self.title:setOutline(2, gd.FCOLOR.c9)
	self.title:setAnchorPoint(cc.p(1, 0.5))
	self:addChild(self.title)
	_VLP(self.title, self, vl.IN_R)
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

local UICurveGraphView = class("UICurveGraphView", gp.BaseNode)

function UICurveGraphView:ctor(size)
	UICurveGraphView.super.ctor(self, size)
	self:setContentSize(size)

	self.scrollSize = cc.size(0,0)
	self.leftDataSize = cc.size(50, 30)
	self.leftDataColor = gd.FCOLOR.c12
	self.leftFontSize = 18
	self.leftDataSource = nil
	self.leftDataSourceNumber = 0

	self.bottomDataSize = cc.size(50, 30)
	self.bottomDataColor = gd.FCOLOR.c13
	self.bottomFontSize = 18
	self.bottomDataSource = nil
	self.bottomDataSourceNumber = 0
	
	self:_initCurveScrollView()
	
	self:_layout()
end

function UICurveGraphView:setSize(size)
	self:setContentSize(size)
	self:_layout()
end
--[[
必须调用处理
]]
function UICurveGraphView:setLeft_BottomDataSourceInfo( leftNumber, leftCellSize, bottomNumber, bottomCellSize )
	self.leftDataSourceNumber = leftNumber
	self.bottomDataSourceNumber = bottomNumber

	self.leftDataSize = leftCellSize
	self.bottomDataSize = bottomCellSize
	self.scrollSize = cc.size(bottomCellSize.width*(bottomNumber+1), leftCellSize.height*(leftNumber+0.5))
end

function UICurveGraphView:setLeftDataSource( call )
	self.leftDataSource = call
end

function UICurveGraphView:setBottomDataSource( call )
	self.bottomDataSource = call
end

function UICurveGraphView:setCurveDataSource( call )
	self.curveDataSource = call
end
--[[
可以不调用，有默认
]]
function UICurveGraphView:setLeftDataFontInfo( color, fontSize )	
	self.leftDataColor = color
	self.leftFontSize = fontSize
end
function UICurveGraphView:setBottomDataFontInfo( color, fontSize )	
	self.bottomDataColor = color
	self.bottomFontSize = fontSize
end

function UICurveGraphView:reloadData(  )	
	self:_reloadScroll()
	self.scrollLeftTableView:reloadData()
	self.scrollBottomTableView:reloadData()
end

function UICurveGraphView:_initCurveScrollView(  )
	self.scroll = gp.ScrollView:new()
	self:addChild(self.scroll)
	self.scroll:setAnchorPoint(cc.p(0.5,0.5))
	self.scroll:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)	
	self.scroll:setDelegate()
	self.scroll:registerScriptHandler(function (view)
		self:_scrollViewDidScroll(view)
	end,cc.SCROLLVIEW_SCRIPT_SCROLL)

	self.scrollDraw = cc.DrawNode:create(1)
	self.scroll:addChild(self.scrollDraw)

	self.scrollLeftTableView = gp.TableView.new(cc.size(40, 10))
	self.scrollLeftTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	self.scrollLeftTableView:setMargin(0)
	self.scrollLeftTableView:setCatchTouch(false)
	self:addChild(self.scrollLeftTableView)		

	local function _cellSizeForTable(table,idx)
	    return self.leftDataSize, true
	end

	local function _tableCellAtIndex(table, idx, cell)
	    if nil == cell then
	        cell = DataCell.new(self.leftDataSize)
	    end

	    if self.leftDataSource then
	    	local str = self.leftDataSource(self, idx)
	    	cell:setString(str, self.leftFontSize, self.leftDataColor)
	    end
	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return self.leftDataSourceNumber
	end

	self.scrollLeftTableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	self.scrollLeftTableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	self.scrollLeftTableView:setHandler(_tableCellAtIndex, gd.CELL)

	self.scrollBottomTableView = gp.TableView.new(cc.size(20, 10))
	self.scrollBottomTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	self.scrollBottomTableView:setMargin(0)
	self.scrollBottomTableView:setCatchTouch(false)
	self:addChild(self.scrollBottomTableView)	

	local function _cellSizeForTable1(table,idx)
	    return self.bottomDataSize, true
	end

	local function _tableCellAtIndex1(table, idx, cell)
	    if nil == cell then
	        cell = DataCell.new(self.bottomDataSize)
	    end
	    if self.bottomDataSource then
	    	local str = self.bottomDataSource(self, idx)
	    	cell:setString(str, self.bottomFontSize, self.bottomDataColor)
	    end
	    return cell
	end

	local function _numberOfCellsInTableView1(table)
	    return self.bottomDataSourceNumber
	end

	self.scrollBottomTableView:setHandler(_cellSizeForTable1, gd.CELL_SIZE)
	self.scrollBottomTableView:setHandler(_numberOfCellsInTableView1, gd.CELL_NUMS)
	self.scrollBottomTableView:setHandler(_tableCellAtIndex1, gd.CELL)
end

function UICurveGraphView:_scrollViewDidScroll( view )
	--LOG_DEBUG("", gp.table.tostring(self.scroll:getContentOffset()))
	self.scrollLeftTableView:setContentOffset(cc.p(self.scrollLeftTableView:getContentOffset().x, self.scroll:getContentOffset().y))--+self.leftDataSize.height*0.5))
	self.scrollBottomTableView:setContentOffset(cc.p(self.scroll:getContentOffset().x, self.scrollBottomTableView:getContentOffset().y))
end

function UICurveGraphView:_layout(  )
	local selfSize = self:getContentSize()
	local contentW = selfSize.width
	local contentH = selfSize.height

	self.scrollLeftTableView:setViewSize(cc.size(self.leftDataSize.width,contentH-self.bottomDataSize.height))
	self.scrollBottomTableView:setViewSize(cc.size(contentW-self.leftDataSize.width, self.bottomDataSize.height))
	self.scroll:setViewSize(cc.size(contentW-self.leftDataSize.width-10, contentH-self.bottomDataSize.height-4))

	_VLP(self.scrollLeftTableView, self, vl.IN_BL, cc.p(0,self.bottomDataSize.height))	
	_VLP(self.scroll, self.scrollLeftTableView, vl.OUT_R_IN_T, cc.p(10,0))
	_VLP(self.scrollBottomTableView, self.scroll, vl.OUT_B_IN_L, cc.p(0,4))
end

function UICurveGraphView:_reloadScroll(  )	
	if self.curveDataSource then
		self.scrollDraw:clear()
		self.scroll:setContentSize(self.scrollSize)

		local startY = 0
		local lColor = nil
		local sPos = nil
		local cPos = nil
		local dotRadius = 4
		for row=1,self.leftDataSourceNumber do
			sPos = nil
			local startY = self.scrollSize.height-self.leftDataSize.height*(row)
			lColor = cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1)
			for col=1,self.bottomDataSourceNumber do
				if self.curveDataSource(self, row, col)==true then
					cPos = cc.p(self.bottomDataSize.width*(col-1)+dotRadius, startY+self.leftDataSize.height*0.5)
				else
					cPos = cc.p(self.bottomDataSize.width*(col-1)+dotRadius, startY)
				end
				self.scrollDraw:drawDot(cPos, dotRadius, cc.c4f(1, 0.5, 0.8, 1))
				if sPos~=nil then
					self.scrollDraw:drawLine(sPos, cPos, lColor)
				end
				sPos = cPos
			end
		end
		self.scroll:setContentOffset(self.scroll:minContainerOffset())
		--self.scroll:setContentOffset(cc.p(0, self.scroll:minContainerOffset().y))
		self.scrollDraw:setPosition(cc.p(0,0))

		self.scrollLeftTableView:scrollToTop()
		self.scrollBottomTableView:scrollToBottom()
	end
end

return UICurveGraphView
