--[[
=================================
文件名： DCDrawResultOptionalUI.lua
作者： James Ou
分析结果的操作面板
=================================
]]


local DCDrawResultOptionalUI = class("DCDrawResultOptionalUI", glg.UIDropView)

function DCDrawResultOptionalUI:ctor(title)
	DCDrawResultOptionalUI.super.ctor(self, title)	
	
	local function _btnCall( sender )
		if self.resultUI==nil then return end

		local tag = sender:getTag()
		if tag==1 then
			self.resultUI:setBule(1)
		elseif tag==2 then
			self.resultUI:setBule(2)
		elseif tag==3 then
			self.resultUI:saveBule(2)
		elseif tag==4 then
			self.resultUI:mark(true)
		elseif tag==5 then
			self.resultUI:mark(false)
		end
	end
		

	local btnBlue1 = gp.Button:create("Top2Bg_V2.png", _btnCall, "蓝1")
	btnBlue1:setContentSize(cc.size(180,38))
	btnBlue1:setTag(1)
	self:addChild(btnBlue1)
	_VLP(btnBlue1, self, vl.IN_T, cc.p(0, -60))

	local btnBlue2 = gp.Button:create("Top2Bg_V2.png", _btnCall, "蓝2")
	btnBlue2:setContentSize(cc.size(180,38))
	btnBlue2:setTag(2)
	self:addChild(btnBlue2)
	_VLP(btnBlue2, btnBlue1, vl.OUT_B, cc.p(0, -20))

	local btnSaveBlue = gp.Button:create("Top2Bg_V2.png", _btnCall, "保存蓝球")
	btnSaveBlue:setContentSize(cc.size(180,38))
	btnSaveBlue:setTag(3)
	self:addChild(btnSaveBlue)
	_VLP(btnSaveBlue, btnBlue2, vl.OUT_B, cc.p(0, -20))

	local btnMark = gp.Button:create("Top2Bg_V2.png", _btnCall, "标志号码")
	btnMark:setContentSize(cc.size(180,38))
	btnMark:setTag(4)
	self:addChild(btnMark)
	_VLP(btnMark, btnSaveBlue, vl.OUT_B, cc.p(0, -40))

	local btnCancelMark = gp.Button:create("Top2Bg_V2.png", _btnCall, "取消标志")
	btnCancelMark:setContentSize(cc.size(180,38))
	btnCancelMark:setTag(5)
	self:addChild(btnCancelMark)
	_VLP(btnCancelMark, btnMark, vl.OUT_B, cc.p(0, -20))
	
end

function DCDrawResultOptionalUI:setResultUI( resultUI )
	self.resultUI = resultUI
end

function DCDrawResultOptionalUI:onEnter(  )
	DCDrawResultOptionalUI.super.onEnter(self)
		
end

function DCDrawResultOptionalUI:onExit()
	self.resultUI = nil
	DCDrawResultOptionalUI.super.onExit(self)
end



return DCDrawResultOptionalUI
