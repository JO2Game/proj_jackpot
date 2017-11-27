--[[
=================================
文件名：DCDrawResultUI.lua
作者：James Ou
=================================
]]

local DC_SIZE = cc.size(210, 98)

local DCDataCell =  class("DCDataCell", gp.TableViewCell )

function DCDataCell:ctor(callback)
	DCDataCell.super.ctor(self)
	self:setContentSize(DC_SIZE)
	local bg = gp.Scale9Sprite:create("Top2Bg_V2.png")
	bg:setContentSize(DC_SIZE)
	self:addChild(bg)
	_VLP(bg)

	self.isMark = false

	local RH = 20
	local RW = 18
	self.luckR1 = gp.Label:create("", 20, gd.FCOLOR.c12)
	self.luckR1:setAnchorPoint(cc.p(0, 0.5))
	self:addChild(self.luckR1)
	_VLP(self.luckR1, self, vl.IN_L, cc.p(RW,RH))

	self.luckR2 = gp.Label:create("", 20, gd.FCOLOR.c12)
	self.luckR2:setAnchorPoint(cc.p(0, 0.5))
	self:addChild(self.luckR2)
	_VLP(self.luckR2, self, vl.IN_L, cc.p(RW+30,RH))

	self.luckR3 = gp.Label:create("", 20, gd.FCOLOR.c12)
	self.luckR3:setAnchorPoint(cc.p(0, 0.5))
	self:addChild(self.luckR3)
	_VLP(self.luckR3, self, vl.IN_L, cc.p(RW+30*2,RH))

	self.luckR4 = gp.Label:create("", 20, gd.FCOLOR.c12)
	self.luckR4:setAnchorPoint(cc.p(0, 0.5))
	self:addChild(self.luckR4)
	_VLP(self.luckR4, self, vl.IN_L, cc.p(RW+30*3,RH))

	self.luckR5 = gp.Label:create("", 20, gd.FCOLOR.c12)
	self.luckR5:setAnchorPoint(cc.p(0, 0.5))
	self:addChild(self.luckR5)
	_VLP(self.luckR5, self, vl.IN_L, cc.p(RW+30*4,RH))

	self.luckR6 = gp.Label:create("", 20, gd.FCOLOR.c12)
	self.luckR6:setAnchorPoint(cc.p(0, 0.5))
	self:addChild(self.luckR6)
	_VLP(self.luckR6, self, vl.IN_L, cc.p(RW+30*5,RH))

	local BH = -20
	
	local function _btnCall( btn )
		if callback then
			callback(self.info)
		end
	end
	local btn = gp.Button:create("SliderSub_V2.png", _btnCall)
	btn:setScale(0.5)
	self:addChild(btn)
	_VLP(btn, self, vl.IN_R, cc.p(-10, BH))

	self.luckB1 = gp.Label:create("", 20, gd.FCOLOR.c13)
	self.luckB1:setAnchorPoint(cc.p(1, 0.5))
	self:addChild(self.luckB1)
	_VLP(self.luckB1, btn, vl.OUT_L, cc.p(-28,0))

	self.luckB2 = gp.Label:create("", 20, gd.FCOLOR.c13)
	self.luckB2:setAnchorPoint(cc.p(1, 0.5))
	self:addChild(self.luckB2)
	_VLP(self.luckB2, self.luckB1, vl.OUT_L, cc.p(-12,0))

end

function DCDataCell:setData(data)
	self.info = data

	self.luckR1:setString(string.format("%02d",data[1]))
	self.luckR2:setString(string.format("%02d",data[2]))
	self.luckR3:setString(string.format("%02d",data[3]))
	self.luckR4:setString(string.format("%02d",data[4]))
	self.luckR5:setString(string.format("%02d",data[5]))
	self.luckR6:setString(string.format("%02d",data[6]))

	if data[7] then
		self.luckB1:setString(string.format("%02d",data[7]))
	else
		self.luckB1:setString("")
	end
	if data[8] then
		self.luckB2:setString(string.format("%02d",data[8]))
	else
		self.luckB2:setString("")
	end

end

