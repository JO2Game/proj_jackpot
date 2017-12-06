
local UIDropView = class("UIDropView", gp.BaseNode)

function UIDropView:ctor()
	UIDropView.super.ctor(self)
	self:setCatchTouch(true)
	local selfSize = cc.size(220, gd.VISIBLE_SIZE.height-74+12)
	self:setContentSize(selfSize)
	
	local bg = gp.Scale9Sprite:create("selectionTags_sc.png")
	--local bg = gp.Scale9Sprite:create("StoryCase_V2.png")
	bg:setContentSize(selfSize)
	self:addChild(bg)
	_VLP(bg)

	self.title = gp.Label:create("", 20)
	self.title:setAnchorPoint(cc.p(0,1))
	self:addChild(self.title)
	_VLP(self.title, self, vl.IN_TL, cc.p(0,-8))
	
	local function _btnCall( sender )
		if self.closeCall then
			self.closeCall(self, self.closeData)
		else
			JOWinMgr:Instance():removeWin(self)
		end
		--JOWinMgr:Instance():removeWin(self)
	end

	local closeBtn = gp.Button:create("CancelBtn_V2.png", _btnCall)
	closeBtn:setScale(0.8)
	self:addChild(closeBtn)
	_VLP(closeBtn, self, vl.IN_TR, cc.p(0, -8))
end

function UIDropView:setCloseCall( call, data )
	self.closeCall = call
	self.closeData = data
end

return UIDropView

