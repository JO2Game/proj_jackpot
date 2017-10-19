local FUNCTION_SIZE = cc.size(340, 80)

local WorldScene = class("WorldScene", gp.BaseNode)

function WorldScene:ctor()
	WorldScene.super.ctor(self)
	self:setCatchTouch(true)
	self:setContentSize(gd.VISIBLE_SIZE)	

	local bg = gp.Scale9Sprite:create("gui_box8.png")
	bg:setContentSize(gd.VISIBLE_SIZE)
	self:addChild(bg)
	_VLP(bg)

	self.functList = {}

	self:_initFunctionList()
	self:_initTableView()
end

function WorldScene:_initTableView()	
	local tableView = gp.TableView.new(cc.size(gd.VISIBLE_SIZE.width-80, gd.VISIBLE_SIZE.height-80))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setMargin(20)
	self:addChild(tableView)
	_VLP(tableView, self)

	local function _cellTouchCall(sender, idx)
		local data = self.functList[idx]
		if data then
			data.f()
		end
	end
	local function _cellSizeForTable(table,idx)
	    return FUNCTION_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)

	    if nil == cell then
	        cell = glg.UICommonCell.new(FUNCTION_SIZE, _cellTouchCall)
	    end
	    local data = self.functList[idx]
	    cell:setData(data.t, idx)

	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.functList
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)
	
	tableView:reloadData()

end

function WorldScene:_initFunctionList()
	table.insert(self.functList,
		{t=_TT("dc","WORLD1"), f=function()
			GMODEL(MOD.DC):showDCBallUI()
		end}
	)
end

return WorldScene

