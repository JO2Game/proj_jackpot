
local UIMainWin = class("UIMainWin", gp.BaseNode)

function UIMainWin:ctor()
	UIMainWin.super.ctor(self)
	self:setCatchTouch(true)
	self:setContentSize(gd.VISIBLE_SIZE)

	local bg = gp.Scale9Sprite:create("PanelLabel_V2.png")
	bg:setContentSize(gd.VISIBLE_SIZE)
	self:addChild(bg)
	_VLP(bg)
	
	-- local function _btnCall( sender )
	-- 	JOWinMgr:Instance():removeWin(self)
	-- end

	-- local backBtn = gp.Button:create("gui_btn7.png", _btnCall)
	-- self:addChild(backBtn)
	-- _VLP(backBtn, self, vl.IN_TR, cc.p(0, 0))
end


return UIMainWin