function DCDataCell:mark( isMark )
	if self.isMark == isMark then return end
	self.isMark = isMark
	if isMark then
		local newData = GMODEL(MOD.DC):getDCMgr():getNewDCData()
		if self.info[1]==newData.r[1] then
			self.luckR1:setLabelColor(gd.FCOLOR.c18)
		else
			self.luckR1:setLabelColor(gd.FCOLOR.c12)
		end
		if self.info[2]==newData.r[2] then
			self.luckR2:setLabelColor(gd.FCOLOR.c18)
		else
			self.luckR2:setLabelColor(gd.FCOLOR.c12)
		end
		if self.info[3]==newData.r[3] then
			self.luckR3:setLabelColor(gd.FCOLOR.c18)
		else
			self.luckR3:setLabelColor(gd.FCOLOR.c12)
		end
		if self.info[4]==newData.r[4] then
			self.luckR4:setLabelColor(gd.FCOLOR.c18)
		else
			self.luckR4:setLabelColor(gd.FCOLOR.c12)
		end
		if self.info[5]==newData.r[5] then
			self.luckR5:setLabelColor(gd.FCOLOR.c18)
		else
			self.luckR5:setLabelColor(gd.FCOLOR.c12)
		end
		if self.info[6]==newData.r[6] then
			self.luckR6:setLabelColor(gd.FCOLOR.c18)
		else
			self.luckR5:setLabelColor(gd.FCOLOR.c12)
		end

		if self.info[7] and self.info[7]==newData.b1 then
			self.luckB1:setLabelColor(gd.FCOLOR.c8)
		else
			self.luckB1:setLabelColor(gd.FCOLOR.c13)
		end
		if self.info[8] and self.info[8]==newData.b1 then
			self.luckB2:setLabelColor(gd.FCOLOR.c8)
		else
			self.luckB2:setLabelColor(gd.FCOLOR.c13)
		end
	else
		self.luckR1:setLabelColor(gd.FCOLOR.c12)
		self.luckR2:setLabelColor(gd.FCOLOR.c12)
		self.luckR3:setLabelColor(gd.FCOLOR.c12)
		self.luckR4:setLabelColor(gd.FCOLOR.c12)
		self.luckR5:setLabelColor(gd.FCOLOR.c12)
		self.luckR6:setLabelColor(gd.FCOLOR.c12)

		self.luckB1:setLabelColor(gd.FCOLOR.c13)
		self.luckB2:setLabelColor(gd.FCOLOR.c13)
	end
end

local DCDrawResultUI = class("DCDrawResultUI", glg.UIDropView)

function DCDrawResultUI:ctor(title)
	DCDrawResultUI.super.ctor(self, title)	
	
	self.drawResultOptionalUI = MCLASS(MOD.DC, "DCDrawResultOptionalUI").new()
	self.drawResultOptionalUI:setVisible(false)
	self:addChild(self.drawResultOptionalUI)

	self.isMark = false
	self.dataTableView = nil	
	self.dcDataList = {}

	self:_initDateTableView()	
	self:_initBtn()
end

function DCDrawResultUI:_initDateTableView()
	local tableView = gp.TableView.new(cc.size(self:getContentSize().width-10, self:getContentSize().height-180))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setMargin(4)
	self:addChild(tableView)

	_VLP(tableView, self, vl.IN_BL, cc.p(0, 60))

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
		cell:setData(data)
		cell:mark(self.isMark)

		return cell
	end

	local function _numberOfCellsInTableView(table)
		return self.dcDataCount
	end

	tableView:setHandler(_cellSizeForTable, gd.CELL_SIZE)
	tableView:setHandler(_numberOfCellsInTableView, gd.CELL_NUMS)
	tableView:setHandler(_tableCellAtIndex, gd.CELL)

	self.dataTableView = tableView
end

function DCDrawResultUI:_initBtn()
	
	local function _btnCall( sender )
		local tag = sender:getTag()
		if tag==1 then
			if self.dcDataList and #self.dcDataList>0 then
				local function _alertCall(sender, tag)
					if tag == gd.ALERT_OK then
						GMODEL(MOD.DC):getDCStorageMgr():clearDrawResult()
						self:setupData()
					end
				end
				gp.Factory:alertViewStd(nil, _TT("dc","DC39"), _alertCall)
			end
		elseif tag==2 then
			local curState = sender:getBtnState()
			if curState==gd.BTN_SEL then
				self:mark(true)
			else
				self:mark(false)
			end
		end
	end
	local btnClear = gp.Button:create("Top2Bg_V2.png", _btnCall, "清空")
	btnClear:setContentSize(cc.size(180,38))
	btnClear:setTag(1)
	self:addChild(btnClear)
	_VLP(btnClear, self, vl.IN_B, cc.p(0,18))
	

	local btnMark = gp.SelButton:create("Top2Bg_V2.png", _btnCall, "标志")
	btnMark:setContentSize(cc.size(180,32))
	btnMark:setTag(2)
	self:addChild(btnMark)
	_VLP(btnMark, self.dataTableView, vl.OUT_T, cc.p(0, 10))

end

function DCDrawResultUI:onEnter(  )
	DCDrawResultUI.super.onEnter(self)
	
	local function _ADD_DRAW_RESULT_Handle()
		self:setupData()
	end
	gp.MessageMgr:regEvent(self.sn, ENT.DC_DRAW_RESULT, _ADD_DRAW_RESULT_Handle)
	self:setupData()
end

function DCDrawResultUI:onExit()
	gp.MessageMgr:unRegAll(self.sn)
	DCDrawResultUI.super.onExit(self)
end

function DCDrawResultUI:setupData(  )
	self.dcDataList = GMODEL(MOD.DC):getDCStorageMgr():getDrawResult()
	self.dcDataCount = #self.dcDataList
	self.title:setString(string.format("总共: %d 条", self.dcDataCount))
	self.dataTableView:reloadData()

	self.drawResultOptionalUI:setVisible(false)
	self.drawResultOptionalUI:setResultUI(nil)
end

function DCDrawResultUI:mark( isMark )
	if self.isMark==isMark then return end

	self.isMark = isMark
	self.dataTableView:reloadData()
end

return DCDrawResultUI
