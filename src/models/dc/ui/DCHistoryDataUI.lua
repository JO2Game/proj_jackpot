--[[
=================================
文件名：DCHistoryDataUI.lua
作者：James Ou
显示往期历史数据
=================================
]]
local YEAR_SIZE = cc.size(210, 60)
local DC_SIZE = YEAR_SIZE--cc.size(550, 40)

local DCDataCell =  class("DCDataCell", gp.TableViewCell )

function DCDataCell:ctor(callback)
	DCDataCell.super.ctor(self)
    self:setContentSize(DC_SIZE)

    local bg = gp.Scale9Sprite:create("Top2Bg_V2.png")
	bg:setContentSize(DC_SIZE)
	self:addChild(bg)
	_VLP(bg)
	
    self.firstLb = gp.RichLabel:create()
    self.firstLb:setAnchorPoint(cc.p(0, 0.5))
    self:addChild(self.firstLb)
    _VLP(self.firstLb, self, vl.IN_TL, cc.p(2,-4))

    self.infoLb = gp.RichLabel.new()
    self.infoLb:setAnchorPoint(cc.p(0, 0.5))
    self:addChild(self.infoLb)
    _VLP(self.infoLb, self, vl.IN_L, cc.p(6,-10))

end

local rlt1 = "[c=253,173,0 s=18]%s[/][c=3,233,255 s=18] %s[/]"
local rlt2 = "[c=252,255,168 s=18]%s[/]"

function DCDataCell:setDataInfo(info)
	--gp.table.print(info)
	---[[
	self.firstLb:setString(string.format("[c=252,255,168 s=18]%s @ %s[/]", string.sub(info.stage, 5), info.date))
	local reds = string.format("%02d,%02d,%02d,%02d,%02d,%02d",info.r[1],info.r[2],info.r[3],info.r[4],info.r[5],info.r[6])
	local number = string.format(rlt1, reds, string.format("%02d",info.b1))
	--local str = string.format(rlt2, string.sub(info.stage, 5)..":"..number..info.date)	
	self.infoLb:setString(number)
	--]]
end

local DCHistoryDataUI = class("DCHistoryDataUI", glg.UIDropView)

function DCHistoryDataUI:ctor()
	DCHistoryDataUI.super.ctor(self)

	self.yearTableView = nil
	self.dataTableView = nil

	self.yearList = {}
	self.dcStageList = {}
	self.dcDataMap = {}

	local function _btnCall( sender )
		self.dataTableView:setVisible(false)
		self.yearTableView:setVisible(true)
		sender:setVisible(false)

		self.title:setVisible(true)
		self.subTitle:setVisible(false)
	end

	self.backBtn = gp.Button:create("ReturnBtn_V2.png", _btnCall)
	self.backBtn:setScale(0.8)
	self:addChild(self.backBtn)
	_VLP(self.backBtn, self, vl.IN_TL, cc.p(0, -8))
	self.backBtn:setVisible(false)

	self:_initDateTableView()
	self:_initYearTableView()

	self.title:setString("往期数据")
	
	self.subTitle = gp.Label:create("",22)
	self.subTitle:setAnchorPoint(cc.p(0,1))
	self:addChild(self.subTitle)
	_VLP(self.subTitle, self.backBtn, vl.OUT_B_IN_L, cc.p(10,-2))
	self.subTitle:setVisible(false)
end

function DCHistoryDataUI:_initYearTableView()
	local tableView = gp.TableView.new(cc.size(YEAR_SIZE.width, self:getContentSize().height-70))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setMargin(10)
	self:addChild(tableView)
	_VLP(tableView, self, vl.IN_B, cc.p(0,10))

	local function _selYearCall( sender, year )
		self.subTitle:setString(year)
		local dcDataMap = GMODEL(MOD.DC):getDCMgr():getYearData(year)
		self.dcDataMap = dcDataMap
		if dcDataMap then
			self.dcStageList = gp.table.keys(dcDataMap)
			table.sort( self.dcStageList )
			if self.dataCountLb then
				self.dataCountLb:setString(#self.dcStageList)
			end

			self.dataTableView:reloadData()
			
			self.dataTableView:setVisible(true)
			self.yearTableView:setVisible(false)
			self.backBtn:setVisible(true)
			self.title:setVisible(false)
			self.subTitle:setVisible(true)

		end
	end

	local function _cellSizeForTable(table,idx)
	    return YEAR_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
		if nil == cell then
		    cell = glg.UICommonCell.new(YEAR_SIZE, _selYearCall)
		end
		local year = self.yearList[#self.yearList+1-idx]
		cell:setData(string.format("[%s]", year), year)

		return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.yearList
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)

	tableView:reloadData()
	self.yearTableView = tableView
end

function DCHistoryDataUI:_initDateTableView()
	local tableView = gp.TableView.new(cc.size(DC_SIZE.width, self:getContentSize().height-100))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setMargin(6)
	self:addChild(tableView)
	_VLP(tableView, self, vl.IN_B, cc.p(0,10))
	
	
	local function _cellSizeForTable(table,idx)
	    return DC_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)

	    if nil == cell then
	        cell = DCDataCell.new()
	    end
	    local key = self.dcStageList[#self.dcStageList+1-idx]
	    cell:setDataInfo(self.dcDataMap[key])

	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.dcStageList
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)

	self.dataTableView = tableView
end


function DCHistoryDataUI:onEnter(  )
	DCHistoryDataUI.super.onEnter(self)
	
	self.yearList = GMODEL(MOD.DC):getDCMgr():getYears()
	self.yearTableView:reloadData()
	self.dcStageList = {}
	self.dcDataMap = {}
	self.dataTableView:reloadData()
end

return DCHistoryDataUI
