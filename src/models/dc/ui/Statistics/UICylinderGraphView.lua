--[[
=================================
文件名：UICylinderGraphView.lua
作者：James Ou
=================================
]]

local HIGHT_COLOR = cc.c4f(0.5,0.1,0.1,1)
local NOR_COLOR = cc.c4f(0.3,0.3,0.3,1)
local LOW_COLOR = cc.c4f(0.1,0.5,0.1,1)

local GraphCell =  class("GraphCell", gp.TableViewCell )

function GraphCell:ctor(size, horizontalLineColor, verticalLineColor)
	GraphCell.super.ctor(self)
	self:setContentSize(size)
	self.selfSize = size

	self.horizontalLineColor = horizontalLineColor
	self.verticalLineColor = verticalLineColor
	self.ballText = gp.Label:create("0", 16, gd.FCOLOR.c7)
	--self.ballText:setOutline(2, gd.FCOLOR.c9)
	self.ballText:setAnchorPoint(cc.p(0.5, 0))
	self:addChild(self.ballText)

	self.totalText = gp.Label:create("", 18, gd.FCOLOR.c6)
	--self.totalText:setOutline(2, gd.FCOLOR.c9)
	self.totalText:setAnchorPoint(cc.p(1, 1))
	self:addChild(self.totalText)

	self.drawNode = cc.DrawNode:create(1)
    self:addChild(self.drawNode)

	self:_layout()
end

function GraphCell:setData(size, bottom, center, percent, radius, color)
	if size.width~=self.selfSize.width or size.height~=self.selfSize.height then
		self.selfSize = size
		self:setContentSize(size)
		_layout()
	end
	self.ballText:setString(bottom)
	self.totalText:setString(center)

	self.drawNode:clear()

	if self.horizontalLineColor then
		self.drawNode:drawLine(cc.p(0, self.ballText:getContentSize().height+1), cc.p(self.selfSize.width, self.ballText:getContentSize().height+1), self.horizontalLineColor)
	end
	if self.verticalLineColor then
		self.drawNode:drawLine(cc.p(self.selfSize.width-2, 0), cc.p(self.selfSize.width-2, self.selfSize.height), self.verticalLineColor)
	end

	local startH = 20+self.ballText:getContentSize().height
	self.drawNode:drawSegment(cc.p(self.selfSize.width*0.5, startH), cc.p(self.selfSize.width*0.5, startH+(self.selfSize.height-startH)*0.88*percent*0.01), radius, color)
end

function GraphCell:_layout()
	_VLP(self.ballText, self, vl.IN_B)
	_VLP(self.totalText, self, vl.IN_TR, cc.p(-2,0))
	_VLP(self.drawNode, self, vl.IN_BL)
end


local UICylinderGraphView = class("UICylinderGraphView", gp.BaseNode)

function UICylinderGraphView:ctor(size)
	UICylinderGraphView.super.ctor(self, size)
	self:setContentSize(size)

	self.horizontalLineColor = nil
	self.verticalLineColor = nil
	
	self.colorInPercentList = {}
	self.dataSource = nil
	self.dataSourceNumCall = nil
	self.cellSize = cc.size(40, 100)
	self.radius = 6

	self:_initGraphTable()	
end

function UICylinderGraphView:setSize(size)
	self:setContentSize(size)
	self.graphTableView:setViewSize(size)
	_VLP(self.graphTableView)
end
--[[
必须调用处理的三个方法
]]
function UICylinderGraphView:setDataSource( call )
	self.dataSource = call
end

function UICylinderGraphView:setSourceNumberCall( call )
	self.dataSourceNumCall = call
end

function UICylinderGraphView:setCellSize( size )
	self.cellSize = size
end

--[[
为nil,即不进行划线
其为c4f,内里最大值为1,不是255
]]
function UICylinderGraphView:setLineColor( horizontalColor, verticalColor )
	self.horizontalLineColor = horizontalColor
	self.verticalLineColor = verticalColor
end

local function _sort( a, b )
	if a.percent>b.percent then
		return true
	end
	return false
end
--[[
百分比在对应的数值之下,即产生相对颜色,
所有参数percent中,必须要有一个100,
不调用有默认处理
]]
function UICylinderGraphView:addCylinderColorInPercent( color, percent, beGradient )
	local d = {}
	d.color = color
	d.percent = percent
	d.beGradient = beGradient
	table.insert(self.colorInPercentList, d)
	table.sort( self.colorInPercentList, _sort )
end

function UICylinderGraphView:clearCylinderColorInPercent(  )
	self.colorInPercentList = {}
end

function UICylinderGraphView:setRadius( radius )
	self.radius = radius or 6
end

function UICylinderGraphView:reloadData(  )
	self.graphTableView:reloadData()
end

function UICylinderGraphView:_initGraphTable(  )	
	self.graphTableView = gp.TableView.new(self:getContentSize())
	self.graphTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	self:addChild(self.graphTableView)	
	_VLP(self.graphTableView)

	local function _cellSizeForTable(table,idx)		
	    return self.cellSize, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
	    if nil == cell then
	        cell = GraphCell.new(self.cellSize, self.horizontalLineColor, self.verticalLineColor)
	    end
	    if self.dataSource then
	    	local bottom, center, percent = self.dataSource(self, idx)
	    	if bottom==nil then
	    		LOG_WARN("UICylinderGraphView", "bottom==nil !!!")
	    		bottom = ""
	    	end
	    	if center==nil then
	    		LOG_WARN("UICylinderGraphView", "center==nil !!!")
	    		center = ""
	    	end
	    	if percent==nil then
	    		LOG_WARN("UICylinderGraphView", "percent==nil !!!")
	    		percent = 0
	    	end
	    	cell:setData(self.cellSize, bottom, center, percent, self.radius, self:_getPercentColor(percent))
	    end	    	    

	    return cell
	end

	local function _numberOfCellsInTableView(table)
		if self.dataSourceNumCall then
			return self.dataSourceNumCall(self)
		end
	    return 0
	end

	self.graphTableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	self.graphTableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	self.graphTableView:setHandler(_tableCellAtIndex, gd.CELL)
end

function UICylinderGraphView:_getPercentColor( percent )
	local colorData = nil
	for _,v in ipairs(self.colorInPercentList) do		
		if v.percent > percent then
			colorData = v
			break
		end
	end
	local r, g, b
	if colorData then
		if colorData.beGradient==true then
			r = colorData.color.r
			g = colorData.color.g
			b = colorData.color.b
			r = r+percent*0.01+math.random(0.1,0.2)
			r = r-math.ceil(r);
			g = g+percent*0.01+math.random(0.1,0.2)
			g = g-math.ceil(g);
			b = b+percent*0.01+math.random(0.1,0.2)
			b = b-math.ceil(b);
			return cc.c4f(r,g,b,1)
		else
			return colorData.color
		end
	else
		if percent<31 then
			r = LOW_COLOR.r
			g = LOW_COLOR.g
			b = LOW_COLOR.b
		elseif percent<62 then
			r = NOR_COLOR.r
			g = NOR_COLOR.g
			b = NOR_COLOR.b
		else
			r = HIGHT_COLOR.r
			g = HIGHT_COLOR.g
			b = HIGHT_COLOR.b
		end
		r = r+percent*0.01+math.random(0.1,0.2)
		r = r-math.ceil(r);
		g = g+percent*0.01+math.random(0.1,0.2)
		g = g-math.ceil(g);
		b = b+percent*0.01+math.random(0.1,0.2)
		b = b-math.ceil(b);
		return cc.c4f(r,g,b,1)
	end
end


return UICylinderGraphView
