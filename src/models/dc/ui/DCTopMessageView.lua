--[[
顶层的UI
显示快捷功能键
最新一期的开彩数据
--]]

local DCTopMessageView = class("DCTopMessageView", gp.BaseNode)

function DCTopMessageView:ctor()
	DCTopMessageView.super.ctor(self)

	local selfSize = cc.size(gd.VISIBLE_SIZE.width, 80)	
	self:setContentSize(selfSize)
	
	local bg = gp.Scale9Sprite:create("PanelBg_V2.png")
	bg:setContentSize(selfSize)
	self:addChild(bg)
	_VLP(bg)

	local function _btnCloseCall( sender )
		JOWinMgr:Instance():removeWin(self:getParent())
	end

	local btnClose = gp.Button:create("CancelBtn_V2.png", _btnCloseCall)
	self:addChild(btnClose)
	_VLP(btnClose, self, vl.IN_R, cc.p(-10,6))

	local function _dropViewCloseCall( sender, btn )
		if btn then
			btn:setBtnState(gd.BTN_NOR)
			self:removeFunctWin(btn:getTag())
			if #self.selBtns==0 then
				self.optionalResultView:setVisible(false)
			end
		end
	end
	self.selBtns = {}
	local function _btnCall( sender )
		local tag = sender:getTag()
		local curState = sender:getBtnState()
		if curState==gd.BTN_SEL then
			if #self.selBtns>=1 then
				local oldBtn = self.selBtns[1]
				oldBtn:setBtnState(gd.BTN_NOR)
				self:removeFunctWin(oldBtn:getTag())
			end
			table.insert(self.selBtns, sender)
			if tag==1 then
				self.historyView:setVisible(true)
			elseif tag==2 then
				self.conditionView:setVisible(true)
				self.conditionView:setupData()
			elseif tag==3 then
				self.optionalView:setVisible(true)
				self.optionalView:setupData()
			end
		elseif curState==gd.BTN_NOR then
			self:removeFunctWin(tag)
			if #self.selBtns==0 then
				self.optionalResultView:setVisible(false)
			end
		end
		if self.drawResultUI:isVisible() then
			--[[
			if #self.selBtns>0 then
				_VLP(self.drawResultUI, self, vl.OUT_B_IN_R, cc.p(0,16))
			else
				_VLP(self.drawResultUI, self, vl.OUT_B_IN_L, cc.p(0,16))
			end
			--]]
		end
	end

	local btn1 = gp.SelButton:create("Btn_Small_Gold.png", _btnCall)
	btn1:setTag(1)
	btn1:setScale(0.96)
	btn1:setTitle("历史")
	self:addChild(btn1)

	local btn2 = gp.SelButton:create("Btn_Small_Gold.png", _btnCall)
	btn2:setTag(2)
	btn2:setScale(0.96)
	btn2:setTitle("条件")
	self:addChild(btn2)

	local btn3 = gp.SelButton:create("Btn_Small_Gold.png", _btnCall)
	btn3:setTag(3)
	btn3:setScale(0.96)
	btn3:setTitle("自选")
	self:addChild(btn3)

	local function _drawResultCall()
		if self.drawResultUI:isVisible() then
			self.drawResultUI:setVisible(false)
		else
			self.drawResultUI:setVisible(true)
			self.drawResultUI:setupData()
			--[[
			if #self.selBtns>0 then
				_VLP(self.drawResultUI, self, vl.OUT_B_IN_R, cc.p(0,16))
			else
				_VLP(self.drawResultUI, self, vl.OUT_B_IN_L, cc.p(0,16))
			end
			--]]
		end
	end

	local btn4 = gp.Button:create("Img_Character_jiantou.png", _drawResultCall)
	btn4:setTag(4)
	self:addChild(btn4)
	

	_VLP(btn1, self, vl.IN_L, cc.p(10,6))
	_VLP(btn2, btn1, vl.OUT_R, cc.p(10,0))
	_VLP(btn3, btn2, vl.OUT_R, cc.p(10,0))
	_VLP(btn4, btnClose, vl.OUT_L, cc.p(-20,0))

	self.historyView = MCLASS(MOD.DC, "DCHistoryDataUI").new()--glg.UIDropView.new()
	self.historyView:setCloseCall(_dropViewCloseCall, btn1)
	self:addChild(self.historyView)
	_VLP(self.historyView, self, vl.OUT_B_IN_L, cc.p(0,16))
	self.historyView:setVisible(false)

	self.conditionView = MCLASS(MOD.DC, "DCConditionUI").new()--glg.UIDropView.new()
	self.conditionView:setCloseCall(_dropViewCloseCall, btn2)
	self:addChild(self.conditionView)
	_VLP(self.conditionView, self, vl.OUT_B_IN_L, cc.p(0,16))
	self.conditionView:setVisible(false)

	self.optionalView = MCLASS(MOD.DC, "DCOptionalDataUI").new()--glg.UIDropView.new()
	self.optionalView:setCloseCall(_dropViewCloseCall, btn3)
	self:addChild(self.optionalView)
	_VLP(self.optionalView, self, vl.OUT_B_IN_L, cc.p(0,16))
	self.optionalView:setVisible(false)

	local function _dropOptionalResultCloseCall( sender )
		self.optionalResultView:setVisible(false)
	end
	self.optionalResultView = MCLASS(MOD.DC, "DCOptionalResultUI").new()
	self.optionalResultView:setCloseCall(_dropOptionalResultCloseCall)
	self:addChild(self.optionalResultView)
	_VLP(self.optionalResultView, self, vl.OUT_B_IN_L, cc.p(self.optionalView:getContentSize().width, 16))
	self.optionalResultView:setVisible(false)

	local function _drawResultClose()
		self.drawResultUI:setVisible(false)
	end
	self.drawResultUI = MCLASS(MOD.DC, "DCDrawResultUI").new()
	self.drawResultUI:setCloseCall(_drawResultClose)
	self:addChild(self.drawResultUI)
	_VLP(self.drawResultUI, self, vl.OUT_B_IN_R, cc.p(0,16))
	self.drawResultUI:setVisible(false)

	self.newDataLb = gp.Label:create()
	self.newDataLb:setAnchorPoint(cc.p(1,0))
	self:addChild(self.newDataLb)
	_VLP(self.newDataLb, btn4, vl.OUT_L, cc.p(-18,0))

	local function _sycnDataBtnCall(sender)
		GMODEL(MOD.DC):updateDCData()
		self.sycnBtn:setCatchTouch(false)
		self.sycnBtn:runAction(cc.Sequence:create(cc.RotateBy:create(1, 360), cc.CallFunc:create(function(sender) self.sycnBtn:setCatchTouch(true) end )))
	end
	self.sycnBtn = gp.Button:create("Loading_V2.png", _sycnDataBtnCall)
	self.sycnBtn:setScale(0.6)
	self:addChild(self.sycnBtn)
	_VLP(self.sycnBtn, self.newDataLb, vl.OUT_L, cc.p(-20, 0))
end

function DCTopMessageView:removeFunctWin( tag )
	for i,v in ipairs(self.selBtns) do
		if v:getTag()==tag then
			table.remove(self.selBtns, i)
			break
		end
	end
	if tag==1 and self.historyView then
		self.historyView:setVisible(false)
	elseif tag==2 and self.conditionView then
		self.conditionView:setVisible(false)
	elseif tag==3 then
		self.optionalView:setVisible(false)
	end
end

--最新一期的开彩数据
function DCTopMessageView:setNewData(newData)
	self.newDataLb:setString(newData)
	_VLP(self.sycnBtn, self.newDataLb, vl.OUT_L, cc.p(-20, 0))
end

function DCTopMessageView:onDelete()
	
	DCTopMessageView.super.onDelete(self)
end

function DCTopMessageView:onEnter()
	DCTopMessageView.super.onEnter(self)
	
end

function DCTopMessageView:onExit()
	DCTopMessageView.super.onExit(self)
end


return DCTopMessageView

