
local UISubWin = class("UISubWin", gp.BaseNode)

function UISubWin:ctor(title)
	UISubWin.super.ctor(self)
	self:setCatchTouch(true)
	self:setGrayBackgroundEnable(true)
	self:setContentSize(cc.size(gd.VISIBLE_SIZE.width-100, gd.VISIBLE_SIZE.height-60))

	local bg = gp.Scale9Sprite:create("gui_box5.png")
	bg:setContentSize(self:getContentSize())
	self:addChild(bg)
	_VLP(bg)
	
	local function _btnCall( sender )
		JOWinMgr:Instance():removeWin(self)
	end

	local backBtn = gp.Button:create("gui_btn7.png", _btnCall)
	self:addChild(backBtn)
	_VLP(backBtn, self, vl.IN_TR, cc.p(0, 0))

	self.title = gp.Label:create("", 30, gd.FCOLOR.c1)
	self.title:setAnchorPoint(0,1)
	self:addChild(self.title)
	_VLP(self.title, self, vl.IN_TL, cc.p(10,-4))
	self:setTitle(title)
end

function UISubWin:setTitle(title)
	if title then
		self.title:setString(title)
	end
end

function UISubWin:onTouchBegan(touch, event)
	local ret = UISubWin.super.onTouchBegan(self, touch, event)
	self.touchIn = ret
	return true
end

function UISubWin:onTouchEnded(touch, event)
	--[[
	if self.touchIn==false and self:hitTouch(touch) == false then
		self:removeFromParent()
	end
	--]]
end

return UISubWin

