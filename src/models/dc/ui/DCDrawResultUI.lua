--[[
=================================
文件名：DCDrawResultUI.lua
作者：James Ou
=================================
]]

local DC_SIZE = cc.size(210, 40)

local DCDataCell =  class("DCDataCell", gp.TableViewCell )

function DCDataCell:ctor(callback)
	DCDataCell.super.ctor(self)
    self:setContentSize(DC_SIZE)

    self.infoLb = gp.Label:create("", 20)
    self.infoLb:setAnchorPoint(cc.p(0, 0.5))
    self:addChild(self.infoLb)
    _VLP(self.infoLb, self, vl.IN_L, cc.p(4,0))

    local function _btnCall( btn )
    	if callback then
    		callback(self.info)
    	end
    end
    local btn = gp.Button:create("SliderSub_V2.png", _btnCall)
    btn:setScale(0.5)
	self:addChild(btn)
	_VLP(btn, self, vl.IN_R)
end

function DCDataCell:setDataInfo(info)
	--gp.table.print(info)
	---[[
	local reds = string.format("%02d,%02d,%02d,%02d,%02d,%02d",info[1],info[2],info[3],info[4],info[5],info[6])
	self.infoLb:setString(reds)
	self.info = info
	--]]
end

local DCDrawResultUI = class("DCDrawResultUI", glg.UIDropView)

function DCDrawResultUI:ctor(title)
	DCDrawResultUI.super.ctor(self, title)	
	
	self.dataTableView = nil	
	self.dcDataList = {}

	self:_initDateTableView()	
	self:_initBtn()
end

function DCDrawResultUI:_initDateTableView()
	local tableView = gp.TableView.new(cc.size(self:getContentSize().width-10, self:getContentSize().height-140))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setMargin(4)
	self:addChild(tableView)

	_VLP(tableView, self, vl.IN_BL, cc.p(0, 10))

	local function _cellHitCall( dcData )
		GMODEL(MOD.DC):getDCStorageMgr():removeDrawData(dcData)
		self:setupData()
	end

	local function _cellSizeForTable(table,idx)
	    return DC_SIZE, true--(返回的布尔值是为告诉TableView,是否每个cell的大小一样)
	end

	local function _tableCellAtIndex(table, idx, cell)
	    if nil == cell then
	        cell = DCDataCell.new(_cellHitCall)
	    end
	    local data = self.dcDataList[#self.dcDataList+1-idx]
	    cell:setDataInfo(data)

	    return cell
	end

	local function _numberOfCellsInTableView(table)
	    return #self.dcDataList
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)

	self.dataTableView = tableView
end

function DCDrawResultUI:_initBtn()
	
	local function _btnCall( sender )
		if self.dcDataList and #self.dcDataList>0 then
			local function _alertCall(sender, tag)
				if tag == gd.ALERT_OK then
					GMODEL(MOD.DC):getDCStorageMgr():clearDrawResult()
					self:setupData()
				end
			end
			gp.Factory:alertViewStd(nil, _TT("dc","DC39"), _alertCall)
		end
	end
	local btnClear = gp.Button:create("Top2Bg_V2.png", _btnCall, true, "清空")
	--btn1:setTitleArg("", -1, gd.FCOLOR.c12, 2, gd.FCOLOR.c9)	
	btnClear:setContentSize(cc.size(180,38))	
	self:addChild(btnClear)
	_VLP(btnClear, self, vl.IN_TL, cc.p(10, -80))
	
end

function DCDrawResultUI:onEnter(  )
	DCDrawResultUI.super.onEnter(self)
	
	local function _ADD_DRAW_RESULT_Handle()
		self:setupData()
	end
	gp.MessageMgr:registerEvent(self.sn, gei.DC_DRAW_RESULT, _ADD_DRAW_RESULT_Handle)
	self:setupData()
end

function DCDrawResultUI:onExit()
	gp.MessageMgr:unRegisterAll(self.sn)
	DCDrawResultUI.super.onExit(self)
end

function DCDrawResultUI:setupData(  )
	self.dcDataList = GMODEL(MOD.DC):getDCStorageMgr():getDrawResult()
	self.dcDataCount = #self.dcDataList
	self.title:setString(string.format("总共: %d 条", self.dcDataCount))
	self.dataTableView:reloadData()
end


return DCDrawResultUI
